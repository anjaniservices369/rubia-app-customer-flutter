// =============================================================================
// WHAT : App-wide settings: brand colours, booking status numbers and their
//        meaning, trip/car types, service types (Driver, Taxi, Auto, Bike).
// NOTES: The status numbers must match the server. TAXI_STATUS_* are the
//        taxi ride statuses of the server (no Firebase involved).
// =============================================================================
import 'package:flutter/material.dart';

const tDefaultPadding = 20.0;
const tCancelRidebtn = Color(0XFFFF0000);
const tappbarclr = Color(0XFFFFC10C);
const tReferColor = Color(0xFFFFE3CA);
var tPrimaryColor = Color(0XFFFF8F0C);
var tDarkOrangeColor = Color(0xff935A29);
const tRed = Color(0XFFFEA1E1E);
const tPink = Color(0XFFEA1E1E);
var tlightDivider = Color(0xffDFE9F0);
var tdividerGray = Color(0xffC8C7CC);
var tDividerColor = Color(0xffDDDDDD);
var tlightGrayColor = Color(0xffEEEEEE);
var tSecondaryColor = Color(0XFF034694);
var tWhite = Color(0XFFffffff);
const tGray = Color(0XFF757575);
const tSecondaryGary = Color(0XFFE5E5E5);
const tbrownn = Color(0XFF935A29);
const tBlue = Color(0XFF144272);
var tBackground = Color(0XFFF5F5F5);
var tBlack = Color(0xff144272);
var tgreen = Color(0XFF4CC520);
var tDarkNavyblue = Color(0xff144272);
var tYellow = Color(0XFFFFC10C);
const tDivider = Color(0XFFE1E1E1);
const tlightGray = Color(0XFFC4C4C4);
const tpinkcolor = Color(0xffFF6464);
const tlineColor = Color(0xffC8C7CC);
const tDotted = Color(0XFFC8C7CC);

const tbrown = Color(0XFFFFE3CA);
const tGreen = Color(0XFF169755);
const tDarkGreen = Color(0xff169755);
const tDate = Color(0XFF935A29);
const tlocationClr = Color(0XFFA8390E);
const tBackbtnBoxShadow = BoxShadow(
  color: Color(0x23144272),
  blurRadius: 4,
  offset: Offset(0, 1),
);

const tFieldColor = Color(0XFFF3F3F5);
const tBoxShadow = BoxShadow(
  color: Color(0x23144272),
  blurRadius: 4,
  offset: Offset(0, 1),
);

const mapKey = 'AIzaSyCYN4-YdhQ8xm-dzJ62v6VJwUnnjKgL4BE';
const ACCESSTOKEN = '1fcaa010-ad11-11ed-8770-6fbfe796db1b';
const currencySymbol = '₹';
const payment_type_credit = 1;
const payment_type_debit = 2;

const RIDER_TYPE_ONEWAY = 1; // driver takes the customer one way only
const RIDER_TYPE_ROUNDTRIP = 2; // driver waits and brings the customer back

const TRIP_TYPE_INTERCITY = 1; // inside the city (shown as 'Incity')
const TRIP_TYPE_OUTSTATION = 2; // to another city

const CAR_TYPE_AUTOMATIC = 1; // customer's car has automatic gears
const CAR_TYPE_MANUAL = 2; // customer's car has manual gears
//Select ride
// const RIDER_TYPE_ONEWAY = 1;
// const RIDER_TYPE_ROUNDTRIP = 2;

// const TRIP_TYPE_INTERCITY = 1;
// const TRIP_TYPE_OUTSTATION = 2;

// const CAR_TYPE_AUTOMATIC = 1;
// const CAR_TYPE_MANUAL = 2;
// const STATUS_WAITING_FOR_DRIVER = 1; // booking placed, no driver yet
// const STATUS_DRIVER_ACCEPTED = 2; // a driver took the booking

// const STATUS_BOOKING_AUTO_CANCELLED = 7;
// const STATUS_DRIVER_CANCELLED = 8;
const STATUS_WAITING_FOR_DRIVER = 1; // booking placed, no driver yet
const STATUS_DRIVER_ACCEPTED = 2; // a driver took the booking
const STATUS_DRIVER_REJECTED = 3; // a driver declined (booking stays open)
const STATUS_GO_FOR_PICKUP = 4; // driver is on the way to the pickup
const STATUS_ARRIVED_LOCATION = 5; // driver reached the pickup; customer shares the OTP
const STATUS_START_RIDE = 6; // ride in progress (after the OTP is verified)
const STATUS_RIDE_COMPLETED = 7; // ride finished, bill ready
const PAYMENT_STATUS_PAID = 1; // booking.payment_status once the driver has confirmed the payment (collect-cash)
const STATUS_USER_CANCELLED = 8; // customer cancelled (a fee may apply)
const STATUS_BOOKING_AUTO_CANCELLED = 9; // system cancelled (no driver / no show)
const STATUS_DRIVER_CANCELLED = 10; // the driver cancelled
const STATUS_CANCELLED = 11;
const STATUS_ACCEPTED_RIDES = 12;
// service constants
const DRIVER = 1; // service tiles on the home screen: Driver (live)
const TAXI = 2; // Taxi (built, shown as 'Coming soon')
const AUTO = 3;
const BIKE = 4;
const OTHERS = 5;

// Taxi ride status numbers (must match the server)
const TAXI_STATUS_NEW_REQUEST = 1;
const TAXI_STATUS_RIDE_BOOKED = 2;
const TAXI_STATUS_CANCEL_BY_USER = 3;
const TAXI_STATUS_ACCEPTED_BY_SKIPPER = 4;
const TAXI_STATUS_ON_THE_WAY = 5;
const TAXI_STATUS_ARRIVED = 6;
const TAXI_STATUS_CANCEL_BY_SKIPPER = 7;
const TAXI_STATUS_START_RIDE = 8;
const TAXI_STATUS_COMPLETE_RIDE = 9;
const TAXI_STATUS_AMOUNT_COLLECTED = 10;
const TAXI_STATUS_RATING_COMPLETED = 11;
const CHAT_LINK = 'https://wa.me/';
var STOP_NOTIFICATION = 0;
