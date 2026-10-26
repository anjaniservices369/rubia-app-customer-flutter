// =============================================================================
// WHAT : Small pop-up label that appears over a map pin.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/taxiservices/components/pin_pill_info.dart';
import 'package:flutter/material.dart';

// >>> START: MapPinPillComponent - screen/widget shell (the visible part is in its State class)
class MapPinPillComponent extends StatefulWidget {
  double pinPillPosition;
  PinInformation currentlySelectedPin;

  MapPinPillComponent(
      {required this.pinPillPosition, required this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}
// <<< END: MapPinPillComponent - screen/widget shell (the visible part is in its State class)

// >>> START: MapPinPillComponentState - the data and logic behind its screen
class MapPinPillComponentState extends State<MapPinPillComponent> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 10),
                child: ClipOval(
                    child: Image.asset(widget.currentlySelectedPin.avatarPath,
                        fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.currentlySelectedPin.locationName,
                          style: TextStyle(
                              color: widget.currentlySelectedPin.labelColor)),
                      Text(
                          'Latitude: ${widget.currentlySelectedPin.location.latitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                          'Longitude: ${widget.currentlySelectedPin.location.longitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(widget.currentlySelectedPin.pinPath,
                    width: 50, height: 50),
              )
            ],
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: MapPinPillComponentState - the data and logic behind its screen
