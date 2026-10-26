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

1. **Login** → the first screen: logo, a welcome line, the mobile number and the terms tick.
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
9. **Rate the driver, right when the ride ends** → as soon as the ride is completed a
    **"Ride Completed"** sheet opens on top of whatever screen the customer is on (Home,
    Bookings, the live ride screen): driver name, stars, optional review, **Submit** or
    **Later**. **Submit** shows "Thanks for your rating" and opens **Home**; Back does not return
    to the finished ride. **Later** keeps the rating available on the ride's details in
    Bookings → Completed, but the customer is not asked again for that ride.
10. **Pay** → cash or wallet.
11. **Cancel** (optional) → the customer can cancel; a cancellation fee may apply.

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

---

## 8. Known issues and open decisions (for the owner)

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
| 1 | **Login** (first screen; the old separate "Get Started" welcome screen is gone) | Logo and a welcome line, mobile number, tick the terms, **Login**. | `logiPage/loginPage.dart` |
| 2 | **OTP** | Enters the 4 digits (read from the SMS; the 4th digit submits by itself). | `otpPage/otpPage.dart` |
| 3 | **Name, email, referral** (sheet over Home, cannot be dismissed) | Full name and email are required; **referral code is optional**. A wrong code shows "Referral code does not exist" and the sheet stays, so it can be fixed or cleared. | `PersonalDetails/personalDetailsView.dart` |
| 4 | **Emergency contacts** (full screen) | Two phone numbers, required (used by SOS). No back arrow; Back asks to exit the app. | `EmergencyContact/EmergencyContacts.dart` |
| 5 | **Home + location sheet** | Home opens with the "enable location" sheet (the old separate step). | `bottomNavigation.dart` (`showLocationSheet`), `PersonalDetails/components/EnableLocationView.dart` |

Before: Get Started → Login → OTP → name and email sheet → referral sheet → location sheet, and the
emergency contacts were **not** part of that chain: a new customer got them as a surprise full
screen on the **next app start**, and after saving them the old code opened the referral and
location sheets again and left the customer on the contacts screen.

### 12.2 Rules kept

- Emergency contacts stay **required**. If the app is closed before they are saved, the next start
  opens the contacts screen (`main.dart`), then Home (no location sheet in that case).
- If the app is closed after OTP but before the name is saved, the next start opens Home with the
  name sheet again (`check` API: no email yet).
- After the last step Home replaces every earlier screen, so Back from Home leaves the app and
  never returns to a registration screen.
- Deleted as unused: `onBoardingpage/onBoardingPage.dart`, `PersonalDetails/components/referalCardView.dart`.

### 12.3 Tested on the phone (26 Oct 2026, new test number 9999900002)

Login is the first screen; OTP 1234 signed in and opened the name sheet; a wrong referral code
showed the error; with the field cleared **Next** opened Emergency Contacts; two numbers saved
(`user_emergency_contacts` rows for customer 7146) and Home opened. With the contacts deleted and
the app restarted, the contacts screen came first and then Home.

### 12.4 Not done yet

- Gender, date of birth and profile photo are not asked at registration (only in Profile).
- The terms link opens the website; there is no in-app copy of the terms.

---
## Live inventory (generated)

<!-- AUTO:inventory:start -->
_This block is generated by `tools/update_docs.py` (last run 2026-10-26). Do not edit it by hand._

- Source files: **152**
- Server endpoints: **50**  (see `docs/API_ENDPOINTS.md`)
- Full file list: `docs/CODE_MAP.md`; status numbers: `docs/STATUS_CODES.md`
- Files without an explanatory header: **0**
- Files without START/END markers: **0**
- Files no screen imports (safe-to-delete candidates): **47** - marked UNUSED in `docs/CODE_MAP.md`
- Imports whose letter case does not match the real file name: **0** (works on Windows only; fix before building on Linux/macOS)
<!-- AUTO:inventory:end -->
