// =============================================================================
// WHAT : INACTIVE: whole file is commented out.
// NOTES: Safe to delete.
// =============================================================================
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
// import 'package:base_project_flutter/globalWidgets/button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// import '../../../api_services/vendorApi.dart';
// import '../../../constants/constants.dart';
// import '../../../constants/imageConstant.dart';
// import '../../../globalFuctions/globalFunctions.dart';
// import '../../../responsive.dart';
// import 'package:path_provider/path_provider.dart';

// class ViewBillBottomSheet extends StatefulWidget {
//   const ViewBillBottomSheet({Key? key, this.ordersList, this.orderDetails})
//       : super(key: key);
//   final ordersList;
//   final orderDetails;

//   @override
//   State<ViewBillBottomSheet> createState() => _ViewBillBottomSheetState();
// }

// class _ViewBillBottomSheetState extends State<ViewBillBottomSheet> {
//   var orderDetails;
//   var acceptedOrders;
//   String _message = "";
//   String _path = "";

//   @override
//   void initState() {
//     getOrderDetails();
//     super.initState();
//   }

//   var resNok;
//   getOrderDetails() async {
//     var res = await VendorApi()
//         .getOrderDetails(context, widget.ordersList.id.toString());
//     debugPrint('res:$res');
//     if (res['status'] == 'OK') {
//       setState(() {
//         orderDetails = res['details'];
//       });
//     } else {
//       setState(() {
//         resNok = res['status'];
//       });
//     }
//   }

//   Future<void> _downloadImage(String url,
//       {AndroidDestinationType? destination,
//       bool whenError = false,
//       String? outputMimeType,
//       name}) async {
//     String? imageId;
//     print("imageurl>>>>>>>>>>>>>");
//     print(url);
// // var time ;
// // setState(() {
// //   time =DateTime.now().toUtc().toIso8601String();
// // });
// // print(time);
//     if (whenError) {
//       imageId = await ImageDownloader.downloadImage(url,
//               outputMimeType: outputMimeType)
//           .catchError((error) {
//         if (error is PlatformException) {
//           String? path = "";
//           if (error.code == "404") {
//             print("Not Found Error.");
//           } else if (error.code == "unsupported_file") {
//             print("UnSupported FIle Error.");
//             path = error.details["unsupported_file_path"];
//           }
//           setState(() {
//             _message = error.toString();
//             _path = path ?? '';
//           });
//         }

//         print(error);
//       }).timeout(Duration(seconds: 10), onTimeout: () {
//         print("timeout");
//         return;
//       });
//     } else {
//       if (destination == null) {
//         imageId = await ImageDownloader.downloadImage(url,
//             outputMimeType: outputMimeType,
//             destination: AndroidDestinationType.directoryPictures
//               ..subDirectory("mason" + name + ".jpg"));
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Download Successful'),
//         ));

//         print(imageId);
//       } else {
//         imageId = await ImageDownloader.downloadImage(
//           url,
//           destination: destination,
//           outputMimeType: outputMimeType,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: tWhite,
//           content: Text('Download Successful'),
//         ));
//       }
//     }
//   }

//   var firstname;
//   certificateName() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     print(firstname);
//     firstname = sharedPreferences.getString('firstName');
//   }

//   ScreenshotController screenshotController = ScreenshotController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: tWhite,
//         body: orderDetails == null
//             ? resNok != 'NOK'
//                 ? Align(
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator())
//                 : Align(
//                     alignment: Alignment.center, child: Text('No Data Found'))
//             : Container(
//                 child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: Column(children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       // Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           Twl.navigateBack(context);
//                         },
//                         child: Text('close',
//                             style: TextStyle(
//                               fontSize: isTab(context) ? 12.sp : 12.sp,
//                               color: tPrimaryColor,
//                               fontWeight: FontWeight.w500,
//                             )),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       ArgonButton(
//                         height: 40,
//                         width: 40.w,
//                         color: tWhite,
//                         borderRadius: 10,
//                         elevation: 0,
//                         // borderSide: borderSide,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(4),
//                             border: Border.all(color: tPrimaryColor),
//                           ),
//                           child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 30, vertical: 7),
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     Images.DOWNLOAD,
//                                     scale: 4,
//                                   ),
//                                   SizedBox(
//                                     width: 2.w,
//                                   ),
//                                   Text('Download',
//                                       style: TextStyle(
//                                         fontSize:
//                                             isTab(context) ? 12.sp : 10.sp,
//                                         color: tPrimaryColor,
//                                         fontWeight: FontWeight.w500,
//                                       )),
//                                 ],
//                               )),
//                         ),
//                         loader: Container(
//                           padding: EdgeInsets.all(10),
//                           child: SpinKitRotatingCircle(
//                             color: tPrimaryColor,
//                             // size: loaderWidth ,
//                           ),
//                         ),
//                         onTap: (startLoading, stopLoading, btnState) async {
//                           startLoading();

//                           screenshotController
//                               .capture()
//                               .then((capturedImage) async {
//                             startLoading();
//                             print('capturedImage');
//                             print(capturedImage);
//                             print('capturedImage');
//                             final directory =
//                                 (await getApplicationDocumentsDirectory())
//                                     .path; // to get path of the file
//                             String fileName = DateTime.now()
//                                 .toIso8601String(); // the name needs to be unique every time you take a screenshot
//                             var path = '$directory/$fileName.png';
//                             print('path');
//                             print(path);
//                             File image =
//                                 await File(path).writeAsBytes(capturedImage!);
//                             print(image);
//                             // File _file =await File(path).create();
//                             Reference ref = storage.ref().child(
//                                 image.toString() + DateTime.now().toString());

//                             UploadTask uploadTask = ref.putFile(image);
//                             print(uploadTask);
//                             setState(() {
//                               stopLoading();
//                             });

//                             uploadTask.then((res) async {
//                               var url = await res.ref.getDownloadURL();

//                               print('URL' + url);
//                               print('loading ended');
//                               _downloadImage(url, name: firstname);
//                               _downloadImage(
//                                 url,
//                                 destination: AndroidDestinationType
//                                     .directoryPictures
//                                   ..inExternalFilesDir()
//                                   ..subDirectory(firstname.toString() + ".png"),
//                               );
//                               setState(() {
//                                 stopLoading();
//                               });
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text(
//                                   'Bill Downloaded',
//                                 ),
//                               ));
//                             });
//                             startLoading();
//                           });
//                           stopLoading();
//                         },
//                       ),
//                     ],
//                   ),
//                   Screenshot(
//                     controller: screenshotController,
//                     child: Container(
//                       color: tWhite,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text('Invoice :',
//                                   style: TextStyle(
//                                     fontSize: isTab(context) ? 10.sp : 12.sp,
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                               Text('2245667',
//                                   style: TextStyle(
//                                     fontSize: isTab(context) ? 10.sp : 12.sp,
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                               Spacer(),
//                               // GestureDetector(
//                               //   onTap: () {},
//                               //   child: Container(
//                               //     decoration: BoxDecoration(
//                               //       borderRadius: BorderRadius.circular(4),
//                               //       border: Border.all(color: tPrimaryColor),
//                               //     ),
//                               //     child: Padding(
//                               //         padding:
//                               //             EdgeInsets.symmetric(horizontal: 30, vertical: 7),
//                               //         child: Row(
//                               //           children: [
//                               //             Image.asset(
//                               //               Images.DOWNLOAD,
//                               //               scale: 4,
//                               //             ),
//                               //             SizedBox(
//                               //               width: 2.w,
//                               //             ),
//                               //             Text('Download',
//                               //                 style: TextStyle(
//                               //                   fontSize: isTab(context) ? 12.sp : 10.sp,
//                               //                   color: tPrimaryColor,
//                               //                   fontWeight: FontWeight.w500,
//                               //                 )),
//                               //           ],
//                               //         )),
//                               //   ),
//                               // )
//                               //  Container(
//                               //     decoration: BoxDecoration(
//                               //       borderRadius: BorderRadius.circular(4),
//                               //       border: Border.all(color: tPrimaryColor),
//                               //     ),
//                               //     child: Padding(
//                               //         padding:
//                               //             EdgeInsets.symmetric(horizontal: 30, vertical: 7),
//                               //         child: Row(
//                               //           children: [
//                               //             Image.asset(
//                               //               Images.DOWNLOAD,
//                               //               scale: 4,
//                               //             ),
//                               //             SizedBox(
//                               //               width: 2.w,
//                               //             ),
//                               //             Text('Download',
//                               //                 style: TextStyle(
//                               //                   fontSize: isTab(context) ? 12.sp : 10.sp,
//                               //                   color: tPrimaryColor,
//                               //                   fontWeight: FontWeight.w500,
//                               //                 )),
//                               //           ],
//                               //         )),
//                               //  ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text('Order Id :',
//                                   style: TextStyle(
//                                     fontSize: isTab(context) ? 10.sp : 12.sp,
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                               Text(orderDetails['id'].toString(),
//                                   style: TextStyle(
//                                     fontSize: isTab(context) ? 10.sp : 12.sp,
//                                     color: tBlack,
//                                     fontWeight: FontWeight.w600,
//                                   )),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 3.h,
//                           ),
//                           Text('Customer Details',
//                               style: TextStyle(
//                                 fontSize: isTab(context) ? 10.sp : 12.sp,
//                                 color: tGray,
//                                 fontWeight: FontWeight.w600,
//                               )),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: [tBoxShadows],
//                                 color: tWhite),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 15),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(orderDetails['user_id']['username'],
//                                       style: TextStyle(
//                                         fontSize:
//                                             isTab(context) ? 10.sp : 12.sp,
//                                         color: tBlack,
//                                         fontWeight: FontWeight.w600,
//                                       )),
//                                   SizedBox(
//                                     height: 1.h,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         Images.HOMEICON,
//                                         scale: 4,
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         orderDetails['delivery_r_id']
//                                             ['address_type'],
//                                         style: TextStyle(
//                                             fontSize:
//                                                 isTab(context) ? 12.sp : 10.sp,
//                                             color: tGray,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 1.h,
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         orderDetails['delivery_r_id']
//                                             ['location'],
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           color: tGray,
//                                           fontSize:
//                                               isTab(context) ? 10.sp : 10.sp,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 1.h,
//                                       ),
//                                       Text(
//                                         orderDetails['delivery_r_id']
//                                             ['address'],
//                                         style: TextStyle(
//                                           color: tGray,
//                                           fontSize:
//                                               isTab(context) ? 10.sp : 10.sp,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 1.h,
//                           ),
//                           Text('Order Details',
//                               style: TextStyle(
//                                 fontSize: isTab(context) ? 10.sp : 12.sp,
//                                 color: tGray,
//                                 fontWeight: FontWeight.w600,
//                               )),
//                           Card(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(6)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: 14.h,
//                                       child: ListView.builder(
//                                           physics: ScrollPhysics(),
//                                           itemCount:
//                                               orderDetails['order_details']
//                                                   .length,
//                                           itemBuilder: (BuildContext context,
//                                               int index) {
//                                             var productDetails =
//                                                 orderDetails['order_details']
//                                                     [index];
//                                             return Row(
//                                               children: [
//                                                 Text(
//                                                     productDetails['qty']
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         fontSize: isTab(context)
//                                                             ? 9.sp
//                                                             : 16.sp,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: tBlack)),
//                                                 SizedBox(
//                                                   width: 3.w,
//                                                 ),
//                                                 Image.network(
//                                                   productDetails['product']
//                                                       ['image'],
//                                                   scale: 6,
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(
//                                                     productDetails['product']
//                                                         ['name'],
//                                                     style: TextStyle(
//                                                         fontSize: isTab(context)
//                                                             ? 9.sp
//                                                             : 12.sp,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         color: tBlack)),
//                                                 Spacer(),
//                                                 Text(
//                                                   "x" +
//                                                       productDetails['product'][
//                                                                   'product_variation']
//                                                               [
//                                                               index]['quantity']
//                                                           .toString(),
//                                                   style: TextStyle(
//                                                       fontSize: isTab(context)
//                                                           ? 7.sp
//                                                           : 10.sp,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: tGray),
//                                                 ),
//                                                 Spacer(),
//                                                 Text(
//                                                   '100',
//                                                   style: TextStyle(
//                                                       fontSize: isTab(context)
//                                                           ? 7.sp
//                                                           : 10.sp,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: tBlack),
//                                                 ),
//                                               ],
//                                             );
//                                           }),
//                                     ),
//                                     Divider(),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           '4 Items',
//                                           style: TextStyle(
//                                               fontSize:
//                                                   isTab(context) ? 7.sp : 14.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: tBlack),
//                                         ),
//                                         Spacer(),
//                                         Text(
//                                           currencySymbol +
//                                               orderDetails['sub_total']
//                                                   .toString(),
//                                           style: TextStyle(
//                                               fontSize:
//                                                   isTab(context) ? 7.sp : 14.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: tBlack),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 'Paid:',
//                                 style: TextStyle(
//                                     fontSize: isTab(context) ? 7.sp : 12.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: tBlack),
//                               ),
//                               Text(
//                                 orderDetails['payment_type'],
//                                 style: TextStyle(
//                                     fontSize: isTab(context) ? 7.sp : 12.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: tBlack),
//                               ),
//                               Spacer(),
//                               Text(
//                                 orderDetails['created_on'],
//                                 style: TextStyle(
//                                     fontSize: isTab(context) ? 7.sp : 12.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: tBlack),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     color: tWhite,
//                   ),
//                 ]),
//               )));
//   }
// }

// class Button1 extends StatelessWidget {
//   const Button1({
//     Key? key,
//     this.color,
//     this.bottonText,
//     this.onTap,
//     this.borderSide,
//     this.textcolor,
//     this.loader,
//   }) : super(key: key);
//   final color;
//   final String? bottonText;
//   final onTap;
//   final borderSide;
//   final textcolor;
//   final loader;

//   @override
//   Widget build(BuildContext context) {
//     return ArgonButton(
//       height: 25,
//       width: 65,
//       // height: isTab(context) ? 70 : 50,
//       // width: 100.w,
//       // border: Border.all(width: 1, color: tPrimaryColor),
//       // borderRadius: BorderRadius.circular(6)),
//       color: color,
//       borderRadius: 6,
//       borderSide: borderSide,
//       elevation: 0,
//       child: Text(
//         bottonText!,
//         style: TextStyle(color: textcolor!),
//       ),
//       loader: loader,

//       onTap: onTap,
//     );
//   }
// }
