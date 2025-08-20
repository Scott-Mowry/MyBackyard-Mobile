// import 'package:backyard/Component/custom_switch.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../../Component/custom_buttom.dart';
// import '../../../Component/custom_text.dart';
// import '../../../Component/custom_textfield.dart';
//
// class DeleteCard extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       // height: responsive.setHeight(75),
//       width: 100.w,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//                 decoration: const BoxDecoration(
//                   // color: Theme.of(context).primaryColorDark,
//                     borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20)
//                     )),
//
//                 child: ListTile(
//                     title: Center(child: Align(
//                       alignment: const Alignment(.5, 0),
//                       child: MyText(title: "DELETE CARD",clr:Theme.of(context).primaryColor,center: true,weight: "Semi Bold",),)),
//                     trailing:GestureDetector(
//                         onTap: (){Get.back();},
//                         child: Icon(Icons.cancel,color:Theme.of(context).primaryColorDark,))
//                 )
//             ),
//
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Divider(),
//                   SizedBox(height: 2.h,),
//                   MyText(title: "Are you sure you want to delete this card?",clr: MyColors().black,),
//                   SizedBox(height: 1.h,),
//                   SizedBox(
//                     height: 3.5.h,
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: MyButton(
//                             onTap: (){onSubmit(context);},
//                             title: "NO"
//                         ),
//                       ),
//                       SizedBox(
//                         width: 3.5.w,
//                       ),  Flexible(
//                         child: MyButton(
//                             onTap: (){onSubmit(context);},
//                             title: "YES"
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 3.5.h,
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//   onSubmit(context){
//     HomeController.i.addCardValidation(context);
//   }
// }
