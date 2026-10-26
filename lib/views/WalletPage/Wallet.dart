// =============================================================================
// WHAT : Wallet screen: balance and history.
// NOTES: Server: available-balance, transaction-list.
// =============================================================================
import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../responsive.dart';
import 'components/TransactionDetailsWidget.dart';
import 'components/WalletCardWidget.dart';

// >>> START: WalletPage - screen/widget shell (the visible part is in its State class)
class WalletPage extends StatefulWidget {
  const WalletPage({Key? key, this.selectedType}) : super(key: key);

  @override
  final selectedType;
  State<WalletPage> createState() => _WalletPageState();
}
// <<< END: WalletPage - screen/widget shell (the visible part is in its State class)

// >>> START: _WalletPageState - the data and logic behind its screen
class _WalletPageState extends State<WalletPage> {
  var checkDetails;
  // >>> START: checkWalletApi - checks wallet api
  checkWalletApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var check =
        await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    if (check != null && check['status'] == 'OK') {
      if (mounted) {
        setState(() {
          checkDetails = check['detail'];
        });
      }
    }
  }
  // <<< END: checkWalletApi - checks wallet api

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    checkWalletApi();
    super.initState();
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: tappbarclr,
        title: Text(
          'wallet'.tr,
          style: GoogleFonts.mulish(
            color: tDarkNavyblue,
            fontSize: isTab(context) ? 10.sp : 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: checkDetails == null
          ? SpinKitThreeBounce(
              color: tPrimaryColor,
              size: 20.0,
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  WalletCardWidget(),
                  TransactionDetailsWidget(
                    selectedType: widget.selectedType,
                  )
                ],
              ),
            ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _WalletPageState - the data and logic behind its screen
