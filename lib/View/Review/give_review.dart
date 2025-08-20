// import 'dart:developer';
// import 'dart:ui';
// import 'package:backyard/Component/custom_checkbox.dart';
// import 'package:backyard/Component/custom_image.dart';
// import 'package:backyard/Component/custom_padding.dart';
// import 'package:backyard/Component/custom_textfield.dart';
// import 'package:backyard/Component/custom_toast.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/app_router_name.dart';
// import 'package:backyard/View/Widget/Dialog/review_submitted.dart';
// import 'package:backyard/View/Widget/Dialog/service_complete.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:backyard/Arguments/screen_arguments.dart';
// import 'package:backyard/Component/custom_bottomsheet_indicator.dart';
// import 'package:backyard/Component/custom_buttom.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/View/base_view.dart';
// import '../../Component/custom_text.dart';
// import 'package:sizer/sizer.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// import '../../Utils/my_colors.dart';
// import '../../main.dart';
//
// class GiveReview extends StatelessWidget {
//   double rate = 0;
//   TextEditingController review = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BaseView(
//         showAppBar: true,
//         showBackButton: true,
//         bgImage: ImagePath.bgImage1,
//         screenTitle:'',
//       resizeBottomInset:false,
//         child: CustomPadding(
//           topPadding: 2.h,
//           horizontalPadding: 4.w,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: MediaQuery.of(context).viewInsets.bottom == 0?15.h:0.h,),
//                 MyText(title: 'Leave a Review',size: 22,),
//                 SizedBox(height: 2.h,),
//                 MyText(title: 'Please give your rating & also your review',size: 18,),
//                 SizedBox(height: 3.h,),
//                 RatingBar(
//                   initialRating: rate,
//                   direction: Axis.horizontal,
//                   allowHalfRating: false,
//                   itemCount: 5,
//                   glowColor: Colors.yellow,
//                   updateOnDrag:true,
//                   ratingWidget: RatingWidget(
//                     full: Image.asset(ImagePath.star,scale: 1,),
//                     half: Image.asset(ImagePath.starHalf,scale: 2,),
//                     empty:Image.asset(ImagePath.star,scale: 1,color: MyColors().whiteColor,),
//                   ),
//                   itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
//                   onRatingUpdate: (rating) {
//                     rate=rating;
//                   },
//                   itemSize:7.w,
//                 ),
//                 SizedBox(height: 2.h),
//                 MyTextField(
//                   height: 8.h,
//                   hintText: 'Type your Review',showLabel: false,
//                   maxLines: 5,minLines: 5,
//                   controller: review,
//                   borderColor: MyColors().whiteColor,
//                   backgroundColor: MyColors().whiteColor,
//                   textColor: MyColors().black,
//                   hintTextColor: MyColors().black,
//                   borderRadius: 10,maxLength: 1000,
//                 ),
//                 SizedBox(height: 2.h),
//                 Row(children: [
//                   Flexible(
//                     child: MyButton(
//                       onTap: (){
//                         AppNavigation.navigatorPop(context);
//                       },
//                       title: 'Cancel',
//                       bgColor: Colors.transparent,
//                       textColor: MyColors().whiteColor,
//                       gradient: false,
//                     ),
//                   ),
//                   SizedBox(width: 3.w,),
//                   Flexible(
//                     child: MyButton(
//                         onTap: (){
//                           onSubmit(context);
//                         },
//                         gradient: false,
//                         title: "Submit"
//                     ),
//                   ),
//                 ],),
//                 SizedBox(height: 2.h),
//               ],
//             ),
//           ),
//         )
//     );
//   }
//   onSubmit(context){
//     var h = HomeController.i;
//     h.rating=rate;
//     h.review=review.text;
//     h.giveReviewValidation(context,edit: false,onSuccess: (){ reviewSubmitted(context);});
//   }
//   reviewSubmitted(context){
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: AlertDialog(
//               backgroundColor: Colors.transparent,
//               contentPadding: const EdgeInsets.fromLTRB(
//                   0, 0, 0, 0),
//               content: ReviewSubmitted(),
//             ),
//           );
//         }
//     );
//   }
// }