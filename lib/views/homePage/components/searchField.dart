// =============================================================================
// WHAT : Search box on the home screen.
// NOTES: Visual component.
// =============================================================================
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/views/homePage/components/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
// import '../searchPage.dart';

// >>> START: SearchField - screen/widget shell (the visible part is in its State class)
class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}
// <<< END: SearchField - screen/widget shell (the visible part is in its State class)

// >>> START: _SearchFieldState - the data and logic behind its screen
class _SearchFieldState extends State<SearchField> {
  bool search =true;
  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Twl.forceNavigateTo(context,SearchPage(boolSearch: search));
      },
      child: TextFormField(
        onTap:  (){
      Twl.forceNavigateTo(context,SearchPage(boolSearch: true));
      },
        validator: (value) {
          if (value!.isEmpty) {
            return 'keyword number cant be empty';
          } else {
            return null;
          }
        },
        readOnly: true,
        // controller: _userNameController,
        //_phoneNumberController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
        // onChanged: _onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: isTab(context) ? 20 : 10, horizontal: 10),
          prefixIcon: Image.asset(
                      Images.SEARCHICON,
                      scale: 4,
                    ),
          fillColor: tFieldColor,
          focusColor: tBlack,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(6),
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.5),
              borderRadius: BorderRadius.circular(6)),
          hintText: 'Search',
          hintStyle: TextStyle(
              color: tBlack,
              fontSize: isTab(context) ? 8.sp : 12.sp,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _SearchFieldState - the data and logic behind its screen
