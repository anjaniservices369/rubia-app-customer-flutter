// =============================================================================
// WHAT : The main app button, with a built-in loading spinner.
// NOTES: Screens call startLoading/stopLoading around a server request.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_icon_button/loading_icon_button.dart';
// import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:sizer/sizer.dart';

import '../responsive.dart';

// >>> START: ButtonWidget - screen/widget
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    this.color,
    this.bottonText,
    this.onTap,
    this.borderSide,
    this.textcolor,
    this.child,
    this.borderRadius,
  }) : super(key: key);
  final color;
  final String? bottonText;
  final onTap;
  final child;
  final borderRadius;
  final borderSide;
  final textcolor;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ArgonButton(
        height: isTab(context) ? 70 : 50,
        width: 100.w,
        color: color,
        borderRadius: borderRadius,
        borderSide: borderSide,
        child: child,
        onTap: onTap,
        //  Text(
        //   bottonText!,

        //   style: TextStyle(
        //      letterSpacing: 1,
        loader: Container(
          padding: EdgeInsets.all(10),
          child: SpinKitRotatingCircle(
            color: Colors.white,
            // size: loaderWidth ,
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: ButtonWidget - screen/widget




// import '../responsive.dart';

// class Button extends StatelessWidget {
//   const Button({
//     Key? key,

//   @override
//       borderSide: borderSide,
//       child: child,
//       loader: Container(
//         padding: EdgeInsets.all(10),
//         child: SpinKitRotatingCircle(
//           color: Colors.white,
//           // size: loaderWidth ,
//         ),