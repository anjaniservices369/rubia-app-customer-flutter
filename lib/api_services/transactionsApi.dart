// =============================================================================
// WHAT : Asks the server for the customer's transactions of one month, across
//        every service (Driver, Bike, Auto, Car) and the Wallet.
// NOTES: Server: /api/user/my-transactions?month=YYYY-MM. The answer is already
//        grouped by day and carries the month totals and the last 6 months.
// =============================================================================
import 'package:flutter/material.dart';

import '../constants/apiConstants.dart';
import 'ApiHelper.dart';

// >>> START: TransactionsMonth - one month of transactions as the server sends it
class TransactionsMonth {
  TransactionsMonth(this.json);
  final Map json;

  String get month => '${json['month']}';
  Map get summary => (json['summary'] ?? const {}) as Map;
  double get totalSpent => _num(summary['total_spent']);
  double get walletAdded => _num(summary['wallet_added']);
  int get count => int.tryParse('${summary['count']}') ?? 0;
  List<Map> get byService =>
      ((summary['by_service'] ?? const []) as List).whereType<Map>().toList();
  List<Map> get days =>
      ((json['days'] ?? const []) as List).whereType<Map>().toList();
  /// The last 6 months (newest first): {month, total_spent, count}.
  List<Map> get monthly =>
      ((json['monthly'] ?? const []) as List).whereType<Map>().toList();

  static double _num(dynamic v) => double.tryParse('$v') ?? 0;
}
// <<< END: TransactionsMonth - one month of transactions as the server sends it

// >>> START: TransactionsApi - the transactions request
class TransactionsApi {
  /// [month] is "YYYY-MM". Returns null when the request failed (a message has
  /// already been shown by ApiHelper) or the server refused.
  static Future<TransactionsMonth?> fetch(BuildContext context, String month) async {
    final headers = await ApiHelper().getHeader(context);
    final res = await ApiHelper().getTypeGet(
        context, '$MY_TRANSACTIONS${headers['auth_code']}&month=$month');
    if (res is Map && res['status'] == 'OK' && res['details'] is Map) {
      return TransactionsMonth(res['details'] as Map);
    }
    return null;
  }
}
// <<< END: TransactionsApi - the transactions request
