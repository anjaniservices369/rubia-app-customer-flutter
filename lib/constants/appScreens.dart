// =============================================================================
// WHAT : The small set of screens this app actually ships today.
// NOTES: Rubia customers book a Driver or a Taxi (bike / auto / car, Uber and
//        Rapido style). The cards come from the server's services list; only
//        the types below are shown. Other tiles exist in code but are not
//        live. Flip the flags below when a product should appear.
// =============================================================================

import 'constants.dart';

// >>> START: AppScreens - helper class
class AppScreens {
  AppScreens._();

  /// Live service tiles on Home. Everything else is hidden unless
  /// [showComingSoonServices] is true.
  static const Set<int> liveServiceTypes = {DRIVER, TAXI};

  /// When false, Home only shows live services (Driver). When true, the old
  /// "Coming soon" grid (Taxi, Auto, Bike, Hotel, Jobs…) is shown again.
  static const bool showComingSoonServices = false;

  /// Wallet tab is already off in the bottom bar. Keep this in one place so
  /// it can be turned back on without hunting through navigation.
  static const bool showWalletTab = false;

  static bool isLiveService(dynamic type) {
    final parsed = type is int ? type : int.tryParse(type?.toString() ?? '');
    if (parsed == null) return false;
    return liveServiceTypes.contains(parsed);
  }
}
// <<< END: AppScreens - helper class
