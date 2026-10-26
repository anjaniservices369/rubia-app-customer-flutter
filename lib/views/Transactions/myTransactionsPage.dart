// =============================================================================
// WHAT : "My Transactions" screen of the Profile tab: everything the customer
//        paid or received, across every service (Driver, Bike, Auto, Car and
//        the Wallet), grouped by day, with a total for each month.
// NOTES: Pick a month from the strip at the top (the last 6 months, each with
//        its total); a summary card shows the month's total and the split by
//        service; chips narrow the list to one service. Data comes from
//        TransactionsApi (/api/user/my-transactions).
// =============================================================================
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api_services/transactionsApi.dart';
import '../../constants/constants.dart';

// >>> START: MyTransactionsPage - month strip, summary and the day-by-day list
class MyTransactionsPage extends StatefulWidget {
  const MyTransactionsPage({Key? key}) : super(key: key);

  @override
  State<MyTransactionsPage> createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> {
  static const Map<String, IconData> _icons = {
    'driver': Icons.drive_eta,
    'bike': Icons.two_wheeler,
    'auto': Icons.electric_rickshaw,
    'car': Icons.local_taxi,
    'wallet': Icons.account_balance_wallet,
  };
  static const Map<String, Color> _colors = {
    'driver': Color(0xFF1E5AA8),
    'bike': Color(0xFF2E9E5B),
    'auto': Color(0xFFE59A00),
    'car': Color(0xFFD1495B),
    'wallet': Color(0xFF7B5CC4),
  };
  static const List<List<String>> _filters = [
    ['all', 'All'],
    ['driver', 'Driver'],
    ['bike', 'Bike'],
    ['auto', 'Auto'],
    ['car', 'Car'],
    ['wallet', 'Wallet'],
  ];

  final NumberFormat _money = NumberFormat.decimalPattern('en_IN')
    ..maximumFractionDigits = 2;

  String _month = DateFormat('yyyy-MM').format(DateTime.now());
  String _filter = 'all';
  TransactionsMonth? _data;
  // The last 6 months come with every answer; kept so the strip stays put
  // while another month is loading.
  List<Map> _strip = [];
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load(_month);
  }

  // >>> START: _load - loads one month
  Future<void> _load(String month) async {
    setState(() {
      _month = month;
      _loading = true;
      _failed = false;
    });
    final data = await TransactionsApi.fetch(context, month);
    if (!mounted || month != _month) return;
    setState(() {
      _loading = false;
      if (data == null) {
        _failed = true;
      } else {
        _data = data;
        if (data.monthly.isNotEmpty) _strip = data.monthly;
      }
    });
  }
  // <<< END: _load - loads one month

  String _rs(num v) => '$currencySymbol${_money.format(v)}';

  String _monthName(String ym, {bool short = false}) {
    final d = DateTime.tryParse('$ym-01') ?? DateTime.now();
    return DateFormat(short ? 'MMM' : 'MMMM yyyy').format(d);
  }

  // >>> START: _monthStrip - the last 6 months, each with its total
  Widget _monthStrip() {
    // Newest first, drawn from the right: this month sits at the right edge and
    // older months are reached by scrolling left.
    final months = _strip;
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = months[i];
          final ym = '${m['month']}';
          final on = ym == _month;
          final spent = double.tryParse('${m['total_spent']}') ?? 0;
          return GestureDetector(
            onTap: () => _load(ym),
            child: Container(
              width: 92,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: on ? tPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: on ? tPrimaryColor : Colors.black12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_monthName(ym, short: true),
                      style: TextStyle(
                          color: on ? Colors.white : tDarkNavyblue,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(spent > 0 ? _rs(spent) : '-',
                      style: TextStyle(
                          color: on ? Colors.white : Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // <<< END: _monthStrip - the last 6 months, each with its total

  // >>> START: _summaryCard - the month's total, wallet money and the split by service
  Widget _summaryCard(TransactionsMonth d) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tDarkNavyblue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_monthName(_month),
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_rs(d.totalSpent),
              style: const TextStyle(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text('spent', style: TextStyle(color: Colors.white70)),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
            '${d.count} transaction${d.count == 1 ? '' : 's'}'
            '${d.walletAdded > 0 ? '  ·  ${_rs(d.walletAdded)} added to wallet' : ''}',
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        if (d.byService.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in d.byService)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_icons['${s['service']}'], size: 15, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                      '${s['label']}  ${_rs(double.tryParse('${s['amount']}') ?? 0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
          ]),
        ],
      ]),
    );
  }
  // <<< END: _summaryCard - the month's total, wallet money and the split by service

  // >>> START: _filterChips - narrows the list to one service
  Widget _filterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final on = _filter == f[0];
          return ChoiceChip(
            label: Text(f[1]),
            selected: on,
            selectedColor: tPrimaryColor,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: on ? Colors.white : tDarkNavyblue,
                fontWeight: FontWeight.w600),
            onSelected: (_) => setState(() => _filter = f[0]),
          );
        },
      ),
    );
  }
  // <<< END: _filterChips - narrows the list to one service

  // >>> START: _row - one transaction
  Widget _row(Map t) {
    final service = '${t['service']}';
    final credit = t['direction'] == 'credit';
    final amount = double.tryParse('${t['amount']}') ?? 0;
    final when = DateTime.tryParse('${t['date']}'.replaceFirst(' ', 'T'));
    final subtitle = '${t['subtitle'] ?? ''}'.trim();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: (_colors[service] ?? tPrimaryColor).withOpacity(0.12),
          child: Icon(_icons[service], size: 22, color: _colors[service]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${t['title']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: tDarkNavyblue, fontWeight: FontWeight.w700, fontSize: 14)),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ]),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${credit ? '+' : '-'}${_rs(amount)}',
              style: TextStyle(
                  color: credit ? const Color(0xFF2E9E5B) : tDarkNavyblue,
                  fontWeight: FontWeight.w800,
                  fontSize: 15)),
          if (when != null)
            Text(DateFormat('h:mm a').format(when),
                style: const TextStyle(color: Colors.black45, fontSize: 11)),
        ]),
      ]),
    );
  }
  // <<< END: _row - one transaction

  // >>> START: _dayList - the days of the month, newest first, each with its items
  List<Widget> _dayList(TransactionsMonth d) {
    final out = <Widget>[];
    for (final day in d.days) {
      final all = ((day['items'] ?? const []) as List).whereType<Map>().toList();
      final items =
          _filter == 'all' ? all : all.where((t) => t['service'] == _filter).toList();
      if (items.isEmpty) continue;
      final spent = items
          .where((t) => t['direction'] == 'debit')
          .fold<double>(0, (a, t) => a + (double.tryParse('${t['amount']}') ?? 0));
      final date = DateTime.tryParse('${day['date']}');
      out.add(Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(children: [
          Expanded(
            child: Text(
                date == null ? '${day['date']}' : DateFormat('EEE, d MMM yyyy').format(date),
                style: TextStyle(
                    color: tDarkNavyblue, fontWeight: FontWeight.w800, fontSize: 14)),
          ),
          if (spent > 0)
            Text(_rs(spent),
                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
        ]),
      ));
      out.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: items.map(_row).toList()),
      ));
    }
    return out;
  }
  // <<< END: _dayList - the days of the month, newest first, each with its items

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final days = d == null ? <Widget>[] : _dayList(d);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: tDarkNavyblue),
        title: Text('My Transactions',
            style: TextStyle(color: tDarkNavyblue, fontWeight: FontWeight.w800)),
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(_month),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 12, bottom: 32),
          children: [
            if (_strip.isNotEmpty) _monthStrip(),
            if (_failed)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(children: [
                  Icon(Icons.receipt_long, size: 48, color: tDarkNavyblue),
                  const SizedBox(height: 12),
                  Text('Could not load your transactions.',
                      style: TextStyle(color: tDarkNavyblue, fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: tPrimaryColor),
                      onPressed: () => _load(_month),
                      child: const Text('Try again', style: TextStyle(color: Colors.white))),
                ]),
              )
            else if (_loading && d == null)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (d != null) ...[
              Opacity(opacity: _loading ? 0.5 : 1, child: _summaryCard(d)),
              const SizedBox(height: 12),
              _filterChips(),
              if (days.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(children: [
                    Icon(Icons.receipt_long_outlined, size: 48, color: Colors.black26),
                    const SizedBox(height: 10),
                    Text(
                        _filter == 'all'
                            ? 'No transactions in ${_monthName(_month)}'
                            : 'No ${_filters.firstWhere((f) => f[0] == _filter)[1]} transactions in ${_monthName(_month)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54)),
                  ]),
                )
              else
                ...days,
            ],
          ],
        ),
      ),
    );
  }
}
// <<< END: MyTransactionsPage - month strip, summary and the day-by-day list
