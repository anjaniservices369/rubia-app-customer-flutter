// =============================================================================
// WHAT : TAXI: map widget used by the ride screens.
// NOTES: Visual component.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// >>> START: CustomGoogleMap - screen/widget
class CustomGoogleMap extends StatelessWidget {
  final String apiKey;
  final ValueNotifier<LatLng> sourceLatLngNotifier;
  final ValueNotifier<LatLng> destinationLatLngNotifier;

  CustomGoogleMap({
    required this.apiKey,
    required this.sourceLatLngNotifier,
    required this.destinationLatLngNotifier,
  });

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LatLng>(
      valueListenable: sourceLatLngNotifier,
      builder: (context, sourceLatLng, _) {
        return ValueListenableBuilder<LatLng>(
          valueListenable: destinationLatLngNotifier,
          builder: (context, destinationLatLng, _) {
            return GoogleMap(
              onMapCreated: (controller) {
                // Your map initialization code
              },
              initialCameraPosition:
                  CameraPosition(target: sourceLatLng, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId('source'),
                  position: sourceLatLng,
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: destinationLatLng,
                ),
              },
            );
          },
        );
      },
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: CustomGoogleMap - screen/widget
