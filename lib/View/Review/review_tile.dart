// import 'dart:developer';
// import 'dart:ui';
//
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:backyard/Component/custom_bottomsheet_indicator.dart';
// import 'package:backyard/Component/custom_buttom.dart';
// import 'package:backyard/Component/custom_empty_data.dart';
// import 'package:backyard/Component/custom_image.dart';
// import 'package:backyard/Component/custom_title_description.dart';
// import 'package:backyard/Controller/auth_controller.dart';
// import 'package:backyard/Controller/global_controller.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Model/category_product_model.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/app_router_name.dart';
// import 'package:backyard/Utils/app_size.dart';
// import 'package:backyard/Utils/app_strings.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:backyard/Utils/utils.dart';
// import 'package:backyard/View/Widget/Dialog/rating.dart';
// import 'package:backyard/View/Widget/counter.dart';
// import 'package:backyard/View/base_view.dart';
// import '../../../Component/custom_text.dart';
// import 'package:sizer/sizer.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// import '../../../Component/custom_toast.dart';
// import '../../../Utils/enum.dart';
//
// class ReviewTile extends StatelessWidget {
//   ReviewTile({super.key,required this.r});
//   Reviews r;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 2.h),
//         GestureDetector(
//           onTap: () async {
//             if(r.userId!.id!=AuthController.i.user.value.id){
//               await HomeController.i.getUserDetail(context: context,id: r.userId!.id);
//               AppNavigation.navigateTo( AppRouteName.USER_PROFILE_ROUTE);
//             }
//           },
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 2.h,
//                 backgroundColor: MyColors().pinkColor,
//                 child: CircleAvatar(
//                   radius: 1.8.h,
//                   backgroundColor: MyColors().whiteColor,
//                   child: CustomImage(
//                     height: 5.h,
//                     width: 5.h,
//                     isProfile: true,
//                     photoView: false,
//                     url: r.userId?.userImage,
//                     radius: 100,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 2.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment
//                       .start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     MyText(title: "${r.userId?.firstName} ${r.userId?.lastName}",fontWeight: FontWeight.w500,),
//                     Row(children: [
//                       Icon(Icons.star_rounded,
//                         color: MyColors().rateColor,
//                         size: 15,),
//                       SizedBox(width: .5.w),
//                       MyText(title: '${r.rating.toStringAsFixed(1)??0.0}',
//                         clr: MyColors().rateColor,
//                         size: 12,),
//                     ],),
//                   ],
//                 ),
//               ),
//               if(r.isMyReview==1)
//                 GestureDetector(
//                     onTap:(){
//                       deleteDialog(context,r: r);
//                     },
//                     child: Icon(Icons.more_vert_rounded)),
//             ],
//           ),
//         ),
//         Align(
//             alignment: Alignment.centerRight,
//             child: MyText(title: Utils.relativeTime(r.createdAt),
//               clr: MyColors().greyColor,
//               size: 12,)),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               color: MyColors().whiteColor,
//               child: Container(
//                 // width: 80.w,
//                 padding: EdgeInsets.all(2.5.w),
//                 child: MyText(
//                   title:r.review,),
//               )),
//         ),
//       ],
//     );
//   }
//   void deleteDialog(context,{required Reviews r}) {
//     showModalBottomSheet(
//         context: context,
//         // backgroundColor: MyColors().whiteColor,
//         builder: (BuildContext bc) {
//           return  Container(
//             padding: EdgeInsets.all(4.w),
//             decoration: BoxDecoration(
//                 color:  MyColors().whiteColor,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.BOTTOMSHEETRADIUS))
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 BottomSheetIndicator(),
//                 SizedBox(height: 1.5.h,),
//                 GestureDetector(
//                   onTap: (){
//                     AppNavigation.navigatorPop(context);
//                     giveReview(edit: true,r: r,context: context);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.asset(ImagePath.editReview,scale: 5,color: MyColors().pinkColor,),
//                       SizedBox(width: 3.w,),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           MyText(title: 'Edit Review',size: 13,fontWeight: FontWeight.w700,),
//                           MyText(title: 'Want to edit your review...…!',clr: MyColors().greyColor,size: 11,),
//                         ],)
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 1.h,),
//                 GestureDetector(
//                   onTap: (){
//                     AppNavigation.navigatorPop(context);
//                     HomeController.i.deleteReview(context,onSuccess: (){},r: r);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.asset(ImagePath.delete,scale: 5,color: MyColors().pinkColor),
//                       SizedBox(width: 3.w,),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           MyText(title: 'Delete Review',size: 13,fontWeight: FontWeight.w700,),
//                           MyText(title: 'Want to delete your review...!',clr: MyColors().greyColor,size: 11,),
//                         ],)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   }
//   giveReview({bool? edit,Reviews? r,required BuildContext context}){
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
//               content: RatingAlert(id:'1',index: 2,refreshData: (){},productId: '',edit: edit,r: r??Reviews(),isProduct:true),
//             ),
//           );
//         }
//     );
//   }
//
// }
