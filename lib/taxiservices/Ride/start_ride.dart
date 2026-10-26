// =============================================================================
// WHAT : TAXI: map while the ride is in progress (pickup to drop).
// NOTES: Taxi service.
// =============================================================================
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:base_project_flutter/taxiservices/rideservices/riderServices.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
import '../../constants/constants.dart';
import '../../responsive.dart';
import '../components/pin_pill_info.dart';

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 60;
const double CAMERA_BEARING = 40;

// >>> START: StartRide - screen/widget shell (the visible part is in its State class)
class StartRide extends StatefulWidget {
  StartRide({
    Key? key,
    this.rideData,
  }) : super(key: key);
  final rideData;

  @override
  _StartRideState createState() => _StartRideState();
}
// <<< END: StartRide - screen/widget shell (the visible part is in its State class)

// >>> START: _StartRideState - the data and logic behind its screen
class _StartRideState extends State<StartRide> {
  LatLng SOURCE_LOCATION = LatLng(17.448294, 78.391487);
  LatLng DEST_LOCATION = LatLng(17.451293, 78.396568);
  var sourceLat;
  var sourceLng;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _deliveredMarkers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

// wrapper around the location API
  Location? location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation? sourcePinInfo;
  PinInformation? destinationPinInfo;

  LocationData? currentLocation;

  LocationData? destinationLocation;

  Timer? _driverTimer;

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _driverTimer?.cancel();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    // setInitialLocation();
    polylinePoints = PolylinePoints();
    fetchStoreDetails();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  bool isLoading = true;
  var orderDetails;
  // >>> START: fetchStoreDetails - fetches store details
  void fetchStoreDetails() async {
    setState(() {
      SOURCE_LOCATION = LatLng(
          double.parse(widget.rideData['pickup_latitude'].toString()),
          double.parse(widget.rideData['pickup_longitude'].toString()));
      DEST_LOCATION = LatLng(
          double.parse(widget.rideData['drop_latitude'].toString()),
          double.parse(widget.rideData['drop_longitude'].toString()));
      sourceLat =
          double.parse(widget.rideData['pickup_latitude'].toString()); //
      sourceLng =
          double.parse(widget.rideData['pickup_longitude'].toString()); //
      destinationLocation = LocationData.fromMap({
        "latitude": SOURCE_LOCATION.latitude,
        "longitude": SOURCE_LOCATION.longitude
      });
      setSourceAndDestinationIcons();
    });
    if (widget.rideData['driver']['id'] != null) {
      // set the initial location
      setInitialLocation();
    }
  }
  // <<< END: fetchStoreDetails - fetches store details

  // >>> START: setSourceAndDestinationIcons - sets source and destination icons
  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/icons/mapBike.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/dropLocation.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }
  // <<< END: setSourceAndDestinationIcons - sets source and destination icons

  // >>> START: setInitialLocation - sets initial location
  void setInitialLocation() async {

    // Driver position comes from the backend (polled), not Firestore.
    Future<void> refreshDriverLocation() async {
      final loc = await RideService().driverLocation(widget.rideData['ride_id']);
      if (loc == null) return;
      final lat = loc['lat']!;
      final lng = loc['lng']!;
      SOURCE_LOCATION = LatLng(lat, lng);
      if (mounted) {
        setState(() {
          sourceLat = lat;
          sourceLng = lng;
        });
        updatePinOnMap();
      }
    }

    refreshDriverLocation();
    _driverTimer?.cancel();
    _driverTimer = Timer.periodic(
        const Duration(seconds: 4), (_) => refreshDriverLocation());
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
    currentLocation =
        LocationData.fromMap({"latitude": sourceLat, "longitude": sourceLng});
  }
  // <<< END: setInitialLocation - sets initial location

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: SOURCE_LOCATION,
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Container(
        margin: EdgeInsets.symmetric(horizontal: isDesktop(context) ? 10.w : 0),
        child: Scaffold(
            body: Stack(children: [
          sourceLat != null && sourceLng != null
              ?
              // GoogleMap(
              //     // onMapCreated: _onMapCreated,
              //     myLocationButtonEnabled: true,
              //     mapType: MapType.normal,
              //     myLocationEnabled: true,
              //     initialCameraPosition: const CameraPosition(
              GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  onTap: (LatLng loc) {
                    pinPillPosition = -100;
                  },
                  onMapCreated: (GoogleMapController controller) {
                    // controller.setMapStyle(Utils.mapStyles);
                    _controller.complete(controller);
                    // my map has completed being created;
                    // i'm ready to show the pins on the map
                    showPinsOnMap();
                  })
              : Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: tPrimaryColor)),
        ])));
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: showPinsOnMap - shows pins on map
  void showPinsOnMap() async {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    final Uint8List destiIcon =
        await getBytesFromAsset('assets/images/dropLocation.png', 150);
    var pinPosition = LatLng(sourceLat, sourceLng);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation!.latitude!, destinationLocation!.longitude!);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: SOURCE_LOCATION,
        pinPath: "assets/icons/mapBike.png",
        avatarPath: "assets/friend1.jpg",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: DEST_LOCATION,
        pinPath: "assets/images/dropLocation.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon!));
    // destination pin
    _markers.add(Marker(
      markerId: MarkerId('destPin'),
      position: destPosition,
      onTap: () {
        setState(() {
          currentlySelectedPin = destinationPinInfo!;
          pinPillPosition = 0;
        });
      },
      icon: BitmapDescriptor.fromBytes(destiIcon),
    )); //change

    _deliveredMarkers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon!));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }
  // <<< END: showPinsOnMap - shows pins on map

  // >>> START: setPolylines - sets polylines
  void setPolylines() async {
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
      googleApiKey: mapKey,
      request: PolylineRequest(
        origin: PointLatLng(sourceLat, sourceLng),
        destination: PointLatLng(
            destinationLocation!.latitude!, destinationLocation!.longitude!),
        mode: TravelMode.walking,
      ),
    );
    // print(result.points.toString());
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: tPrimaryColor,
            points: polylineCoordinates));
      });
    }
  }
  // <<< END: setPolylines - sets polylines

  // >>> START: updatePinOnMap - updates pin on map
  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/mapBike.png', 100);
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(sourceLat, sourceLng),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (mounted) {
      setState(() {
        polylineCoordinates.clear();
        setPolylines();
        // setPolylines();
        // updated position
        var pinPosition = LatLng(sourceLat, sourceLng);

        sourcePinInfo!.location = pinPosition;

        // the trick is to remove the marker (by id)
        // and add it again at the updated location
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo!;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
      });
    }
  }
  // <<< END: updatePinOnMap - updates pin on map
}
// <<< END: _StartRideState - the data and logic behind its screen

// >>> START: getBytesFromAsset - gets bytes from asset
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
// <<< END: getBytesFromAsset - gets bytes from asset
