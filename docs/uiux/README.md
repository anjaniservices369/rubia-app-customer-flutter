# Rubia customer app UI/UX

This folder contains editable, browser-based UI/UX prototypes for the Rubia
customer app.

## Registration flow

Open [registration-flow.html](registration-flow.html) in a browser. Use the
bottom action buttons to move through the sign-up journey:

1. Enter a 10-digit mobile number and accept the terms.
2. Enter the four-digit OTP.
3. Add a name and email; profile photo, gender, date of birth, and referral
   code are optional.
4. Add two emergency-contact phone numbers.
5. Enable location to finish registration.

This is a visual prototype. It does not send an OTP, save profile data, request
device permissions, or connect to the app's APIs.

## Login, Home, and service booking

Open [service-booking-flow.html](service-booking-flow.html) in a browser and
use the phone preview or the journey controls to explore:

1. **Login:** enter a valid 10-digit Indian mobile number, accept the terms,
   and continue to OTP. The preview accepts any four-digit code.
2. **Home:** see the pickup location, Driver and Taxi service cards, a
   promotional Driver banner, and the Home/Profile bottom navigation.
3. **Driver booking:** choose one-way or round trip, in-city or out-station,
   automatic or manual gearbox, and a car type (SUV+, SUV, Sedan, Hatchback).
   Set pickup, drop (one-way only), and pickup time. The estimate review
   summarizes the choices and shows a clearly labelled sample fare before a
   simulated confirmation.
4. **Taxi booking:** choose Bike, Auto, or Car, set pickup and destination,
   review the sample fare and cash payment, then preview the ride request.

The left-side journey controls can open Login, OTP, Home, Driver, or Taxi
directly. The screen buttons advance and return within each flow. Validation
covers invalid login details, incomplete one-way routes, missing taxi
destinations, and past pickup times. Round trips require a pickup but no drop.

The live app opens Bookings from the Bookings button on the Driver booking
screen and after ride confirmation; the prototype focuses on the booking
journey rather than the bookings list.

This prototype demonstrates layout and interaction only. It does not send OTPs,
look up actual locations or fares, request permissions, create bookings, or
contact drivers. No entered personal information is sent or saved. Real app
behavior and current implementation details are documented in
[PROJECT_GUIDE.md](../../PROJECT_GUIDE.md).

## Design conventions

- Flutter UI navy: `tDarkNavyblue` (`#144272`); prototype navy: `#142A43`.
- Do not use black or near-black. Use the existing grey palette for secondary
  text, borders, and disabled states.
- The customer-facing login tagline is “Welcome! Book a professional service.”
- Keep the distinction between the Driver service (a professional drives the
  customer's own car) and Taxi (Bike, Auto, or Car rides).
