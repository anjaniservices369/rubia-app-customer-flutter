// =============================================================================
// WHAT : The driver's round photo, with the default avatar when there is no photo or the photo cannot be loaded.
// NOTES: A driver must have a profile photo to accept rides (server rule), so in normal use the real photo shows. The default avatar
//        only covers a photo link that does not load (no signal, a deleted file), so the card never shows an empty ring.
// =============================================================================
import 'package:flutter/material.dart';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';

// >>> START: DriverAvatar - the driver's round photo with a default-avatar fallback
class DriverAvatar extends StatelessWidget {
  const DriverAvatar({Key? key, required this.imageUrl, this.radius = 25}) : super(key: key);
  final String? imageUrl;
  final double radius;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    final url = (imageUrl ?? '').trim();
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tDarkNavyblue, width: 2)),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: tWhite,
        // the default avatar is underneath; the real photo is drawn over it and, when it fails to load, the default stays visible
        backgroundImage: const AssetImage(Images.PROFILE_IMAGE),
        foregroundImage: url.isEmpty ? null : NetworkImage(url),
        onForegroundImageError: url.isEmpty ? null : (_, __) {},
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: DriverAvatar - the driver's round photo with a default-avatar fallback
