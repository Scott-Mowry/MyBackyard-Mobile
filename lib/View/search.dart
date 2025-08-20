// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// import 'package:get/get.dart';
// import 'package:backyard/Component/custom_elevated_button.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Controller/profile_controller.dart';
// import 'package:backyard/Controller/theme_controller.dart';
// import 'package:backyard/View/notification.dart';
// import 'package:backyard/View/widget/image_preview.dart';
// import 'package:backyard/View/widget/job_categories_card.dart';
// import 'package:backyard/View/widget/jobs.dart';
// import 'package:backyard/View/widget/jobs_categories_list.dart';
// import 'package:backyard/View/widget/upload_media.dart';
// import 'package:backyard/constant/strings.dart';
// import '../../Component/custom_buttom.dart';
// import '../../Component/custom_text.dart';
// import '../../Component/custom_textfield.dart';
// import '../../Utils/my_colors.dart';
// import '../../Utils/image_path.dart';
// import '../../Utils/responsive.dart';
// import 'base_view.dart';
//
// class Search extends StatelessWidget {
//   Responsive responsive = Responsive();
//   MyColors colors = MyColors();
//   ProfileController controller = Get.put(ProfileController());
//   HomeController homeController = Get.put(HomeController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     responsive.setContext(context);
//     return Obx(()=> BaseView(
//       showAppBar: true,
//       showBackButton:true,
//       screenTitle: Strings.SEARCH_JOBS,
//       trailing: false,
//       showBottomBar: true,
//       onTapTrailing: (){
//         print("TRappped");
//         //Get.to(Notifications(),transition: Transition.leftToRight, duration: const Duration(milliseconds: 300),); Get.to(Notifications());
//       },
//       child: Padding(
//         padding:  EdgeInsets.only(top: responsive.setHeight(0),left: responsive.setWidth(4),right: responsive.setWidth(4)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MyTextField(
//                   controller: controller.email.value,
//                   width: responsive.setWidth(70),
//                   suffixIconData : Icons.search,
//                   prefixIconColor: colors.primaryColor,
//                   hintText: Strings.SEARCH,
//                   backgroundColor: Theme.of(context).cardColor,
//                   borderColor:  Theme.of(context).cardColor,
//                   focusNode: controller.f2.value,
//                   onFieldSubmit: (val) {
//                     controller.f2.value.unfocus();
//                     FocusScope.of(context).requestFocus(controller.f3.value);
//                   },
//                 ),
//                 GestureDetector(
//                   onTap: (){
//                     homeController.noResult.value=! homeController.noResult.value;
//                   },
//                   child: Container(
//                       height: responsive.setHeight(5.5),
//                       width: responsive.setWidth(12),
//                       decoration: BoxDecoration(
//                         color:  Theme.of(context).primaryColorDark.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       // alignment: Alignment.center,
//                       // margin: EdgeInsets.symmetric(horizontal: responsive.setWidth(3),vertical: responsive.setHeight(1.2)),
//                       // padding: EdgeInsets.symmetric(horizontal: responsive.setWidth(3),vertical: responsive.setHeight(1.2)),
//                       child: Icon(Icons.filter_list,color:Theme.of(context).primaryColorDark,size: responsive.setWidth(7),)),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: responsive.setWidth(0),top: responsive.setHeight(2)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   MyText(
//                     title: Strings.RESULTS,
//                     clr: Theme.of(context).indicatorColor,
//                     weight: 'Bold',
//                     size: 18,
//                   ), MyText(
//                     title: '2 '+Strings.FOUNDS,
//                     clr:  Theme.of(context).primaryColorDark,
//                     weight: 'Bold',
//                     size: 16,
//                   ),
//
//                 ],
//               ),
//             ),            SizedBox(height: responsive.setHeight(2)),
//             Expanded(
//               child:
//               homeController.noResult.isTrue?Image.asset(ImagePath.notFound):
//               ListView.builder(
//                   physics: BouncingScrollPhysics(),
//                   itemCount: 10,
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext, int index) {
//                     return Jobs(index: index,);
//                   }),
//             ),
//
//           ],
//         ),
//
//       ),
//     ),
//     );
//   }
// }
