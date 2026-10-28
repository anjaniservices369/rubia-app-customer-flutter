# Google Play - Data safety answers: Rubia (customer app, com.rubia.user)

Play Console -> App content -> Data safety. Answers below match what the app does today (checked in the code on 28 Oct 2026).
Fill every question; "Incomplete data safety declaration" disappears when the form is saved and submitted.

## 1. Overview questions
| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** |
| Is all of the user data collected by your app encrypted in transit? | **Yes** (the live server is https only) |
| Do you provide a way for users to request that their data is deleted? | **Yes** |
| Account creation methods | **Username/phone number and OTP** (phone number + one-time code) |
| Delete account URL | `https://<your production domain>/account-deletion` (the page is in the backend; deploy it first) |
| Can users request deletion of some data without deleting the account? | No |
| Privacy policy URL | the public Privacy Policy page of the website (written in the admin dashboard) |

## 2. Data types collected
"Shared" = sent to a third party for its own use. Sending data to a service provider that only processes it for us (OneSignal, Sentry, Google Maps) is **not** sharing in Play's definition. Name, phone number and live location go to the driver of a ride only to carry out that ride; Play treats that as user-directed transfer, so it is not marked as shared.

| Category | Data type | Collected | Shared | Optional? | Purposes |
|---|---|---|---|---|---|
| Personal info | Name | Yes | No | Required | App functionality, Account management |
| Personal info | Email address | Yes | No | Required | App functionality, Account management, Communications |
| Personal info | Phone number | Yes | No | Required | App functionality, Account management, Fraud prevention and security |
| Personal info | User IDs | Yes | No | Required | App functionality, Account management |
| Personal info | Other info (date of birth, gender) | Yes | No | **Optional** | Account management |
| Location | Approximate location | Yes | No | Required | App functionality |
| Location | Precise location | Yes | No | Required | App functionality (pickup, drop, driver matching). Only while the app is in use (no background location in this app) |
| Photos and videos | Photos | Yes | No | **Optional** (profile photo) | App functionality |
| Financial info | Purchase history / payment info | Yes (booking amounts and payment status; **no card or bank numbers are stored**) | No | Required | App functionality, Account management |
| App activity | App interactions / Other user-generated content (ratings and reviews) | Yes | No | Required (the rating after a ride is compulsory) | App functionality |
| App info and performance | Crash logs, Diagnostics | Yes (Sentry; personal data not sent) | No | Required | Analytics (app stability) |
| Device or other IDs | Device or other IDs (push notification id) | Yes (OneSignal) | No | Required | App functionality (ride notifications) |
| Contacts | - | **No** | - | - | The app no longer asks for the contacts permission (removed 28 Oct 2026). Emergency contacts are typed in by the user: declare their phone numbers under Personal info -> Phone number (already above). |

Not collected: messages, audio, files, calendar, health, web browsing, installed apps, SMS/call logs.

## 3. Things to double check before you submit
- The manifest no longer contains READ_CONTACTS, WRITE_CONTACTS or GET_ACCOUNTS. Upload the new build, or Play will still read them from the old one and ask for a permissions declaration.
- The Privacy Policy text must say the same as this table (and mention account deletion). Edit it in the admin dashboard (Pages).
- If you later add Google Analytics, Firebase, ads or a payment SDK that reads card data, update this form.
