# Rubia Customer App – Project Guide

Written for: the business owner (no technical background needed) and for new developers who join later.
Last updated: 26 Oct 2026.

---

## 1. What this app is

The **Rubia Customer App** is the Android/iOS app that Rubia's *customers* use.
Today it is mainly used to **book a professional driver** who drives the customer's own car
("Rubia Driver" service). The home screen also has tiles for Taxi, Auto, Bike, Hotel, Jobs, Real
Estate, Travel and Home Services, but these show **"Coming soon"** except Drivers.

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

1. **Welcome** → the customer taps *Get Started*.
2. **Login** → enters the mobile number. The server sends a 4-digit **OTP by SMS**.
3. **OTP** → the app reads the SMS automatically and signs the customer in.
4. **Profile (first time)** → name, email, gender, date of birth, emergency contacts.
5. **Home** → taps **Drivers**.
6. **Choose trip** → one-way or round trip; in-city or out-station.
7. **Pickup and drop** → picked on a map. The app checks the place is inside Rubia's service area.
8. **Car and time** → automatic/manual, car type (SUV+, SUV, Sedan, Hatchback), date and time.
9. **Estimate** → the server calculates the price (e.g. ₹609 for 2 hours). Coupons can be applied.
10. **Confirm Ride** → the booking is saved: *"Your order has been placed"*.
11. **Waiting for driver** → a driver accepts. The customer sees the driver and a 4-digit **ride OTP**.
12. **Ride** → the driver arrives, the customer shares the OTP, the ride starts and ends.
13. **Pay and rate** → pay cash/wallet, rate the driver.
14. **Cancel** (optional) → the customer can cancel; a cancellation fee may apply.

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
  taxiservices/              The Taxi service screens (built, currently hidden)
  globalWidgets/             Reusable pieces (buttons, map pickers, cards)
  globalFuctions/            Shared helper functions
  periodic_notification/     Background status check after a booking
  models/                    Data shapes returned by the server
android/ ios/ web/           Platform packaging
assets/                      Images and icons
```

Every source file starts with a short **WHAT / NOTES** block explaining it in plain words.
Files marked **INACTIVE** are fully commented out and can be deleted safely.

### The `api_services` folder

| File | In plain words |
|---|---|
| `ApiHelper.dart` | The one door to the server; handles errors and retries |
| `userApi.dart` | The list of every request the app can make |
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

**Firebase has been removed completely** (messaging, storage, database, dynamic links).

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
2. **Backend:** from `../rubia-backend-php/app` run `php -S 127.0.0.1:8080 -t . index.php` with
   these environment variables and options (nothing in the code is changed):
   - `YII_ENV=dev`, `YII_DEBUG=0`
   - `OTP_TEST_NUMBERS=<customer number>,<driver number>` and `OTP_TEST_CODE=<4 digits>`: a dev-only
     test login that skips the SMS. It works only in dev mode and only from the same machine.
   - `-d error_reporting=8191`: PHP 8.2 warns about `strtotime(null)` in the fare code and that
     warning otherwise makes the estimate fail.
   - `-d curl.cainfo=<cacert.pem>` and `-d openssl.cafile=<cacert.pem>`: this PHP has no
     certificate list, so calls to Google fail without it.
3. **Phone:** `adb reverse tcp:8080 tcp:8080`, then build and install the app with
   `--dart-define=API_BASE_URL=http://localhost:8080/api`.
4. **Customer in the app:** Get Started → phone number → tick the terms box → OTP → name and
   email → emergency contacts (two numbers) → Home → Drivers → one-way, in-city → pick the drop
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

---

## 8. Known issues and open decisions (for the owner)

1. **Live server is not updated.** Login on the live server fails with "OTP failed" until the new
   backend package is deployed (see the backend's `DEPLOY.md`).
2. **Dispatch to drivers** needs a scheduled job (cron) on the server to offer new bookings to
   online drivers. Without it, the Partner app shows "No Bookings found".
3. **Taxi, Auto, Bike are "Coming soon"** because the home screen opens only the first tile.
   Enabling them is a product decision plus a small code change.
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

## 10. Booking flow screen by screen, and how to shorten it (audit of 26 Oct 2026)

This is what the customer goes through today to book a driver, taken from walking the app on a
phone and reading the code. **Nothing here is implemented yet; the right-hand column is a
proposal for the owner to approve.**

| # | Screen today | Options on it | File | Proposal |
|---|---|---|---|---|
| 1 | Home | Drivers tile (others "Coming soon"), bottom tabs | `homePage/homePage.dart` | Keep |
| 2 | Select ride type | One-way / Round trip tabs, In-city / Out-station cards, Next | `RideBooking/selectRideType.dart` | Merge into screen 3 as two toggles at the top |
| 3 | Pickup and drop | Pickup (from GPS), drop row, Automatic / Manual, car types (SUV+, SUV, Sedan, Hatchback), Next | `RideBooking/selectLocationPage.dart` | Becomes the single booking screen |
| 4 | Drop sheet | "Choose from favourites" list, "Select From Map" | `RideBooking/FavLocations.dart` | Show favourites inside screen 3; open the map only for a new place |
| 5 | Map picker | Drag the map, "Select Location" | map pickers in `globalWidgets/` | Keep (needed for a new place) |
| 6 | Date and time sheet | Today / tomorrow, time spinner, OK (asks the server for the estimate) | `dummy.dart` (class `Clock`) | Inline "When" row on screen 3, default to the next free slot |
| 7 | Estimate page | Summary, fare, usage hours 1-3, Coupon, payment (Cash), Next | `homePage/components/OneWay.dart` | Merge with screen 8 |
| 8 | Confirm sheet | Same fare again, date, hours, Confirm Ride | `homePage/components/confirmride.dart` | Merge with screen 7: one "Estimate and confirm" page |
| 9 | My Bookings | Active / Completed / Cancelled tabs | `Bookings/` | Keep; after confirming, go straight to screen 10 |
| 10 | Ride details | Map, ride OTP, driver, estimate price, cancel | `Bookings/bookingPageView.dart` | Keep |

**Today:** 8 steps from tapping Drivers to the confirmed booking (2, 3, 4, 5, 6, 7, 8, plus the
bookings list), with the fare shown twice (7 and 8).

**Proposed:** 3 steps.
1. **Book a driver** (screen 3 expanded): trip type toggles, pickup and drop with favourites,
   gear and car type, date and time. The fare is requested automatically as soon as the details are
   complete, and shown at the bottom of the same screen.
2. **Estimate and confirm** (screens 7 + 8): fare breakdown, usage hours, coupon, payment, one
   **Confirm Ride** button.
3. **Ride details** (screen 10), opened directly after confirming.

**Things to keep in mind when changing it:**
- All choices live in `TripOptionsProvider` (`providers/riderProvider.dart`), so the merge is
  mostly moving widgets, not changing data or server calls.
- Round trip needs only the pickup (the driver returns to it); one-way needs pickup and drop.
- The server still decides the price; the app must keep sending the same `get-estimate` fields.
- Out-station trips use a different server fare, so the In-city / Out-station toggle must stay.
- Back-button behaviour: today it clears the booking and returns Home; keep that on the merged
  screen.

---
## Live inventory (generated)

<!-- AUTO:inventory:start -->
_This block is generated by `tools/update_docs.py` (last run 2026-10-14). Do not edit it by hand._

- Source files: **150**
- Server endpoints: **50**  (see `docs/API_ENDPOINTS.md`)
- Full file list: `docs/CODE_MAP.md`; status numbers: `docs/STATUS_CODES.md`
- Files without an explanatory header: **0**
- Files without START/END markers: **0**
- Files no screen imports (safe-to-delete candidates): **47** - marked UNUSED in `docs/CODE_MAP.md`
- Imports whose letter case does not match the real file name: **0** (works on Windows only; fix before building on Linux/macOS)
<!-- AUTO:inventory:end -->
