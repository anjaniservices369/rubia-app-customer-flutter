// =============================================================================
// WHAT : Plain orange button.
// NOTES: Visual component only.
// =============================================================================
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../responsive.dart';

// >>> START: Button - screen/widget
class Button extends StatelessWidget {
  const Button({
    Key? key, this.color, this.bottonText, this.onTap, this.borderSide, this.textcolor,
  }) : super(key: key);
  final color;
  final String? bottonText;
  final onTap;
  final borderSide;
  final textcolor;

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return ArgonButton(
      height:isTab(context)?70 :  50, 
      width: 100.w, 
      color: color,
      borderRadius:10,
      borderSide: borderSide,
      child: Text(bottonText!,style: TextStyle(color: textcolor,fontWeight: FontWeight.w600,fontSize: isTab(context)?10.sp : 14.sp),),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitRotatingCircle(
          color: Colors.white,
          // size: loaderWidth ,
        ),
      ),
      onTap:onTap,
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: Button - screen/widget