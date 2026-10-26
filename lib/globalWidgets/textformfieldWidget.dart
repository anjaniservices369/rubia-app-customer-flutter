// =============================================================================
// WHAT : Reusable text form field.
// NOTES: Visual component only.
// =============================================================================
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../constants/constants.dart';
import '../responsive.dart';

// >>> START: TextFormFieldWidgets - screen/widget
class TextFormFieldWidgets extends StatelessWidget {
  const TextFormFieldWidgets({
    Key? key,
    required this.controller,
    this.validator,
    this.hinttext,
    this.label,
    this.border,
    this.hintStyl,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixtxt,
    this.style,
    this.maxLines,
    this.fillcolor,
    this.inputFormater,
    this.keyboardTyp,
    this.contentPadding,
    this.onChanged,
  }) : super(key: key);

  final controller;
  final validator;
  final hinttext;
  final style;
  final border;
  final fillcolor;
  final hintStyl;
  final label;
  final prefixIcon;
  final suffixtxt;
  final suffixIcon;
  final maxLines;
  final inputFormater;
  final keyboardTyp;
  final contentPadding;
  final onChanged;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        validator: validator,
        maxLines: maxLines,
        cursorColor: tWhite,
        inputFormatters: inputFormater,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardTyp,
        style: TextStyle(
            fontSize: isTab(context) ? 9.sp : 12.sp,
            fontWeight: FontWeight.w600,
            color: tDarkNavyblue),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          label: label,
          suffixIcon: suffixIcon,
          suffixText: suffixtxt,
          hintStyle: TextStyle(
              fontSize: isTab(context) ? 8.sp : 12.sp,
              fontWeight: FontWeight.w400,
              color: tGray),
          hintText: hinttext,
          fillColor: tBackground,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: tBackground, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: tBackground, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: TextFormFieldWidgets - screen/widget