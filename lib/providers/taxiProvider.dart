// =============================================================================
// WHAT : Placeholder holder for taxi vehicles.
// NOTES: Almost empty; not used by the live flow.
// =============================================================================
import 'package:flutter/material.dart';

// >>> START: TaxiProvider - shared app memory (provider) other screens listen to
class TaxiProvider with ChangeNotifier {
  List<dynamic> vehicles = [];
}
// <<< END: TaxiProvider - shared app memory (provider) other screens listen to
