// =============================================================================
// WHAT : Reads the login code from the incoming SMS so the customer does not
//        have to type it (Android).
// NOTES: Uses Google's SMS User Consent: Android asks the user once to share
//        the message. Only SMS mentioning 'Rubia' are accepted.
// =============================================================================
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

// >>> START: OtpSmsReader - reads the OTP from the incoming SMS (Android)
/// Reads the login OTP from the incoming SMS (Android only).
///
/// Uses Google's SMS User Consent API: no SMS permission is needed and the SMS
/// does not have to contain an app hash. When a message with a one-time code
/// arrives, Android asks the user once to share it with the app, and the code
/// is handed to [start]'s callback.
///
/// Messages that do not mention [brand] are ignored, so a code from another
/// sender cannot fill the field.
///
/// The OTP value is only written to the log in debug builds.
class OtpSmsReader {
  // Google's SMS listener (shared helper from the smart_auth package).
  final SmartAuth _smartAuth = SmartAuth.instance;
  // True while we are waiting for an SMS.
  bool _listening = false;
  // Set by stop() so a late SMS is ignored after the screen is closed.
  bool _stopped = false;

  /// How many foreign messages are skipped before giving up.
  static const int _maxMessages = 3;

  // >>> START: start - starts listening for the OTP SMS and hands the code to the screen
  /// Starts listening and calls [onCode] with the OTP of the first matching SMS.
  /// The listener ends after a match, a cancel, an error, or the platform's
  /// 5 minute timeout.
  Future<void> start({
    required void Function(String code) onCode,
    int length = 4,
    String brand = 'rubia',
  }) async {
    // 1. Only Android supports this; also never start a second listener.
    if (kIsWeb || !Platform.isAndroid || _listening) return;
    _listening = true;
    _stopped = false;
    _log('listening for the OTP SMS');

    try {
      // 2. Wait for up to three messages: skip any that are not Rubia's.
      for (var i = 0; i < _maxMessages && !_stopped; i++) {
        // 3. Ask Android for the next SMS. The code is a run of exactly
        //    [length] digits, not part of a longer number.
        final result = await _smartAuth.getSmsWithUserConsentApi(
          matcher: '(?<!\\d)\\d{$length}(?!\\d)',
        );
        // 4. The screen may have closed while we waited.
        if (_stopped) return;

        if (result.hasData) {
          final sms = result.requireData;
          final code = sms.code;
          // 5. Accept only a Rubia message that contains a code of the right size.
          final fromBrand = sms.sms.toLowerCase().contains(brand);
          if (fromBrand && code != null && code.length == length) {
            _log(kDebugMode
                ? 'SMS received, OTP = $code'
                : 'SMS received, OTP of $length digits read');
            // 6. Hand the code to the OTP screen, which fills the boxes.
            onCode(code);
            return;
          }
          // 7. Not our message: keep waiting for the next one.
          _log('ignored an SMS that is not the $brand OTP');
          continue;
        }
        // 8. The user declined, or reading failed: stop quietly.
        _log(result.isCanceled
            ? 'the user declined to share the SMS'
            : 'could not read the SMS: ${result.error}');
        return;
      }
    } finally {
      _listening = false;
    }
  }
  // <<< END: start - starts listening for the OTP SMS and hands the code to the screen

  // >>> START: stop - stops listening for the SMS
  /// Stops listening (call from the screen's dispose).
  Future<void> stop() async {
    _stopped = true;
    if (!_listening) return;
    await _smartAuth.removeUserConsentApiListener();
  }
  // <<< END: stop - stops listening for the SMS

  // Writes a line to the developer log with a fixed prefix.
  void _log(String message) => debugPrint('OtpSmsReader: $message');
}
// <<< END: OtpSmsReader - reads the OTP from the incoming SMS (Android)
