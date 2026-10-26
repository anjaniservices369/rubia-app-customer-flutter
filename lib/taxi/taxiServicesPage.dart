// =============================================================================
// WHAT : First screen of Taxi: one card for each taxi service (Bike, Auto,
//        Car). Rubia runs each of them as its own service with its own
//        backend and database, so the rider chooses the service first and
//        then books inside it.
// NOTES: Opens from the Taxi card on Home. If a taxi ride is still in progress
//        it is reopened straight away (see TaxiApi.active) instead of showing
//        the cards.
// =============================================================================
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'taxiApi.dart';
import 'taxiBookingPage.dart';
import 'taxiRidePage.dart';

// >>> START: TaxiServicesPage - Bike / Auto / Car cards, or the ride in progress
class TaxiServicesPage extends StatefulWidget {
  const TaxiServicesPage({Key? key}) : super(key: key);

  @override
  State<TaxiServicesPage> createState() => _TaxiServicesPageState();
}

class _TaxiServicesPageState extends State<TaxiServicesPage> {
  bool _checked = false;

  static const Map<String, IconData> _icons = {
    'bike': Icons.two_wheeler,
    'auto': Icons.electric_rickshaw,
    'car': Icons.local_taxi,
  };
  static const Map<String, String> _about = {
    'bike': 'Quickest and cheapest for one person',
    'auto': 'Up to 3 people, a budget ride',
    'car': 'Comfortable ride for up to 4 people',
  };

  @override
  void initState() {
    super.initState();
    _resumeRide();
  }

  // >>> START: _resumeRide - reopens a ride in progress, else shows the cards
  Future<void> _resumeRide() async {
    final active = await TaxiApi.active();
    if (active != null) {
      final s = taxiServiceByKey(active['service']!);
      final ride = await TaxiApi.rideDetail(s, active['id']!);
      final status = int.tryParse('${ride?['status']}') ?? 0;
      // 3 cancelled by rider, 7 cancelled by taxi driver, 10 paid: nothing to resume.
      if (ride != null && ![3, 7, 10].contains(status) && mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    TaxiRidePage(serviceKey: s.key, rideId: active['id']!)));
        return;
      }
      await TaxiApi.clearActive();
    }
    if (mounted) setState(() => _checked = true);
  }
  // <<< END: _resumeRide - reopens a ride in progress, else shows the cards

  // >>> START: _card - one taxi service card
  Widget _card(TaxiService s) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => TaxiBookingPage(service: s))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [tBoxShadow],
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: tPrimaryColor.withOpacity(0.12),
            child: Icon(_icons[s.key], size: 32, color: tPrimaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.label,
                  style: TextStyle(
                      color: tDarkNavyblue,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(_about[s.key] ?? '',
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ]),
          ),
          Icon(Icons.chevron_right, color: tDarkNavyblue),
        ]),
      ),
    );
  }
  // <<< END: _card - one taxi service card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: tDarkNavyblue),
        title: Text('Taxi',
            style:
                TextStyle(color: tDarkNavyblue, fontWeight: FontWeight.w800)),
      ),
      body: !_checked
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text('Choose your ride',
                  style: TextStyle(
                      color: tDarkNavyblue,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Book a taxi driver in a bike, auto or car.',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              ...taxiServices.map(_card),
            ]),
    );
  }
}
// <<< END: TaxiServicesPage - Bike / Auto / Car cards, or the ride in progress
