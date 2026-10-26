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
6. **Book a driver** (one screen) → one-way or round trip; in-city or out-station; then the
   **vehicle first**: automatic/manual and car type (SUV+, SUV, Sedan, Hatchback); then pickup and
   drop on a map (the app checks the place is inside Rubia's service area); pickup time (next free
   slot pre-filled); then **Next**.
7. **Estimate and confirm** (one screen) → the server calculates the price (e.g. ₹609 for 2 hours).
   Hours and coupons can be changed; **Confirm Ride** saves the booking: *"Your order has been
   placed"*.
8. **Waiting for driver** → a driver accepts. The customer sees the driver and a 4-digit **ride OTP**.
9. **Ride** → the driver arrives, the customer shares the OTP, the ride starts and ends.
10. **Rate the driver, right when the ride ends** → as soon as the ride is completed a
    **"Ride Completed"** sheet opens on top of whatever screen the customer is on (Home,
    Bookings, the live ride screen): driver name, stars, optional review, **Submit** or
    **Later**. **Submit** shows "Thanks for your rating" and opens **Home**; Back does not return
    to the finished ride. **Later** keeps the rating available on the ride's details in
    Bookings → Completed, but the customer is not asked again for that ride.
11. **Pay** → cash or wallet.
12. **Cancel** (optional) → the customer can cancel; a cancellation fee may apply.

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
12. **Slow save can show "Failed to save" although the booking exists.** The app waits 30 seconds
    for the server (`api_services/ApiHelper.dart`). While the Google APIs of item 9 are denied, the
    server retries them and one save took 33 seconds, so the app gave up after the booking had
    already been stored (booking 1012). Enabling those APIs fixes the delay; the real fix is for
    the server to save first and look up distances afterwards.

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
| 4 | My Bookings, then Ride details | Follows the booking; ride OTP, driver, cancel | `Bookings/` |

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

### 10.5 Rating when the ride ends (not from the Completed list)

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
## Live inventory (generated)

<!-- AUTO:inventory:start -->
_This block is generated by `tools/update_docs.py` (last run 2026-10-26). Do not edit it by hand._

- Source files: **149**
- Server endpoints: **50**  (see `docs/API_ENDPOINTS.md`)
- Full file list: `docs/CODE_MAP.md`; status numbers: `docs/STATUS_CODES.md`
- Files without an explanatory header: **0**
- Files without START/END markers: **0**
- Files no screen imports (safe-to-delete candidates): **47** - marked UNUSED in `docs/CODE_MAP.md`
- Imports whose letter case does not match the real file name: **0** (works on Windows only; fix before building on Linux/macOS)
<!-- AUTO:inventory:end -->
