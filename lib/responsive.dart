// =============================================================================
// WHAT : Three tiny helpers that say whether the screen is a phone, tablet or
//        desktop.
// NOTES: Used all over the screens to pick bigger or smaller sizes.
// =============================================================================
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;
bool isTab(BuildContext context) =>
    MediaQuery.of(context).size.width < 1300 &&
    MediaQuery.of(context).size.width >= 600;
bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1300;
