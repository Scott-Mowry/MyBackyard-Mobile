// import 'package:backyard/Component/custom_switch.dart';
// import 'package:backyard/Component/custom_toast.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../../Component/custom_buttom.dart';
// import '../../../Component/custom_text.dart';
// import '../../../Component/custom_textfield.dart';
// import '../../../Utils/responsive.dart';
// import 'package:month_year_picker/month_year_picker.dart';
//
// class CardAlert extends StatelessWidget {
//   Responsive responsive = Responsive();
//   TextEditingController name = TextEditingController();
//   TextEditingController cardNumber = TextEditingController();
//   TextEditingController expiry = TextEditingController();
//   TextEditingController cvc = TextEditingController();
//   RxBool? switchValue=true.obs;
//
//   CardAlert({super.key});
//   @override
//   Widget build(BuildContext context) {
//     responsive.setContext(context);
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       // height: responsive.setHeight(75),
//       width: responsive.setWidth(100),
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
//                       child: MyText(title: "ENTER CARD DETAILS",clr:Theme.of(context).primaryColor,center: true,weight: "Semi Bold",),)),
//                     trailing:GestureDetector(
//                         onTap: (){Get.back();},
//                         child: Icon(Icons.cancel,color:Theme.of(context).primaryColorDark,))
//                 )
//             ),
//
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: responsive.setWidth(8)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Divider(),
//                   SizedBox(height: 2.h,),
//                   MyTextField(
//                     maxLength: 40,
//                     borderColor: Theme.of(context).hintColor.withOpacity(.1),
//                     width: 90.w,
//                     hintText: "Name",
//                     controller: name,
//                   ),
//                   SizedBox(height: 1.h,),
//                   Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: MyTextField(
//                         borderColor: Theme.of(context).hintColor.withOpacity(.1),
//                         hintText: 'Enter card number',
//                         cardFormat:true,
//                         maxLength: 19,
//                         height: 60,
//                         inputType: TextInputType.number,
//                         controller: cardNumber,
//                       )),
//
//                   Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//
//                       child: Row(
//                         children: [
//                           Flexible(
//                             child: MyTextField(
//                               hintText: 'Expiry',
//                               borderColor: Theme.of(context).hintColor.withOpacity(.1),
//                               cardExpiration:true,
//                               maxLength: 5,
//                               inputType: TextInputType.number,
//                               controller: expiry,
//                               readOnly: true,
//                               onTap: (){
//                                 monthPick(context);
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 3.w,),
//                           Flexible(
//                             child: MyTextField(
//                               borderColor: Theme.of(context).hintColor.withOpacity(.1),
//                               hintText: 'CVC',
//                               inputType: TextInputType.number,
//                               maxLength: 3,
//                               controller: cvc,
//                             ),
//                           )
//                         ],)),
//                   // SizedBox(height: 1.h,),
//                   // Container(decoration: BoxDecoration(
//                   //   color: const Color(0xffEAEAEA),
//                   //   borderRadius: BorderRadius.circular(10),
//                   // ),
//                   //
//                   // child: Padding(
//                   //   padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.w),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       const MyText(title: "SET AS DEFAULT",clr:  Color(0xff282828),weight: "Semi Bold",size: 14,),
//                   //       CustomSwitch(
//                   //         switchValue: switchValue,
//                   //         toggleColor: Colors.green,
//                   //       )
//                   //
//                   //     ],
//                   //   ),
//                   // ),
//                   // ),
//                   SizedBox(
//                     height: responsive.setHeight(3.5),
//                   ),
//                   MyButton(
//                       onTap: (){onSubmit(context);},
//                       title: "SAVE"
//                   ),
//                   SizedBox(
//                     height: responsive.setHeight(3.5),
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
//     HomeController.i.name=name.text;
//     HomeController.i.cardNumber=cardNumber.text;
//     HomeController.i.expiry=expiry.text;
//     HomeController.i.cvc=cvc.text;
//     HomeController.i.addCardValidation(context);
//   }
//   monthPick(context) async {
//     final selected = await showMonthYearPicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(3000),
//     );
//     print(selected);
//
//     if (selected != null) {
//       expiry.text=Utils.getFormattedMonthYear(
//           selected.toString().replaceFirst("T", " ").replaceFirst("Z", ""),
//           isutc: true);
//     }
//   }
// }
