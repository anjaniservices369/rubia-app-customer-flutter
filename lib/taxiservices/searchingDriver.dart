// =============================================================================
// WHAT : TAXI: the 'Searching for driver' screen that switches content as the
//        ride status changes.
// NOTES: Reads the live ride from RideService (polling the server every 3
//        seconds).
// =============================================================================
import 'dart:async';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/taxiservices/Ride/completedride/rideCompleted.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';

import '../providers/riderProvider.dart';


// >>> START: SearchingDriverPage - screen/widget shell (the visible part is in its State class)
class SearchingDriverPage extends StatefulWidget {
  SearchingDriverPage({Key? key, this.rideData}) : super(key: key);
  final rideData;
  @override
  State<SearchingDriverPage> createState() => _SearchingDriverPageState();
}
// <<< END: SearchingDriverPage - screen/widget shell (the visible part is in its State class)

// >>> START: _SearchingDriverPageState - the data and logic behind its screen
class _SearchingDriverPageState extends State<SearchingDriverPage> {
  Location location = new Location();

  var _locationData;
  var lat;
  var lng;
  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  void initState() {
    // setInitialLocation();
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  var driverLat, driverLng;

  GoogleMapController? _mapController;

  final controller = Completer<GoogleMapController>();

//FOR GOOGLE MAP WIDGET DEPENDENCY
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.willpopAlert(context);
      },
      child: Scaffold(
          body: Container(
        child: widget.rideData['status'] == TAXI_STATUS_COMPLETE_RIDE
            ? RideCompletedScreen(
                rideData: widget.rideData,
              )
            : Stack(children: [
                //Here maps should be update based upon status
                Consumer<TripOptionsProvider>(
                  builder: (context, rideDataProvider, _) {
                    return rideDataProvider.getMapWidgetForStatus();
                  },
                ),

                Consumer<TripOptionsProvider>(
                  builder: (context, rideDataProvider, _) {
                    return rideDataProvider.getWidgetForStatus();
                  },
                ),
              ]),
      )),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SearchingDriverPageState - the data and logic behind its screen


//   @override

//   void setSourceAndDestinationIcons() async {
//     // Set your custom marker icons here
//   }


//   @override
//   Widget build(BuildContext context) {
//     final tripOptionsProvider = Provider.of<TripOptionsProvider>(context);

//     return StreamBuilder<Map<String, dynamic>>(
//       stream: tripOptionsProvider
//           .getDriverLatLngStream(widget.rideData['driver']['id'].toString()),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           double lat = snapshot.data?['lat'] ?? 0.0;
//           double lng = snapshot.data?['lng'] ?? 0.0;

//           LatLng sourceLatLng =
//               LatLng(lat, lng); // Create the LatLng object here

//           // Set the sourceLatLng to the tripOptionsProvider
//           tripOptionsProvider.sourceLatLng = sourceLatLng;

//           LatLng initialLocation = tripOptionsProvider.sourceLatLng;

//           setSourceAndDestinationIcons();
//           showPinsOnMap(
//             tripOptionsProvider.sourceLatLng,
//             tripOptionsProvider.destinationLatLng,
//           );
//           // // Clear any existing markers
//           // _markers.clear();

//           // // Add the source and destination markers
//           // _markers.add(
//           //   Marker(
//           //     markerId: MarkerId('sourcePin'),
//           //     position: tripOptionsProvider.sourceLatLng,
//           //     icon: BitmapDescriptor.defaultMarkerWithHue(
//           //       BitmapDescriptor.hueGreen, // Set the hue to green
//           //     ),
//           //   ),
//           // );

//           // Rest of the code...

//           return Scaffold(
//             body: Stack(
//               children: <Widget>[
//                 GoogleMap(
//                   myLocationEnabled: true,
//                   compassEnabled: true,
//                   tiltGesturesEnabled: false,
//                   markers: _markers,
//                   polylines: _polylines,
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(
//                     target: initialLocation,
//                     zoom: CAMERA_ZOOM,
//                     tilt: CAMERA_TILT,
//                     bearing: CAMERA_BEARING,
//                   ),
//                   onTap: (LatLng loc) {
//                     // Hide the pin pill when tapping on the map
//                     // hidePinPill();
//                   },
//                   onMapCreated: (GoogleMapController controller) {
//                     controller.setMapStyle(Utils.mapStyles);
//                     _controller.complete(controller);

//                     // Show the pins on the map
//                     showPinsOnMap(tripOptionsProvider.sourceLatLng,
//                         tripOptionsProvider.destinationLatLng);

//                     // Set the route lines on the map from source to destination
//                     setPolylines(tripOptionsProvider.sourceLatLng,
//                         tripOptionsProvider.destinationLatLng);
//                   },
//                 ),
//                 // MapPinPillComponent(
//                 //   pinPillPosition: pinPillPosition,
//                 //   currentlySelectedPin: currentlySelectedPin,
//                 // ),
//               ],
//             ),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }

//   // Rest of the code...

//   void showPinsOnMap(LatLng sourceLatLng, LatLng destinationLatLng) {
//     // Clear any existing markers
//     _markers.clear();

//     // Add the source and destination markers
//     _markers.add(
//       Marker(
//         markerId: MarkerId('sourcePin'),
//         position: sourceLatLng,
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen, // Set the hue to green
//         ),
//       ),
//     );

//     _markers.add(
//       Marker(
//         markerId: MarkerId('destPin'),
//         position: destinationLatLng,
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed, // Set the hue to red
//         ),

//   void setPolylines(LatLng sourceLatLng, LatLng destinationLatLng) async {
//     // Clear any existing polylines
//     _polylines.clear();
//     polylineCoordinates.clear();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       mapKey,
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }

//     setState(() {
//       _polylines.add(
//         Polyline(
//           width: 10,
//           polylineId: PolylineId("poly"),
//           color: Color.fromARGB(255, 40, 122, 198),
//           points: polylineCoordinates,
//         ),


//   @override
//   State<SearchingDriverPage> createState() => _SearchingDriverPageState();
// }

// class _SearchingDriverPageState extends State<SearchingDriverPage> {
//   final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Access the TripOptionsProvider instance
//   //   final tripOptionsProvider =
//   //       Provider.of<TripOptionsProvider>(context, listen: false);


//   @override

//     // Pass the RideDataProvider instance to the TripOptionsProvider
//       body: Stack(
//         children: [
//           StreamBuilder<Map<String, dynamic>>(
//             stream: tripOptionsProvider.getDriverLatLngStream(driverId),
//             builder: (context, snapshot) {
//               print("Stream snapshot: $snapshot");
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // Show a loading indicator while waiting for the stream data
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 // Show an error message if an error occurred in the stream
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 // Get the driver's data from the snapshot
//                 Map<String, dynamic> driverData = snapshot.data!;
//                 double driverLatitude = driverData['lat'] ?? 0.0;
//                 double driverLongitude = driverData['lng'] ?? 0.0;
//                 print("Driver Data");
//                 // Update the sourceLatLngNotifier with the driver's latitude and longitude
//                 tripOptionsProvider.sourceLatLngNotifier.value =
//                     LatLng(driverLatitude, driverLongitude);

//                 // Handle destinationLatLng updates here if applicable

//                 return Container(
//                   height: MediaQuery.of(context).size.height / 1.2,
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: sourceLatLng,
//                       zoom: 15,
//                     ),
//                     markers: {
//                       Marker(
//                         markerId: MarkerId('sourceMarker'),
//                         position: sourceLatLng,
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueGreen,
//                         ),
//                       ),
//                       Marker(
//                         markerId: MarkerId('destinationMarker'),
//                         position: destinationLatLng,
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueRed,
//                         ),
//                       ),
//                     },
//                     polylines: {
//                       Polyline(
//                         polylineId: PolylineId('route'),
//                         color: Colors.blue,
//                         width: 5,
//                         points: [
//                           sourceLatLng,
//                           destinationLatLng,
//                         ],
//                       ),
//                     },
//                     onMapCreated: (controller) {
//                       _mapController = controller;
//                     },
//                   ),
//                 );
//               }
//             },
//           ),
//           Text(sourceLatLng.toString()),
//           Consumer<TripOptionsProvider>(
//             builder: (context, rideDataProvider, _) {
//               return rideDataProvider.getWidgetForStatus();
//             },
//           ),
//         ],
// >>> START: Utils - helper class
class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
// <<< END: Utils - helper class
