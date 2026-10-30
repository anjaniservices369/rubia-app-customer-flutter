import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ride OTP becomes visible only after driver arrival', () {
    for (final status in [
      STATUS_WAITING_FOR_DRIVER,
      STATUS_DRIVER_ACCEPTED,
      STATUS_START_RIDE,
      STATUS_RIDE_COMPLETED,
      STATUS_USER_CANCELLED,
      STATUS_BOOKING_AUTO_CANCELLED,
      STATUS_DRIVER_CANCELLED,
      STATUS_CANCELLED,
    ]) {
      expect(hasDriverArrivedForPickup(status: status, notificationStatus: 0), isFalse);
      expect(hasDriverArrivedForPickup(status: status, notificationStatus: 1), isFalse);
    }
    expect(hasDriverArrivedForPickup(status: STATUS_GO_FOR_PICKUP, notificationStatus: 0), isFalse);
    expect(hasDriverArrivedForPickup(status: STATUS_GO_FOR_PICKUP, notificationStatus: 1), isTrue);
    expect(hasDriverArrivedForPickup(status: STATUS_ARRIVED_LOCATION, notificationStatus: 0), isTrue);
    expect(hasDriverArrivedForPickup(status: STATUS_ARRIVED_LOCATION, notificationStatus: 1), isTrue);
  });
}
