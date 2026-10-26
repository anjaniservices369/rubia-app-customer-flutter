// =============================================================================
// WHAT : Data shape for a map pin label.
// NOTES: Used by the map screens.
// =============================================================================
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// >>> START: PinInformation - helper class
class PinInformation {
  String pinPath;
  String avatarPath;
  LatLng location;
  String locationName;
  Color labelColor;

  PinInformation(
      {required this.pinPath,
      required this.avatarPath,
      required this.location,
      required this.locationName,
      required this.labelColor});
}
// <<< END: PinInformation - helper class
