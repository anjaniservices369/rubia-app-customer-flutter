// =============================================================================
// WHAT : Help and customer support screen.
// NOTES: Contact details.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/buttonIconWidget.dart';
import '../../../responsive.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';
// import 'components/customerSupport.dart';

// >>> START: Support - screen/widget shell (the visible part is in its State class)
class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}
// <<< END: Support - screen/widget shell (the visible part is in its State class)

// >>> START: _SupportState - the data and logic behind its screen
class _SupportState extends State<Support> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.forceNavigateTo(
            context,
            BottomNavigation(
              tabIndexId: 2,
            ));
      },
      child: Scaffold(
        backgroundColor: tBackground,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 7,
          automaticallyImplyLeading: false,
          backgroundColor: tYellow,
          title: Text(
            'support'.tr,
            style: TextStyle(
              color: tDarkNavyblue,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                Twl.forceNavigateTo(
                    context,
                    BottomNavigation(
                      tabIndexId: 2,
                    ));
              },
              child: Padding(
                padding: EdgeInsets.all(isTab(context) ? 10 : 12.0),
                child: BackIconWidget(),
              )),
        ),
        body: const CustomerSupport(),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SupportState - the data and logic behind its screen

// >>> START: CustomerSupport - screen/widget shell (the visible part is in its State class)
class CustomerSupport extends StatefulWidget {
  const CustomerSupport({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}
// <<< END: CustomerSupport - screen/widget shell (the visible part is in its State class)

// >>> START: _CustomerSupportState - the data and logic behind its screen
class _CustomerSupportState extends State<CustomerSupport> {
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tBackground,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: tWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [tBoxShadow],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: tPrimaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: tPrimaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'customer_support'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tDarkNavyblue,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => launchURL(CHAT_LINK),
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: Text(
                      'chat'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: tPrimaryColor,
                      side: BorderSide(color: tPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display

  // >>> START: launchURL - launch url
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {}
  }
  // <<< END: launchURL - launch url
}
// <<< END: _CustomerSupportState - the data and logic behind its screen
