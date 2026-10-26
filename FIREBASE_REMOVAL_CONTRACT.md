# Firebase removal: contract between the Customer app, the backend and the Driver app

Written for: the developer updating the **Taxi partner app** and the backend owner.
Customer app state: Firebase (core, Firestore, messaging, storage, dynamic links, analytics) is fully removed.

## 0. Scope: three different partner services (do not merge them)

The platform has separate services, each with its own partner app and its own backend module.
This document is about the **taxi** service only.

| Service | Customer app endpoints | Partner app | Backend module | Partner role |
|---|---|---|---|---|
| **Taxi** (ride hailing) | `/api/taxi-user/...` | Taxi partner app | `/api/taxi/...` (`TaxiController`; `/api/skipper/...` is a deprecated alias) | `skipper` (taxi) |
| **Driver service** (hire a driver, booking flow: estimate, ride-info, cancel, view booking) | `/api/user/...` (`get-estimate`, `ride-info`, `cancel-ride`, `view-booking-details`, `/api/booking/...`) | Driver partner app | `/api/driver/...` (`DriverController`) | `Driver` |
| **Service partners** (other services) | `/api/user/services` and service bookings | their own partner apps | their own modules | their own roles |

Consequences:
- The Firestore replacement in this document (polling `ride-request-detail`, `auto-assign`,
  offers through `TaxiDriverRequest`) applies to the **taxi** service only. Driver-service and
  service-partner bookings are unchanged by it.
- Taxi dispatch must **not** be widened to `Driver` accounts: a driver-service partner is not
  a taxi driver and must not receive taxi offers.
- Wording in server messages and admin labels must keep "Taxi driver" and "Driver service
  partner" distinguishable.

## 1. What Firestore used to do in the Customer app

| Firestore | Purpose | Replaced by |
|---|---|---|
| `skippers/{driverId}` (read, geo query within 30 km) | find nearby drivers, read driver live position | backend `auto-assign` (dispatch) and the driver position in `ride-request-detail` |
| `skipperRequest/{driverId}` (write) | push the ride offer to each nearby driver | `TaxiDriverRequest` rows created by `auto-assign` (server side) |
| `newRide/{userId}` (write, then live listener) | ride state shown on the rider screens | polling `GET /api/taxi-user/ride-request-detail` every 3 s |
| `skippers/{id}` listener during the ride | driver marker on the map | position returned by `ride-request-detail` (polled every 4 s) |
| delete of the three docs on cancel / rating | cleanup | not needed, the server owns the state |

The status numbers are unchanged and match `RideRequest::STATUS_*` on the server:
1 new request, 2 booked, 3 cancelled by user, 4 accepted by skipper, 5 on the way,
6 arrived, 7 cancelled by skipper, 8 ride started, 9 completed, 10 completed and paid.

## 2. Customer app flow now

1. `POST /api/taxi-user/ride-request` -> `details.id` is the ride id (stored locally).
2. `GET  /api/taxi-user/auto-assign?ride_id=<id>` -> backend creates `TaxiDriverRequest`
   rows (status `RIDE_ASSIGNED`) for the drivers within the dispatch radius.
3. The app polls `GET /api/taxi-user/ride-request-detail?rideRequestId=<id>` every 3 s and
   renders by `details.status`. A status of 3 or 7 ends the ride locally.
4. Cancel stays `POST /api/taxi-user/cancel-ride` (`ride_id`). Rating stays `add-rating`.

## 3. What the Taxi partner app must change

Stop writing to / reading from Firestore and Firebase Realtime Database entirely, and use only
the REST API (`/api/taxi/...`; `/api/taxi/...` is kept as a deprecated alias) and OneSignal:

All calls are `POST`, form-encoded, with the header `auth_code`. Replies carry `status` = `OK` or `NOK`.

| Step | Endpoint (`/api/taxi/`) | Body |
|---|---|---|
| Online / offline (was `skippers/{id}.online_status`) | `update-online-status` | `status` (1 or 0) in the **query string**: `update-online-status?status=1` |
| Position every 4-10 s (was `skippers/{id}` lat/lng) | `update-lat-lng` | `latitude`, `longitude` |
| Poll offers every 5 s (was `skipperRequest/{id}`) | `new-request` | none |
| Accept | `accept-or-reject` | `rideRequestId`, `status=4` |
| Reject | `accept-or-reject` | `rideRequestId`, `status=7` |
| On the way / arrived | `change-status` | `rideRequestId`, `status=5` / `6` |
| Start with the rider's OTP | `verify-ride-otp` | `rideRequestId`, `status=8`, `otp` |
| Complete | `change-status` | `rideRequestId`, `status=9`, **`final_lat`, `final_lng` are required**: without them the server answers NOK and the ride stays open |
| Payment | `update-payment-status` | as today |

Replies the app must handle:
- `new-request`: `details[]` with `id` (ride id), `user{id,username,contact_no}`, pickup and drop
  address / pincode / latitude / longitude, `total_fare`, `payment_method`, `status`, `created_on`.
  When empty it is `NOK` with "No new request Found" or "No new rides" (not an error).
- `accept-or-reject` (accept): `details{id,name,profile_image,vehicle_number,vehicle_type}` and
  `ride_status=4`. If another driver was first: `NOK` "Some other Skipper has accepted the ride...".
- `verify-ride-otp` with a wrong code: `NOK` "Incorrect OTP.".

### 3.1 New booking request: notification and ringing sound

What the backend sends (once per nearby driver, from `OrderDispatch::assignAll`, ride status `1`):

| Field | Value |
|---|---|
| title | `New ride request` |
| body | `A new ride request is available near you` |
| data `type` | `newOrder` (string) |
| data `order_id` | the ride id (string) |
| target | the OneSignal subscription id the driver app stored as `device_token` |

Nothing is delivered until the OneSignal REST API key is set on the server.

What the driver app must do so the driver actually notices it:

1. Register with OneSignal and send `OneSignal.User.pushSubscription.id` as `device_token`
   (at `verify-otp`, and again through `check` with `AuthSession[device_token]` when it changes).
2. Android: Android picks the sound from the notification channel, so the app must create two
   channels with exactly these ids. The server names the channel in the push
   (`existing_android_channel_id`, priority 10):
   - `new_booking_alert` for `type=newOrder` (ringtone sound, high importance, vibration);
   - `other_high_importance_channel` for every other push.
   The ringtone file goes in `android/app/src/main/res/raw` (the mapping can be overridden
   on the server in `params['push']['channels']`).
3. Foreground / opened-from-notification: on `type == "newOrder"` call `new-request`, open the
   incoming-request screen, and **loop a ringtone** (for example `audioplayers` or
   `flutter_ringtone_player`) until the driver accepts, rejects, or the offer times out.
   Stop the ring on any of those, and when the app is backgrounded again.
4. Accept = `accept-or-reject` with `status=4`; reject = `status=7`. If the ride was already
   accepted by another driver the server answers NOK: close the screen and stop the ring.
5. While the driver is online, also poll `new-request` every 5 s so an offer is not lost if the
   push is late or the OneSignal key is not set yet.

## 4. Backend items required for full parity (not in this repo)

1. **`ride-request-detail` driver block.** `RideRequest::asJson()` currently sets
   `driver.id` to the *ride* id and returns no coordinates. Please return:
   `driver.id` = real driver user id, `driver.latitude`, `driver.longitude` (from `user.lat/lng`),
   and `driver.vehical` (vehicle type title).
   Until then the rider map shows the pickup point instead of the live driver marker.
2. **Push on assignment.** The backend now sends the driver notification from
   `OrderDispatch::assignAll` (section 3.1). It needs the OneSignal REST API key and
   `PUSH_DRIVER` set on the server, and the ringing sound needs a notification channel id
   (`android_channel_id`) in the push payload that matches the channel the driver app creates.
3. **Timeout / re-dispatch.** Nothing expires an unanswered `RIDE_ASSIGNED` request. Add a
   cron or a timeout that cancels the ride (status 3 or 7) or re-dispatches, otherwise the
   rider can wait forever.
4. **Status is written by the driver endpoints.** Confirm `accept-or-reject` and `change-status`
   update `RideRequest.status` (and `driver_id`), because the rider polls only that field.

## 5. Cleanup done in the Customer app

- Removed packages: `cloud_firestore`, `firebase_core`, `firebase_messaging`, `firebase_storage`,
  `firebase_dynamic_links`, `firebase_core_platform_interface`.
- Removed `google-services.json`, the Gradle `google-services` plugin and the Firebase BoM /
  Analytics dependency, the Firebase JS block in `web/index.html`, and all hard-coded
  Firebase API keys in `main.dart`.
- Push is OneSignal only (needs `--dart-define=ONESIGNAL_APP_ID=<id>`).
- The keys that were embedded in the source (FCM server key, Firebase API keys, ImageKit key)
  should be rotated or revoked.

## 6. Who receives taxi booking offers

`OrderDispatch::assignAuto` offers a ride only to users that:
- have `user_role = 'skipper'` (a taxi partner),
- have `driver_details.vehical_id` equal to the ride's vehicle type, and
- last posted a position within 10 km of the pickup.

Therefore taxi partners must be registered through `/api/taxi/verify-otp` (and complete their
taxi vehicle details). Accounts created through `/api/driver/verify-otp` belong to the separate
driver service and are correctly excluded from taxi offers. Do **not** widen the taxi
dispatcher to the `Driver` role.

Offline partners are not excluded from offers today (adding the filter would silence every
partner whose app never calls `update-online-status`), so the taxi partner app must call it.

## 7. Naming on the server (for reference)

- The driver module is now `TaxiController`, served at `/api/taxi/...`; `/api/skipper/...` still
  works through a deprecated alias, so builds already installed keep working.
- New action names: `taxi-status`, `update-taxi-city` (the old `skipper-status` and
  `update-skipper-city` still resolve).
- Stored values are unchanged (`user_role='skipper'`, table and column names), and so are the
  numeric ride statuses. Only code and display names changed.
- `update-lat-lng` now returns only `id`, `lat`, `lng`, `online_status` and validates the ranges.
- The Customer app (`/api/taxi-user/...`) is not affected by the rename.
