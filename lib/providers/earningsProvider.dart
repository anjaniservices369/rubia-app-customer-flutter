// =============================================================================
// WHAT : Holds a small earnings figure for display.
// NOTES: Currently minimal.
// =============================================================================
import 'package:flutter/material.dart';

// >>> START: EarningsProvider - shared app memory (provider) other screens listen to
class EarningsProvider extends ChangeNotifier {
  String _filterValue = "All";
  var _startDate = '';
  var _endDate = '';

  String get startDate => this._startDate;
  // >>> START: startDate - starts date
  set startDate(value) {
    this._startDate = value;
    notifyListeners();
  }
  // <<< END: startDate - starts date

  String get endDate => this._endDate;
  // >>> START: endDate - end date
  set endDate(value) {
    this._endDate = value;
    notifyListeners();
  }
  // <<< END: endDate - end date

  String get filterValue => this._filterValue;
  // >>> START: filterValue - filter value
  set filterValue(String value) {
    this._filterValue = value;
    notifyListeners();
  }
  // <<< END: filterValue - filter value
}
// <<< END: EarningsProvider - shared app memory (provider) other screens listen to
