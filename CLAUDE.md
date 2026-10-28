# Notes for AI assistants working on this repo

- After changing any file under lib/, run: python tools/annotate_code.py && python tools/update_docs.py
  (refreshes the // >>> START / // <<< END markers and docs/CODE_MAP.md).
- Every Dart file starts with a plain-language header block; new files need one.
- Behaviour changes (booking, payment, login, ride steps) must also go into PROJECT_GUIDE.md (narrative parts are not generated).
- Build for a phone against the local server: flutter build apk --debug --dart-define=API_BASE_URL=http://127.0.0.1:8080/api
  (no trailing slash) and adb reverse tcp:8080 tcp:8080. Never commit that URL, API keys or secrets.
- The Back key must never close the app from inside a flow: use Twl.navigateTo / forceNavigateTo (they return false) and Twl.backToTab.
- Dev only: test customers 9999900001/2/3 (OTP 1234). Other numbers send a real SMS. Never deploy from here.
- When editing files with scripts, a backslash followed by a letter inside a normal Python string becomes a control character (a bell slipped into PHP twice); use raw strings or the Edit tool.
