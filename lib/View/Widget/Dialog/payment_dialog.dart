// import 'package:get/get.dart';
// import 'package:backyard/Component/custom_image.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/app_router_name.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../../../../Component/custom_buttom.dart';
// import '../../../../../Component/custom_text.dart';

// class PaymentDialog extends StatelessWidget {
//   PaymentDialog({required this.onYes});
//   Function onYes;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeController>(
//         builder: (d) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           // height: responsive.setHeight(75),
//           width: 100.w,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: MyColors().secondaryColor,borderRadius: const BorderRadius.vertical(top: Radius.circular(20))
//                   ),
//                   padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 3.w),
//                   margin: EdgeInsets.symmetric(vertical: 1.w,horizontal: 1.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Icon(
//                         Icons.close_outlined,color: Colors.transparent,
//                       ),
//                       MyText(title: 'Payment',clr: MyColors().whiteColor,fontWeight: FontWeight.w600,),
//                       GestureDetector(
//                         onTap: (){AppNavigation.navigatorPop(context);},
//                         child: const Icon(
//                           Icons.close_outlined,color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 4.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: 2.h,),
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: MyColors().primaryColor2,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: EdgeInsets.all(4.w)+EdgeInsets.symmetric(vertical: .5.h),
//                         child: Column(
//                           children: [
//                           MyText(title: '\$ ${d.currentSession.value.cost}',clr: MyColors().whiteColor,size: 22,center: true,),
//                           SizedBox(height: .5.h,),
//                           MyText(title: 'Bill to pay',clr: MyColors().whiteColor,size: 16,center: true,),
//                         ],),
//                       ),
//                       SizedBox(height: 2.h,),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: MyColors().secondaryColor.withOpacity(.3),
//                             borderRadius: BorderRadius.circular(100),
//                             border: Border.all(color: MyColors().secondaryColor,)
//                         ),
//                         padding: EdgeInsets.all(2.w),
//                         child:  Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             CustomImage(url:  d.currentSession.value.trainer?.userImage??'', isProfile: true, photoView: false,height: 6.h,width: 6.h,radius: 200,fit: BoxFit.fill,),
//                             SizedBox(width: 3.w,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   MyText(title: d.currentSession.value.trainer?.fullName??'',size: 13,fontWeight: FontWeight.w600,),
//                                   Row(
//                                     children: [
//                                       Image.asset(ImagePath.star,scale: 2,),
//                                       MyText(title: ' ${d.currentSession.value.trainer?.avgRating}',size: 13,fontWeight: FontWeight.w600,),
//                                       // MyText(title: ' (${d.currentSession.value.trainer?.totalReviews})',size: 13,fontStyle: FontStyle.italic),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 3.w,),
//                             MyText(title: 'Trainer',size: 12,fontWeight: FontWeight.w600,),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 2.h,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                         MyText(title: 'Date:',fontWeight: FontWeight.w600,size: 12,),
//                         MyText(title:  d.currentSession.value.pickDate,clr: MyColors().grey,size: 12,),
//                       ],),
//                       SizedBox(height: 1.h,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                         MyText(title: 'Arrival Time:',fontWeight: FontWeight.w600,size: 12,),
//                         MyText(title: d.currentSession.value.pickTime,clr: MyColors().grey,size: 12,),
//                       ],),
//                       SizedBox(height: 1.h,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           MyText(title: 'Duration:',fontWeight: FontWeight.w600,size: 12,),
//                           MyText(title: '${d.currentSession.value.duration} Hours',clr: MyColors().grey,size: 12,),
//                         ],),
//                       SizedBox(height: 2.h,),
//                       MyButton(
//                         onTap: (){
//                           AppNavigation.navigatorPop(context);
//                           onYes();
//                           },
//                         title: "Continue",bgColor: MyColors().purpleColor,
//                       ),
//                       SizedBox(height: 2.h,),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }
