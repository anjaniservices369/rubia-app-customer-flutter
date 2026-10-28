# Rubia Customer App – Project Guide

Written for: the business owner (no technical background needed) and for new developers who join later.
Last updated: 26 Oct 2026.

---

## 1. What this app is

The **Rubia Customer App** is the Android/iOS app that Rubia's *customers* use.
Today it offers two services on the home screen, both cards coming from the server's services list:
**Drivers** (book a professional driver who drives the customer's own car, "Rubia Driver") and
**Taxi** (instant rides in the style of Uber and Rapido: a Bike, Auto or Car taxi, see section 11). The
other tiles (Auto, Bike, Hotel, Jobs, Real Estate, Travel and Home Services) stay hidden.

The app talks to the **Rubia server** (the "backend"), which holds all data: customers, drivers,
bookings, wallets, prices. The app itself stores almost nothing.

There are **three separate apps / systems** that work together:

| Part | Who uses it | Where it lives |
|---|---|---|
| **Customer app** (this project) | Customers who book | this folder |
| **Partner / Driver app** | Drivers who accept and do the rides | separate project (`rubia_driver…`) |
| **Backend + Admin panel** | Rubia staff and both apps | separate project (PHP, Yii) |

> The **Driver service** and the **Taxi service** are different products with different partner
> apps. Do not mix them up: drivers of the Driver service never receive taxi requests.

---

## 2. The customer's journey (in plain words)

1. **Login** → the first screen: logo, the “Welcome! Book a professional service.” tagline,
   mobile number and the terms tick.
   The server sends a 4-digit **OTP by SMS**.
2. **OTP** → the app reads the SMS automatically and signs the customer in.
3. **Registration (first time only)** → on top of Home: **name, email and an optional referral
   code** (one sheet); then **two emergency contacts** (required, full screen); then Home, which
   asks for the **location**. See section 12.
4. **Home** → taps **Drivers** or **Taxi**.
5. **Book a driver** (one screen) → one-way or round trip; in-city or out-station; then the
   **vehicle first**: automatic/manual and car type (SUV+, SUV, Sedan, Hatchback); then pickup and
   drop on a map (the app checks the place is inside Rubia's service area); pickup time (next free
   slot pre-filled); then **Next**.
6. **Estimate and confirm** (one screen) → the server calculates the price (e.g. ₹609 for 2 hours).
   Hours and coupons can be changed; **Confirm Ride** saves the booking: *"Your order has been
   placed"*.
7. **Waiting for driver** → a driver accepts. The customer sees the driver and a 4-digit **ride OTP**.
8. **Ride** → the driver arrives, the customer shares the OTP, the ride starts and ends.
9. **Bill first, then rate the driver once the driver has confirmed the payment** → when the ride
    ends the customer sees the final bill, with a note to pay the driver (it disappears once paid).
    When the driver confirms the payment in the Partner app (`collect-cash`, which sets
    `payment_status` to 1) a
    **"Ride Completed"** sheet opens on top of whatever screen the customer is on (Home,
    Bookings, the live ride screen): driver name, stars, optional review, **Submit** or
    **Later**. **Submit** shows "Thanks for your rating" and opens **Home**; Back does not return
    to the finished ride. **Later** keeps the rating available on the ride's details in
    Bookings → Completed, but the customer is not asked again for that ride.
10. **Pay** → cash or wallet.
11. **Cancel** (optional) → the customer can cancel; a cancellation fee may apply.
12. **Profile → My Transactions** → every payment across Driver, Bike, Auto, Car and the Wallet, by
    day and by month (section 13).

---

## 3. Booking statuses (what the numbers mean)

| Number | Meaning | Who changes it |
|---|---|---|
| 1 | Waiting for a driver | customer placed the booking |
| 2 | Driver accepted | driver |
| 3 | Driver declined | driver (the booking stays open for others) |
| 4 | Driver is on the way | driver |
| 5 | Driver arrived at the pickup | driver |
| 6 | Ride started (after OTP) | driver |
| 7 | Ride completed | driver |
| 8 | Cancelled by customer | customer |
| 9 | Cancelled automatically | system |
| 10 | Cancelled by driver | driver |

These live in `lib/constants/constants.dart` and must always match the server.

---

## 4. Where the code is (folder map)

```
lib/
  main.dart                  App start, login restore, splash, first screen
  constants/                 Server addresses, colours, status numbers, image names
  api_services/              Everything that talks to the server (see below)
  providers/                 The app's short-term memory while booking
  views/                     The screens, grouped by feature
    logiPage, otpPage          Login and OTP
    homePage                   Home, services, booking steps, coupons, payment
    select_ridePage, RideBooking  The booking journey
    Bookings                   My Bookings, ride details, bills, cancel
    WalletPage                 Wallet
    profilePage                Profile, favourites, contacts, notifications
    translation.dart           All text in 5 languages
  taxi/                      The Taxi flow (Uber / Rapido style), see section 11
  taxiservices/              Older Taxi screens for the retired /taxi-user address (not used)
  globalWidgets/             Reusable pieces (buttons, map pickers, cards)
  globalFuctions/            Shared helper functions
  periodic_notification/     Background status check after a booking
  models/                    Data shapes returned by the server
android/ ios/ web/           Platform packaging
assets/                      Images and icons
```

Home and Profile are tabs in one navigation shell. System Back from Profile
returns to Home in that same shell; it must not create another tab shell on the
navigation stack.

Every source file starts with a short **WHAT / NOTES** block explaining it in plain words.
Files marked **INACTIVE** are fully commented out and can be deleted safely.

### The `api_services` folder

| File | In plain words |
|---|---|
| `ApiHelper.dart` | The one door to the server; handles errors and retries |
| `userApi.dart` | The list of every request the app can make; startup session checks time out after 10 seconds |
| `servicesApi.dart` | Requests for the booking journey and fare estimate |
| `sessionGuard.dart` | Logs the customer out if the server says the login is invalid |
| `pushService.dart` | Push notifications (OneSignal) |
| `otpSmsReader.dart` | Reads the OTP SMS automatically |
| `mediaApi.dart` | Uploads pictures (profile photo) to the Rubia server |

---

## 5. External services the app depends on

| Service | Used for | Who controls it |
|---|---|---|
| **Rubia backend** | all data and rules | your backend team |
| **2Factor.in** (via the backend) | sending OTP SMS | backend |
| **OneSignal** | push notifications | App ID is in the app; the secret REST key is on the server only |
| **Google Maps / Places / Directions / Distance Matrix** | maps, addresses, distances and fares | Google Cloud account |
| **Google Play services** | reading the SMS with consent | Android |
| **Sentry** | crash and uncaught-error reports | configured at build time with `SENTRY_DSN`; disabled when unset |

**Firebase has been removed completely** (messaging, storage, database, dynamic links).
Sentry is the Firebase-free crash reporting service. Reports are configured without
default personal information or performance traces. Before enabling it in a public
release, disclose crash reporting in the Privacy Policy and configure the Sentry
project's access, retention and data-region settings.

---

## 6. Money and rules the owner should know

- **Fare estimate** is calculated **by the server** from distance, hours, time of day and the
  city's rate card (base fare, extra km/minute charge, night charge, GST, platform charges).
  The app only displays it.
- **Cancellation:** the server decides whether a fee applies; the customer must accept the terms
  and give a reason before cancelling.
- **Wallet:** customers can add money and pay from it; the history is shown in the Wallet tab.
- **Coupons:** the server validates and applies the discount.
- **Service area:** pickup and drop must be inside an active city/pincode area.
  *Note: the booking calls currently send the fixed pincode 500081 (Hyderabad) – see section 8.*

---

## 7. Running and testing it

| Task | Command / step |
|---|---|
| Install packages | `flutter pub get` |
| Run on a phone against the **live** server | `flutter run` |
| Run against a **local** backend (USB phone) | start the backend on port 8080, `adb reverse tcp:8080 tcp:8080`, then `flutter run --dart-define=API_BASE_URL=http://localhost:8080/api` |
| Build an installable test file | `flutter build apk --debug` → `build/app/outputs/flutter-apk/app-debug.apk` |
| Push notifications | built in; override the App ID with `--dart-define=ONESIGNAL_APP_ID=...` |
| Enable crash reporting | add `--dart-define=SENTRY_DSN=<project-dsn>` to the build command; omit it to keep reporting disabled |

The app's Dart SDK floor is now 3.5.0 for the Android-compatible Sentry SDK. A
100,000-account target is not a verified capacity claim: it needs a separate load
test against staging, with an agreed peak-concurrency target and backend monitoring.

Tested flow on a real phone against the local backend: login with auto-read OTP → home →
Drivers → pick drop → estimate → confirm → My Bookings → cancel.

### 7.1 Build speed and phone connection (updated 26 Oct 2026)

- `android/gradle.properties` now gives Gradle 4 GB of memory and turns on parallel builds,
  build caching and the daemon. The first build is still slow (about 10-12 minutes); later builds
  reuse the cache.
- The "Gradle / AGP / Kotlin version will soon be dropped" and "google_api_headers ... default
  plugin" messages are warnings, not errors. `--android-skip-build-dependency-validation` hides
  the first kind.
- If the phone disappears from `adb devices` after a build (`device not found` / `offline`), run
  `adb kill-server` then `adb start-server` until it shows `device`, and install the APK that was
  already built: `adb install -r build/app/outputs/flutter-apk/app-debug.apk`. No rebuild needed.
- On Xiaomi phones `INSTALL_FAILED_USER_RESTRICTED` means "Install via USB" (and USB debugging
  security settings) must be switched on in Developer options.

### 7.2 Running the whole business flow on a phone with a local backend (verified 26 Oct 2026)

1. **Database:** the backend expects MySQL on `127.0.0.1:3308`. Start a `mysql:8.4` Docker
   container on that port (empty root password) and import the dumps from
   `../rubia-data-sql-dumps` (`rubia_website.sql` first, then the others).
   **Names:** the dumps contain real people's names. In the local container (not in the dump
   files) every personal name was removed on 26 Oct 2026: `user.first_name` / `last_name`,
   emergency-contact names, bank account-holder names and the `narsing` names are empty, except
   the two test accounts, which are both named **Veera** (customer 9999900001, driver 9985735241).
   The original values are kept in the container's `bak_user_names`,
   `bak_user_emergency_contacts`, `bak_driver_emergency_contacts`, `bak_emergency_contact`,
   `bak_driver_bank_details` and `bak_narsing_names` tables. A freshly imported database has the
   real names again, so repeat the clean-up after importing.
2. **Backend:** from `../rubia-backend-php/app` run `php -S 127.0.0.1:8080 -t . index.php` with
   these environment variables and options (nothing in the code is changed):
   - `YII_ENV=dev`, `YII_DEBUG=1`. (With `YII_DEBUG=0` the taxi rider addresses `/api/car-user`,
     `/api/auto-user`, `/api/bike-user` answered "internal server error" on this PHP server; the
     Driver service worked in both modes.)
   - `OTP_TEST_NUMBERS=<customer number>,<driver number>` and `OTP_TEST_CODE=<4 digits>`: a dev-only
     test login that skips the SMS. It works only in dev mode and only from the same machine.
   - `-d error_reporting=8191`: PHP 8.2 warns about `strtotime(null)` in the fare code and that
     warning otherwise makes the estimate fail.
   - `-d curl.cainfo=<cacert.pem>` and `-d openssl.cafile=<cacert.pem>`: this PHP has no
     certificate list, so calls to Google fail without it.
   - The database container must run on **India time**: start it with `--default-time-zone=+05:30`
     (or run `SET GLOBAL time_zone = '+05:30'`). The backend runs on Asia/Kolkata while a Docker
     MySQL defaults to UTC, and the taxi dispatcher compares the two: every new taxi ride looked
     5½ hours old and was cancelled as "No driver accepted the ride within 120 seconds" at once.
   - **Taxi data for testing** (dev database only): service-area rows in `pincode` for Hyderabad
     (500001-500100) and bike, auto and taxi (`vehical_id` 4, 5, 6), and a car-taxi price card in
     `ride_commision` for city 8 (vehicle 2: base ₹40, 2 km included, ₹14/km, ₹1.5/min). Bike and
     auto already had price cards. The test taxi driver is the existing `taxi` account
     **7013928987** (add it to `OTP_TEST_NUMBERS`).
3. **Phone:** `adb reverse tcp:8080 tcp:8080`, then build and install the app with
   `--dart-define=API_BASE_URL=http://localhost:8080/api`.
4. **Customer in the app:** the test customer is **9999900001, named Veera** (code 1234 through the
   dev test login above). For a brand-new account use **9999900002** (also in
   `OTP_TEST_NUMBERS`; created on 26 Oct 2026 as customer 7146, named Veera). Phone number → tick
   the terms box → OTP (the 4th digit submits it by itself) → Name, email and an optional referral
   code → emergency contacts (two numbers) → Home → Drivers → one-way, in-city → pick the drop
   on the map → Automatic, Sedan → Next → today/tomorrow and time → OK → estimate → Next →
   Confirm Ride. The booking shows "Waiting for Driver" with a 4-digit ride OTP.
5. **Driver:** the Partner app was not used. The driver was played through its API
   (`/api/driver/…`): `driver-status` (status=1), `accept-ride`, `go-for-pickup`,
   `arrived-location` (send the ride OTP), `start-ride`, `complete-ride`.
6. **Check:** the booking becomes status 7 (completed) in the `booking` table, one row appears in
   `driver_earnings`, and the app lists it under Bookings → Completed.

Two full runs completed this way (bookings 1008 and 1009, estimate ₹609, final price ₹360).

### 7.3 Copilot agent for this project

`.github/agents/rubia-customer-app.agent.md` defines the **Rubia Customer App** agent. It knows
the folder layout, the build/run steps above and the rules (no Firebase, no secrets in the app,
status numbers must match the backend). Use it for building, testing the flow on a phone and
changing screens, providers or API calls.

### 7.4 Source control

The project is now a git repository (branch `main`, first commit `cf4e94e`). The signing
keystore folder (`jks/`), `android/key.properties`, `android/local.properties` and `.claude/` are
kept out of git through `.git/info/exclude`, so they are never committed by accident.

### 7.5 Reliability, crash reporting and scale readiness (updated 26 Oct 2026)

- **Navigation:** Home and Profile stay in the same bottom-navigation shell. System Back from
  Profile selects Home instead of pushing a second shell. The shell uses `PopScope` for Android
  predictive-back compatibility.
- **Startup:** restoring a saved login checks the session with a 10-second timeout. A slow or
  unavailable backend no longer leaves that request waiting indefinitely; the app can continue
  without the restored session. Push initialization and Android notification-channel setup are
  isolated so their failures are reported and do not prevent the app from opening.
- **Connectivity:** the connectivity stream subscription is cancelled when its screen wrapper is
  disposed. Network type is only a hint; requests still report their own connection and timeout
  errors.
- **TLS:** the app no longer globally accepts invalid HTTPS certificates. Local development over
  `http://localhost` continues to work, but HTTPS servers must present a valid certificate chain.
- **Crash reporting:** the app uses `sentry_flutter` (not Firebase). Configure a Sentry project DSN
  at build time with `--dart-define=SENTRY_DSN=<project-dsn>`. Without a DSN, remote reporting is
  disabled. Default personal information and performance tracing are disabled. Before enabling
  it for customers, publish the relevant Privacy Policy disclosure and set appropriate access,
  retention and data-region controls in the Sentry project.
- **Compatibility:** the Dart SDK minimum in `pubspec.yaml` is `3.5.0`, required by the chosen
  Android-compatible Sentry SDK. Developers and CI must use a compatible Flutter/Dart toolchain.
- **Verification performed:** `flutter analyze` on the changed Dart files and `flutter test` pass;
  the debug APK was built, installed and launched on the connected Android phone without a fatal
  launch error. These checks do not exercise authenticated flows or confirm remote Sentry delivery.
- **100,000 customers:** no capacity guarantee has been established. Registered account count is
  not the same as concurrent load. Agree on peak concurrent users and critical journey targets,
  then run controlled load tests against staging while monitoring the API, databases, queues,
  SMS/OTP provider, maps quotas, push delivery and error/latency rates. Do not load-test production.

---

## 8. Known issues and open decisions (for the owner)

0. **27 Oct 2026 additions** (booking radius, trip notices, route card, live tracking, cancelling) need the backend release in the backend's
   `DEPLOY.md` section 33. The live server is still the older backend; see section 15.3 and 15.5.

1. **Live server is not updated.** Login on the live server fails with "OTP failed" until the new
   backend package is deployed (see the backend's `DEPLOY.md`).
2. **Dispatch to drivers** needs a scheduled job (cron) on the server to offer new bookings to
   online drivers. Without it, the Partner app shows "No Bookings found".
3. **Auto and Bike cards are hidden.** The server lists Auto and Bike as services of their own, but
   the app offers them inside the Taxi flow (Bike, Auto and Car cards), so only the Taxi
   card is shown. Hotel, Jobs and the other tiles stay hidden (`lib/constants/appScreens.dart`).
4. **Fixed pincode 500081** is sent in booking and estimate requests. If Rubia expands beyond
   one area the real pincode of the picked address should be sent.
5. **Keys in the code.** A Google Maps key and a token are stored in
   `lib/constants/constants.dart`, and a Maps key in `AndroidManifest.xml`. They should be
   restricted to this app in Google Cloud, and the secret OneSignal REST key must never be added
   to the app.
6. **Dead files.** Thirteen files are fully commented out (marked INACTIVE) and can be removed.
7. **Cancel reasons and other new English texts** are not yet translated into Hindi, Kannada,
   Telugu and Tamil.
8. **Price shown after the ride differs from the database.** In both test runs the Completed card
   in the app showed ₹420 while the booking's `final_price` was ₹360 (estimate ₹609). Not yet
   investigated: check which field the Bookings list reads.
9. **Google Distance Matrix and Routes APIs** return REQUEST_DENIED for the project key (see the
   backend log). The fare still works, but both APIs should be enabled in Google Cloud.
10. **Fare estimate fails under PHP 8.2 warnings.** `Booking::calculateIntercityOneWayEstimate`
    calls `strtotime()` on an empty `end_time`; the backend team should fix it instead of hiding
    the warning (see 7.2).
11. **Emergency contacts are saved without names.** The server stored the two numbers with empty
    names and relationships.
12. **Slow save can show "Failed to save" although the booking exists.** The app waits 30 seconds
    for the server (`api_services/ApiHelper.dart`). While the Google APIs of item 9 are denied, the
    server retries them and one save took 33 seconds, so the app gave up after the booking had
    already been stored (booking 1012). Enabling those APIs fixes the delay; the real fix is for
    the server to save first and look up distances afterwards. The same slowness once left Ride
    Details on its loading dots for over a minute (it loaded normally on the next try).

---

## 9. Words you will hear

| Term | Meaning |
|---|---|
| **Backend / API** | The Rubia server and the list of requests the app can send it |
| **OTP** | One-time password sent by SMS to prove the phone number |
| **auth_code / token** | The "key" the app receives after login and sends with every request |
| **Provider** | A shared memory inside the app (e.g. the booking in progress) |
| **Push notification** | A message that appears on the phone even when the app is closed |
| **Cron job** | A task the server runs on a timer (for example offering bookings to drivers) |
| **APK** | The installable Android file |
| **Debug / release build** | A test version / the version for the store |

---

## 10. Booking flow screen by screen (shortened on 26 Oct 2026)

The driver booking used to take 8 steps between tapping **Drivers** and the confirmed booking, and
showed the fare twice. After a screen-by-screen review on a phone it was cut to **3 steps** and
tested end to end (booking 1010: book, confirm, driver completes, shown under Completed).

### 10.1 The flow now

| # | Screen | What the customer does | File |
|---|---|---|---|
| 1 | **Home** | Taps **Drivers** (the other tiles say "Coming soon") | `homePage/homePage.dart` |
| 2 | **Book a driver** (one screen) | In this order: One way / Round trip and In-city / Out-station; **Automatic / Manual and the car type** (first car is pre-selected); the pickup (from GPS) and the drop row (opens the map straight away, or the favourites list if the customer has saved favourites); the pickup time (the next free quarter-hour is already filled in, tap to change today/tomorrow and time); **Next** (always visible; asks for the missing pickup/drop if needed). The server calculates the fare here. | `RideBooking/selectLocationPage.dart` |
| 3 | **Estimate and confirm** (one screen) | Sees trip summary and fare, can change the pickup time, hours (1-15), apply a coupon, then taps **Confirm Ride**. The booking is saved and My Bookings (Active Rides) opens. | `homePage/components/OneWay.dart` |
| 4 | My Bookings, then Ride details | Follows the booking; ride OTP, driver, cancel. **My Bookings is no longer a tab of the bottom bar** (which now has only Home and Profile): it opens from the **Bookings** button at the top right of "Book a driver", and automatically after **Confirm Ride** (on top of Home). Back returns to where the customer came from. Tested on the phone: the bar shows Home and Profile only; the button opens the list; after confirming, the list opens with the new ride and Back goes to Home. Code that used the old tab numbers still works: `BottomNavigation(tabIndexId: 1)` now means "Home with My Bookings opened on top", and 2 is Profile. | `Bookings/`, `views/bottomNavigation.dart/` |

Sheets and pop-ups that remain: the map picker (needed to choose a new place), the date/time sheet
(`dummy.dart`, class `Clock`: OK now only stores the choice and closes), the favourites list
(`RideBooking/FavLocations.dart`) and the fare breakdown (`RideEstimateInfo.dart`, tap the fare).

### 10.2 What was removed or merged

| Before | Now |
|---|---|
| "Select ride type" screen (`selectRideType.dart`) | Deleted; its two choices are toggles at the top of **Book a driver** |
| Empty "Choose from favourites" sheet before the map | Skipped when the customer has no favourites (`globalWidgets/locationcard.dart`) |
| Date/time sheet followed by a separate estimate step | Time is pre-filled on **Book a driver**; **Next** asks for the fare |
| Estimate page plus "Confirm Ride" sheet (`confirmride.dart`) | Deleted; **Confirm Ride** is on the estimate page |

### 10.3 Rules kept (so the booking still works)

- All choices live in `TripOptionsProvider` (`providers/riderProvider.dart`); the server calls and
  fields (`get-estimate`) are unchanged, and the server still decides the price.
- Round trip needs only the pickup; one-way needs pickup and drop. Switching In-city /
  Out-station clears the drop, because the allowed area differs.
- **Next** is refused with a message if no car type loaded or the pre-filled time has passed
  (the time sheet then opens).
- Back on **Estimate and confirm** returns to **Book a driver** with every choice kept; back on
  **Book a driver** abandons the booking and returns Home.
- After a failed save the "save booking" flag is cleared, so changing the hours later cannot
  create a booking by accident.
- Not done: opening the ride details directly after confirming. The app still opens the
  Bookings list, where the new ride is the first card.

### 10.4 Bugs found and fixed on the way

- `Twl.dateActual` always printed **today's** date, so a booking for tomorrow was shown as today
  on the estimate page (the saved booking was correct). It now formats the date it is given.
- The old confirm sheet left the "save booking" flag on after a failed save (see above).
- After a rating was saved, the ride-details screens replaced themselves with Home but left the
  earlier Bookings screens behind them, and the "Successfully updated" message was never shown.
  Both rating forms now call `Twl.goHomeAfterRating`: thank-you message, then Home with the screen
  stack cleared. Tested on the phone with booking 1011: rating saved in `user_booking_ratings`,
  "Thanks for your rating" shown, Home opened, and Back left the app instead of reopening the ride.
- Moving the vehicle choice above the places exposed a reset: choosing the drop on the map
  rebuilds the booking screen, which dropped the chosen car back to the first one (SUV+) and the
  gear tab back to Automatic. The car list now re-selects the car already chosen
  (`select_ridePage/.../automatic_page.dart`) and the tab opens on the chosen gear type. Tested:
  Manual + Sedan chosen before the drop was saved as Manual, Sedan (booking 1014).

### 10.5 Bill breakup check (estimate and final bill)

Checked against the server's numbers for the same trip (Sedan, in-city, one-way, 2 hours; then a
ride that completed after a few seconds):

| Where | Lines shown | Server's numbers | Result |
|---|---|---|---|
| Estimate (fare breakup sheet) | Base 400, Additional 180, GST 29, coupon -0, **Estimated Final Fare ₹609** | `get-estimate`: base 400 + additional 180 + GST 29 = 609 | Matches |
| Final bill (ride details) | Sub total ₹420, Discount -₹0, **Total ₹420** | `subtotal` 420, `price_detail.estimatePrice` 420 (base 400 + GST 20) | Matches |
| Final bill, detailed sheet (tap the Total Price box with the (i) icon) | Base Fare ₹400, GST ₹20, **Completed Ride Fare ₹420**, footnotes incl. "Night Charge ₹200" | `price_detail`: baseFare 400 + gst 20 = 420 | Matches (checked on the phone) |
| Completed card in the list | ₹420 | same | Matches |

What the numbers mean (so the difference between ₹609, ₹420 and ₹360 is not a bug):
- **Estimate ₹609** is the fare quoted for the 2 hours the customer asked for. The final bill is
  recalculated from the real time and distance, so a ride that lasted seconds is billed the base
  fare only (₹420); a normal ride ends close to its estimate.
- **"Sub total"** on the bill already includes GST (it is the full fare before any coupon).
- **`booking.final_price` (360) is the driver's share**, not the customer's bill: fare minus the
  Rubia commission, GST and fees (`DriverController::actionCompleteRide`). The customer's bill is
  `subtotal`. The column name is misleading; the app correctly does not show it.
- `booking.additional_charges` keeps the value quoted at booking time (180) even after the final
  bill replaced it in `price_detail` (0); the app reads `price_detail`.

Found and fixed: the estimate sheet's footnote said "Night Charge ₹300", a figure hard-coded in
the app, while the server's rate card says ₹200 per night. The app now keeps the server's
`nightChargePerNight` (`TripOptionsProvider.nightChargePerNight`) and quotes that, falling back to
the old figures only when the server sends none. Checked on the phone: the footnote now reads
₹200.

Cosmetic, not changed: a ride that lasted seconds shows "Fare for your 0 mins Trip" and "0 mins
usage"; real rides show their real duration.

### 10.6 Rating when the ride ends (not from the Completed list)

Rating used to be possible only by opening a finished ride under Bookings → Completed. It is now
asked for the moment the ride completes (`views/Bookings/components/rateRide.dart`):

- **Anywhere in the app:** `BottomNavigation` (which hosts Home, Bookings and Profile) asks the
  server every 8 seconds, and again when the app returns to the foreground, whether the booking
  placed from this phone has completed (`RideRatingPrompt.check`). If it has, and is not yet
  rated, the "Ride Completed" sheet opens over the current screen.
- **On the live ride screen** (`riderDetailsPayment.dart`): it already polled every 5 seconds; on
  completion it now shows the same sheet first, and goes on to the bill only if the customer taps
  **Later**.
- Which booking is watched: the phone saves `booking_id` when a booking is confirmed, and also
  when a booking's live screen is opened. `ride_resolved_id` remembers the booking that was already
  handled, so one ride is asked about once; cancelled bookings are also marked handled.
- The rating form inside Completed rides remains for customers who chose **Later**.
- If the app-wide check has already opened the sheet, the live ride screen waits for it to close
  before showing the bill (so the bill is never pushed on top of an open sheet).
- Tested on the phone: (1) customer on Home, ride completed through the driver API: the sheet
  opened by itself within about 4 seconds, **Submit** saved the rating (booking 1012) and opened
  Home with "Thanks for your rating"; (2) customer on the live ride screen: the sheet opened within
  about 3 seconds, **Later** continued to the bill and no second prompt followed (booking 1014).
- Not done: a push or notification that asks for the rating while the app is closed. The
  background checker (`periodic_notification.dart`) stops watching once the ride has started and
  shows no completion message; adding that is a separate change.

---

## 11. Taxi (Uber / Rapido style instant rides)

The **Taxi** card on Home (the server lists it as service type 2) opens `lib/taxi/`. Inside Taxi
there are **three taxi services: Bike, Auto and Car**. On the server each one is its own service
with its own entry point, rider address and database setting (`DB_DSN_BIKETAXI`, `DB_DSN_AUTOTAXI`,
`DB_DSN_CARTAXI`; when a setting is missing the shared database is used, which is the case on the
local test setup). The app is native Flutter and loads everything (service cards on Home, fares,
rides) from the backend as JSON; nothing is rendered on the server. Inside the taxi flow the
drivers are called **taxi drivers**.

### 11.1 The flow (4 screens)

0. **Service cards** (`taxiServicesPage.dart`): three cards, **Bike**, **Auto** and **Car**. The
   customer chooses one; the booking below then talks only to that service. If a taxi ride is
   still open this screen is skipped and the ride reopens (see Resume).
1. **Booking screen** (`taxiBookingPage.dart`): full-screen map with the pickup pin on the current
   location. "Where to?" opens a map picker (`taxiPlacePicker.dart`, a centre pin and Confirm);
   the pickup can be changed the same way. After a drop is chosen the screen lists the chosen
   service's vehicles with fare, ETA, seats and distance (live from the server). The customer
   picks one, sees "Pay by cash", and taps **Book X · ₹N**.
2. **Ride screen** (`taxiRidePage.dart`), refreshed every 3 seconds, one card per ride status:
   - *Finding your taxi driver...* (radar, route on the map, **Cancel ride** with a confirmation);
   - *Taxi driver accepted / on the way / arrived*: name, vehicle, number, **OTP** to tell the
     taxi driver, **call** button, Cancel;
   - *Trip started*; *Completed*: "Please pay ₹N" and a 5-star rating with a comment, then Home;
   - *Cancelled / no taxi driver available* (the server gives up after 120 seconds): **Back to Home**.
   While searching, the app asks the server to offer the ride again about every 30 seconds.
3. **Resume**: the open ride is remembered on the phone (`taxi_active_ride`). If the customer
   leaves (Back) and taps Taxi again, the ride screen reopens; a finished or cancelled ride clears
   it.

### 11.2 Server calls

The rider addresses differ per vehicle: `/api/bike-user/` (service type 4), `/api/auto-user/`
(type 3), `/api/car-user/` (type 2, shown as "Car"). Each has `get-vehicles` (fare list),
`ride-request`, `auto-assign` (offers the ride to nearby drivers), `ride-request-detail`,
`cancel-ride` and `add-rating`. All are wrapped in `TaxiApi` (`taxiApi.dart`).

Ride statuses: 1 new, 2 booked, 3 cancelled by rider, 4 accepted, 5 on the way, 6 arrived,
7 cancelled by driver or expired, 8 started, 9 completed, 10 paid. The ride JSON's `total_fare` is
the customer's fare (`final_price` is the driver's share, as in the Driver service).

### 11.3 Tested on the phone (26 Oct 2026)

Home shows the Drivers and Taxi cards from the server; the fare list showed Bike ₹19, Auto ₹21,
Taxi ₹44-47. Full ride: book, finding a driver, accepted with OTP, on the way, arrived, started,
completed ("Please pay ₹49"), rating saved (ride 124), Home. Also checked: **cancel** while
searching (ride 125 became status 3), **resume** after Back, and **no driver** (ride expired after
2 minutes with "No driver is available right now").
The driver side was played through the taxi driver API (`/api/car/`: `update-lat-lng`,
`update-online-status`, `accept-or-reject`, `change-status`) as the taxi test driver 7013928987.
Setting up the database and backend for this is in section 7.2.

### 11.4 Not done yet

- Destination text search and recent places (the drop is chosen on the map only).
- Online payment (cash only), driver live position on the map, and a Home banner for an open ride.
- Bike and Auto were priced and listed but only the Taxi ride was driven end to end (a test driver
  with a bike or auto vehicle is needed).

---

## 12. Registration flow (shortened on 26 Oct 2026)

### 12.1 The flow now

| # | Screen | What the customer does | Code |
|---|---|---|---|
| 1 | **Login** (first screen; the old separate "Get Started" welcome screen is gone) | Logo and “Welcome! Book a professional service.”, mobile number, tick the terms, **Login**. | `logiPage/loginPage.dart` |
| 2 | **OTP** | Enters the 4 digits (read from the SMS; the 4th digit submits by itself). | `otpPage/otpPage.dart` |
| 3 | **About you** (sheet over Home, cannot be dismissed) | **Full name and email are required.** Optional: a **photo** (camera or gallery; uploaded straight away), **gender** (Male / Female / Other chips), **date of birth** (calendar, saved as dd-MM-yyyy like the Profile screen) and a **referral code**. A wrong referral code shows "Referral code does not exist" and the sheet stays, so it can be fixed or cleared. A photo that fails to upload only shows a message (it can be added later in Profile). | `PersonalDetails/personalDetailsView.dart` |
| 4 | **Emergency contacts** (full screen) | Two phone numbers, required (used by SOS). No back arrow; Back asks to exit the app. | `EmergencyContact/EmergencyContacts.dart` |
| 5 | **Home + location sheet** | Home opens with the "enable location" sheet (the old separate step). | `bottomNavigation.dart` (`showLocationSheet`), `PersonalDetails/components/EnableLocationView.dart` |

Interactive prototype: [registration-flow.html](docs/uiux/registration-flow.html).
UI/UX documentation: [docs/uiux/README.md](docs/uiux/README.md).
The interactive [login, Home, Driver and Taxi booking prototype](docs/uiux/service-booking-flow.html)
covers phone verification, the customer home screen, the Driver estimate and
confirmation, and selecting and requesting a Taxi ride.
Use Rubia navy instead of black or near-black for UI text, icons, controls and
shadows: `tDarkNavyblue` (`#144272`) in Flutter and `#142A43` in the UI/UX docs.
Use the existing grey tokens for secondary text, dividers and disabled states.

### 12.2 Interactive UI/UX prototype

The browser prototype is a design preview, not a connected app or a replacement
for the flows described in sections 10 and 11. It demonstrates:

- **Login and verification:** valid 10-digit mobile number, required terms
  acceptance, then a four-digit OTP entry.
- **Home:** pickup location, separate Driver and Taxi service cards, a Driver
  promotional banner, and Home/Profile navigation.
- **Driver booking:** one-way or round trip; in-city or out-station; automatic
  or manual gearbox; SUV+, SUV, Sedan or Hatchback; pickup, optional drop for
  round trips, and pickup time. The estimate view summarizes the selection and
  leads to a simulated confirmation.
- **Taxi booking:** Bike, Auto or Car; pickup and destination; sample fare,
  cash-payment summary, review step and simulated request confirmation.

Journey controls can open each major flow directly. Form actions validate
required fields and dates. The fare values, location, OTP success, and booking
results are illustrative only: the prototype does not call APIs, request
permissions, save user data, charge payment, or contact drivers. For the real
API behavior and booking rules, refer to sections 10 and 11. Detailed preview
instructions and design conventions are in [docs/uiux/README.md](docs/uiux/README.md).

The real app has only **Home** and **Profile** in the bottom navigation.
Bookings opens from the Bookings button on the Driver booking screen and after
ride confirmation, not from a third bottom tab. The prototype does not include
the Bookings list itself.

Before: Get Started → Login → OTP → name and email sheet → referral sheet → location sheet, and the
emergency contacts were **not** part of that chain: a new customer got them as a surprise full
screen on the **next app start**, and after saving them the old code opened the referral and
location sheets again and left the customer on the contacts screen.

### 12.3 Rules kept

- Emergency contacts stay **required**. If the app is closed before they are saved, the next start
  opens the contacts screen (`main.dart`), then Home (no location sheet in that case).
- If the app is closed after OTP but before the name is saved, the next start opens Home with the
  name sheet again (`check` API: no email yet).
- After the last step Home replaces every earlier screen, so Back from Home leaves the app and
  never returns to a registration screen.
- Deleted as unused: `onBoardingpage/onBoardingPage.dart`, `PersonalDetails/components/referalCardView.dart`.

### 12.4 Tested on the phone (26 Oct 2026, new test number 9999900002)

Login is the first screen; OTP 1234 signed in and opened the name sheet; a wrong referral code
showed the error; with the field cleared **Next** opened Emergency Contacts; two numbers saved
(`user_emergency_contacts` rows for customer 7146) and Home opened. With the contacts deleted and
the app restarted, the contacts screen came first and then Home.

### 12.5 Tested on the phone (26 Oct 2026, new test numbers 9999900002 and 9999900003)

Login is the first screen; OTP 1234 signed in and opened the name sheet; a wrong referral code
showed the error; with the field cleared **Next** opened Emergency Contacts; two numbers saved
(`user_emergency_contacts` rows for customer 7146) and Home opened. With the contacts deleted and
the app restarted, the contacts screen came first and then Home.
Second run (customer 7147, Veera): photo chosen from the gallery, gender Female, date of birth
05-01-2000 and name/email were saved in one go (`user.gender`, `user.date_of_birth`,
`user.profile_image` filled) and the Profile tab shows the photo.

### 12.6 Terms and Conditions, Privacy Policy and Refund Policy (written in the admin dashboard)

The three texts are no longer a website link: they are **documents the Rubia team edits in the
admin dashboard** and the app shows them in its own screen. **Every app keeps its own set** (the
customer app, the Driver partner app, and the Car, Auto and Bike taxi partner apps); a page belongs
to exactly one app (`page.app_key`).

- **Edit:** dashboard menu **Terms & Policies** (`/admin/page`, super admin, on the main and the
  customer dashboard). Create a page, choose the **App** (Customer app, Driver partner app,
  Car / Auto / Bike taxi partner app), the type (**Terms and Condition**, **Privacy** or **Refund
  Policy**), set the state to **Active**, write the text in the editor and save. The list shows the
  App and Type columns with filters. If several active pages share the same app and type, the
  newest one is used; set an old one to *In Active* to retire it. Editing needs no app release.
- **Server (one public endpoint per app, no login, so it works before login):**
  `GET /api/user/legal-page?type=terms|privacy|refund` (customer app, the one this app uses),
  `/api/driver/legal-page` (Driver partner app), `/api/car/legal-page`, `/api/auto/legal-page`,
  `/api/bike/legal-page` (taxi partner apps). Each returns only its own app's page: title, the
  editor's HTML and the last-updated date; if nothing active exists it answers "This page has not
  been published yet". The partner apps in the other projects still have to call theirs.
- **App:** `globalWidgets/legalDocumentPage.dart` loads it and draws the HTML with scripts off and
  links blocked. Opened from the **Terms&Conditions** link on Login and from the three links on
  the Profile tab. Shows the server's message with **Try again** when the page is missing or the
  phone is offline.
- **Backend files:** `models/LegalPageApi.php` (the shared answer) and `models/base/Page.php`
  (app list, `findPublished`, type *Refund Policy* = 4); `UserAppActions.php`, the Driver
  `DriverController.php` and the taxi `TaxiController.php` (`actionLegalPage`); the access lists
  (`'legal-page'`) in `customerapp/.../UserController.php`,
  `services/haltingdriver/customer-backend/.../UserController.php` (the shared dev process uses this
  one), and the two partner controllers; the dashboard Page screens (form, list, view, search) and
  `partials/nav.php`; migration `m261026_120101_PageAppKey` adds `page.app_key` (existing pages
  become Customer app pages).
- **After pulling these backend changes:** run the migration, run `php yii service/pack --customer`
  (it adds `LegalPageApi` to `customer/backend/classmap.php`, already done in the repo) and clear
  `app/runtime/cache`, otherwise Yii still has the old table layout cached ("Unknown Property").
- **Local test:** the customer dashboard runs from `app/web/customer-dashboard.php`
  (`php -S 127.0.0.1:8091 -t web web/customer-dashboard.php`, same environment as the API server).
  Only the super admin emails in `params.php` (`superAdminEmails`) can log in. The dev database
  holds **sample** pages typed through the dashboard form: Terms for the Customer app, the Driver
  partner app and the Car taxi partner app (each with different text, checked through the five
  endpoints: each returns only its own, Auto and Bike answer "not published yet"); Privacy and
  Refund are unpublished. **The real legal text still has to be entered by the Rubia team, per
  app.** The old website addresses (`/terme and conditions.html` etc.) only showed the site's
  app-download block; the real website pages are `/TermsConditions/`, `/Privacypolicy/` and
  `/RefundPolicy/`.

### 12.7 Not done yet

- No version tracking: customers are not asked to accept a changed version of the terms again.
- The editor is a rich-text box (CKEditor); there is no per-language text, so every language
  sees the same document.
- The Driver and taxi partner apps (other projects) do not show these pages yet; only the
  endpoints exist.

---

## 13. My Transactions (Profile tab, every service in one place)

Because the app now has several services, the Profile option **My Rides** became **My Transactions**
(`views/Transactions/myTransactionsPage.dart`). It lists what the customer paid or received across
**Driver bookings, Bike / Auto / Car rides and the Wallet**, by date and by month.

- **Screen:** a strip of the **last 6 months** (each with its total; scroll left for older ones, this
  month is on the right); a **summary card** for the chosen month (total spent, money added to the
  wallet, number of transactions, split by service); **filter chips** (All, Driver, Bike, Auto, Car,
  Wallet); then the **days**, newest first, each with its total and its rows (service icon, title,
  drop address or reason, amount, time; payments shown as `-₹`, wallet credits as green `+₹`).
  Pull down to refresh; "Try again" if the server cannot be reached.
- **What counts:** completed Driver bookings (the customer's bill, `subtotal`, not the driver's
  share), completed or paid taxi rides (`total_fare`), and wallet recharges, referral earnings and
  cancellation charges. Wallet debits that merely pay for a ride are left out so a ride is never
  counted twice. Cancelled or unfinished bookings and rides are not transactions.
- **Server:** `GET /api/user/my-transactions?month=YYYY-MM` (login needed; month defaults to this
  month). One call returns the month's `summary`, the `days` with their items, and `monthly` (the
  last 6 months' totals). Each source (bookings, taxi rides, wallet) is read on its own, so a
  service that cannot be read is skipped and the rest still show. Code: `actionMyTransactions` in
  `UserAppActions.php`, allowed in both user controllers.
- **Where did My Bookings go?** The Profile menu no longer opens it. It is still reachable from the
  **Bookings** button of the Book a driver screen and after Confirm Ride; taxi rides are followed
  on their ride screen and appear here once they finish.
- **Tested on the phone** (customer 9999900003): the Profile tab shows "My Transactions"; October
  shows ₹110 spent (Car ₹52, Wallet ₹20, Bike ₹38) with +₹50 referral earning; September ₹113
  (Auto ₹72, Bike ₹41, +₹500 recharge); the Bike chip narrows the list; July shows "No Bike
  transactions in July 2026". The test rows (5 rides and 3 wallet entries for customer 7147, marked
  "test") exist only in the local database. For customer 7145 the API returned 8 Driver bookings
  and the Car ride of 26 Oct 2026 (₹3,409).
- **Not done yet:** tapping a row does not open the booking or ride details; no download of a
  statement; a split deployment (each service on its own database) needs the customer API to ask
  each service for its part instead of reading the shared tables.

## 14. Profile and policy screen presentation (updated 26 Oct 2026)

- Profile actions are presented as full-width, rounded tap targets with aligned icons and visible
  chevrons. The navigation destinations and server calls are unchanged.
- Notifications, Refer & Earn, Support, and legal documents share Rubia's orange / navy palette,
  clearer text hierarchy, consistent spacing, and larger touch targets. Empty and loading states use
  centered, branded placeholders.
- Privacy Policy, Terms and Conditions, and Cancellation & Refund Policy remain server-authored
  documents loaded by `globalWidgets/legalDocumentPage.dart`; the app does not provide or hardcode
  legal wording. Cancellation eligibility and fees remain backend decisions.
- The Figma reference was supplied for this polish, but its design URL returned HTTP 403 from this
  environment. The implementation therefore follows the existing Rubia visual language.

---
## 15. Trip changes, route card, live lists and connection messages (27 Oct 2026)

**Added 28 Oct 2026 - end of a ride and registration.**
- **Bill, pay, rate, Completed.** After the driver completes the ride the customer sees the final bill, with a note to pay the driver
  (`lib/globalWidgets/paymentPendingNote.dart`). The card in Active says *Payment pending*, then *Rate your driver* once the driver has
  collected the payment. The rating sheet (`rateRide.dart`) opens by itself and is **compulsory**: stars and a written review, no Later, no
  Back, no dragging it away; the same rule is on the rating cards of the two ride-details screens. A ride moves to Completed only when it
  is paid and rated.
- **Booking is refused until the last ride is rated.** The estimate/confirm dialog shows the server's reason; OK opens the rating sheet for
  the ride the server names (`rate_booking_id`; `RideRatingPrompt.promptForBooking`).
- **Home** has the heading *Book a Service* above the service cards; the login tagline reads *Book a Service in minutes* (the tagline and a
  smaller logo give way while the keyboard is open).
- **Screen-by-screen pass (28 Oct 2026).** Login: the Login button stays above the navigation bar and the terms alert is readable. OTP: a wrong
  code says "That code didn't match", the timer reads "Resend code in 25s". The phone's Back key on Notifications opens Profile (it closed the
  app); `Twl.backToTab` is the helper for this, other screens still use the old `forceNavigateTo` pattern and should be moved to it. Refer & Earn:
  the Refer button no longer shows a red crash box (an int where a double was expected) and *T&Cs* opens the app's Terms page. Emergency
  Contact: the sheet title was a raw key (a translation key with a leading space). Coupons: an empty list says so. Wording: *In city* /
  *Outstation*; the favorites button says *Save*. Server notification texts were corrected ("Ride started successfully").
- **Outstation round trip (28 Oct 2026).** The estimate screen shows a minus / plus hours stepper with +12 hrs / +24 hrs / +7 days buttons (up to 8,760 hours = 365 days) and
  the same length in days; other trips have a 1-12 hour picker (`TripOptionsProvider.isLongTrip`, `maxUsageHours`). The fare sheet says the base fare
  covers the first base hours, then the hourly rate, the night charge, and that the driver's food and stay are provided by the customer
  (`driverFoodStayNote.dart` on the ride details and bill).
- **Bottom bar (28 Oct 2026).** The system navigation bar is white with dark icons and the band under the app is white (`main.dart` builder), so it
  merges with the app's own bottom bar instead of showing a grey strip. (A map-first Home and a Bookings tab were tried by mistake and removed:
  the request was about the splash screen.)
- **Registration** (name and email required; photo, gender, date of birth and referral code optional; then two emergency contacts): errors
  update as the customer types, the name error is readable, Next fits on the sheet. **The app is portrait only** (landscape made screens
  overflow). The Profile header no longer overflows.

The rules behind these screens (who is offered a booking, in-city / outstation, one way / round trip, distance) are written once, in
plain words, in the backend's `BUSINESS_GUIDE.md` section 24. This section is what the customer app does about them.

### 15.1 What the customer sees now
- **A drop can be anywhere.** The drop picker and the saved places no longer block a drop outside the city ("Selected location is not inside
  any city boundary", "Pickup and Drop location should be same city" are gone for drops) and a drop never changes the booking's city: the
  pickup chooses the price. The pickup is still checked against the served cities.
- **Estimate screen notice.** In-city means inside the city's map. When the pickup or drop is outside it (or the drop is beyond the admin's
  optional in-city radius) the server makes the trip outstation and the estimate says why, above the fare ("Your drop is outside the Hyderabad
  city area. This trip is booked as an outstation trip and is priced as one."). The text comes from the server (`trip_notice`).
- **Fare breakup sheet** (the (i) next to the estimate): extra instruction boxes: "The fare is based on the service area of your pickup
  point"; trips that stay inside the city area are in-city and a pickup or drop outside it makes an outstation trip; a ride that leaves the
  city area (confirmed by the driver's route log) is billed as outstation; and, when the admin has set an in-city radius X
  (`incity_radius_km`), trips farther than X km from the pickup are outstation even inside the city area.
- **Night fares include GST** like day fares (the quote and the bill add up; a 00:45 booking shows Rs 819, it was Rs 780).
- **"View full details" is a button** on every booking card (it only looks like a button; tapping anywhere on the card opens the details).
- **Lists follow the server.** The Active / Completed / Cancelled lists reload by themselves every 8 seconds (without a spinner, only
  redrawn when something changed) and when the app comes back to the front, so a driver accepting, the ride starting, a cancel or a
  completion shows up without leaving the screen. The ride screen checks every 5 seconds.
- **Completed ride details.** When a ride was billed differently from the booking, a card says so in words with a map of the route:
  "Booked as a one-way trip. The ride went 20.6 km out and came back to the pickup point, so it was billed as a round trip." (file
  `lib/views/Bookings/components/finalRideDetailsView/routeConversionCard.dart`, shown on the completed-ride details and the final bill).
  The final bill can differ from the quote because of this.
- **Cancelling.** The ride screen's Cancel Ride asks to tick "I agree to the Terms & Conditions", then for a reason. A waiting booking is
  cancelled free; after a driver accepted the customer is charged (Rs 200 now).
- **Coupon.** Typing a code and pressing Apply now looks the code up in the available coupons and applies it; an unknown code says "This
  coupon code is not valid for this ride." (the button used to do nothing). The dev database has no coupons, so only the rejection was tested.
- **Registration.** Emergency contacts can be saved again (the server used to answer "Emergency contact Exist" for most customers).
- **Phones with on-screen buttons** (Android 15+ draws apps edge to edge): the whole app is kept above the navigation bar
  (`MaterialApp.builder` in `main.dart`), so Next, Cancel Ride and the rating sheet's Later link are no longer half hidden.
- **Location off or not allowed.** Home says "Location is off. Tap to turn it on" / "Location is not allowed. Tap to allow it" and opens
  the right setting, instead of staying on "fetching for current location".

### 15.2 Connection messages (the "Check Internet" bar)
`lib/api_services/ApiHelper.dart`. Every failed request used to show "Check Internet", even when the phone had internet and only the
server could not be reached, and a background refresh could repeat it. Now:
- the message says **"Check Internet"** only when the phone cannot reach the internet at all (a quick DNS lookup decides); when the internet
  works but the Rubia server does not answer it says **"Cannot reach the Rubia server right now. Please try again in a moment."**;
- it shows at most once every 15 seconds;
- background polls pass `quiet: true` (`getTypePost`, `getTypeGet`, `UserAPI.viewBooking`, `UserAPI.fetchBookingsList`) and never show it.

### 15.3 Which server the app talks to
- A normal build uses the live server (`https://rubiaservices.org/api`, `API_BASE_URL` default in `lib/constants/apiConstants.dart`).
  **The live server is an older backend** (for example it has no `/user/legal-page` route), so the booking radius, trip notices, route
  card and tracking need the backend release in the backend's `DEPLOY.md` section 33 first.
- For a backend on the PC: `flutter build apk --debug --dart-define=API_BASE_URL=http://localhost:8080/api` and
  `adb reverse tcp:8080 tcp:8080`. **That build works only while the forward exists**: restarting adb or unplugging the cable drops it
  and the app then says it cannot reach the server although the phone is online. Re-run `adb reverse` for every connected phone
  (`adb -s <id> reverse --list` shows it).

### 15.4 Tested on two phones (27 Oct 2026: realme RMX5256 as customer 9490845226, Redmi Note 12 5G as driver 7893653899)
One-way outstation, Manual, Hatchback (estimate 1995, stayed outstation); round trip in-city 4 h (525; ended 6 km away, billed one way 420);
one-way in-city with a drop 20.6 km away (notice shown, ride came back to the pickup, billed round trip 945, details show the route card);
night booking (819 with GST); customer cancel (waiting, free) and driver cancel (the card went back to Waiting for Driver by itself); two
customers booking at the same moment; the same booking accepted twice at once (one wins). Driving was simulated through the driver API
(pickup, start, positions, complete); the phones were used for booking, accepting and viewing.

### 15.5 Not done / open
- The customer app does not yet show the driver's live position or the distance so far (the server sends `driver_latitude/longitude`,
  `live_distance_km`, `ride_elapsed_min` on the booking details while the ride is on).
- The estimate screen's hours selector is a swipe wheel; the visible 1 / 2 / 3 are not tappable.
- The rating sheet's "Later" is easy to miss on phones with on-screen buttons even after the fix above; check on a real phone.
- Decisions for the owner: a floor for the final fare (a changed ride can cost less than the quote) and whether the drop picker should also
  accept pickups outside the served cities.

## 16. Look and behaviour pass, Back key, account deletion (28 Oct 2026)
- **Screen look:** one colour system (navy text, orange actions); car-type chips use one picture box so every chip is the same size; the Automatic / Manual bar is as wide as the cards around it; the ride card shows the trip labels as small pills; distance reads "51.84 km"; the Home service cards fill the row when only one or two services are on; the splash is plain white with the logo centred (flutter_native_splash.yaml, Android launch_background.xml).
- **Back key:** the helpers in globalFuctions/globalFunctions.dart (navigateTo, forceNavigateTo) return false so the phone's Back key never closes the app by accident; Twl.backToTab returns to the right tab. The drop picker opens on top of the booking form and pops, so the form keeps what was typed.
- **Estimate:** the title says In city one-way / Outstation one-way / Outstation round trip; the hours control starts at the base hours of that trip type (outstation round trip is priced by the hour, up to 365 days, driver food and stay provided by the customer).
- **Compulsory rating:** a new booking is refused until the previous ride is paid and rated; the rating sheet asks for stars and a review.
- **Delete account:** Profile -> Delete account (red text under Logout) asks for confirmation and calls POST /user/delete-account (UserAPI.deleteAccount); the account and personal data are erased at once and the app returns to Login. A ride in progress blocks it with the server's message. The public page for people without the app is /account-deletion on the backend (its address goes in the Play Console Data safety form).
- **Open:** a working map key (Ola Maps key, or a Google key with Routes and Geocoding enabled) must be set in the dashboard Integrations, or one-way estimates cannot be calculated.


- **Splash (28 Oct 2026):** only the logo on white. Android 12 and later ignore `launch_background.xml` and showed the app-icon square; `flutter_native_splash.yaml` now sets `android_12` to `assets/images/android12splash.png` (the logo padded to fit the system circle) on white, and the in-app splash uses the same logo size (145) with a fade, so the two look like one screen. Regenerate with `dart run flutter_native_splash:create`.

### 16.1 Screen-by-screen check (28 Oct 2026, realme phone, test customer 9999900002)
Checked: Home, Profile and every item under it (My Transactions, Notifications, Favorite Location, Emergency Contact, Refer & Earn, Support, Edit Profile, legal pages, Delete account dialog), Taxi service list, Taxi drop picker and estimate. Fixed:
- After Edit Profile -> Update the app opened a bare Profile page with no bottom bar; it now returns to the Profile tab (and shows the server's message if the update is refused instead of doing nothing).
- My Transactions used a white header; it now matches the other Profile screens (yellow bar, white back chip).
- Emergency contacts showed the same stock photo of a man for everyone; now a person icon.
- Taxi drop picker had no search although the field said "Search destination"; it now has an address search (the phone's geocoder, no key). The Taxi page also shows the server's real reason (for example the distance could not be calculated) instead of "No rides available".
- Favorite Location -> Add New: tapping Save as favorites first opened an empty sheet holding only one button before the real title sheet. It now opens the title sheet directly, with Home / Office / Other quick-pick chips, and a blank title is refused (it used to be saved as an unnamed favourite).
- Static check: `flutter analyze` has 0 errors (279 infos/warnings, mostly unused variables and deprecated calls); the 74 duplicate keys in `translation.dart` differ only in wording.
- Not fixed (needs the owner): Taxi and Drivers fare estimates fail until a working map key is set in Integrations; Privacy/Terms/Refund pages show "not published yet" until written in the dashboard; headers differ between families of screens (yellow with chip, white with arrow).

## Live inventory (generated)

<!-- AUTO:inventory:start -->
_This block is generated by `tools/update_docs.py` (last run 2026-10-28). Do not edit it by hand._

- Source files: **160**
- Server endpoints: **53**  (see `docs/API_ENDPOINTS.md`)
- Full file list: `docs/CODE_MAP.md`; status numbers: `docs/STATUS_CODES.md`
- Files without an explanatory header: **0**
- Files without START/END markers: **0**
- Files no screen imports (safe-to-delete candidates): **47** - marked UNUSED in `docs/CODE_MAP.md`
- Imports whose letter case does not match the real file name: **0** (works on Windows only; fix before building on Linux/macOS)
<!-- AUTO:inventory:end -->
