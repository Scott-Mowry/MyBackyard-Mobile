// import 'package:backyard/Utils/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'custom_text.dart';
//
// class ToggleTile extends StatelessWidget {
//   ToggleTile({Key? key, this.text, this.isSelected}) : super(key: key);
//   String? text;
//   bool? isSelected;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 6.5.h,
//         padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.w),
//         decoration: BoxDecoration(
//           color:  MyColors().greenColor,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         // alignment: Alignment.center,
//         child: Container(
//           // height: 6.h,
//           padding: EdgeInsets.symmetric(horizontal: 0.w),
//           decoration: BoxDecoration(
//             color: isSelected==true?Theme.of(context).primaryColorDark:Colors.transparent,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           alignment: Alignment.center,
//           child: MyText(title: text!, clr: Colors.black),
//         ));
//   }
// }
//
// class CustomToggleBar extends StatelessWidget {
//   CustomToggleBar({Key? key,required this.items,required this.onChange}) : super(key: key);
//   List<String> items;
//   String selected="";
//   Function(String) onChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 10.h,
//       width: 100.w,
//       decoration: BoxDecoration(
//           color: MyColors().greyColor,
//           borderRadius: BorderRadius.circular(30)
//       ),
//       child: ListView.builder(
//         itemCount: items.length,
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.zero,
//         itemBuilder: (buildContext, int index) {
//           return GestureDetector(
//             onTap: () {
//                   onChange(items[index]);
//                   selected=items[index];
//                 },
//             child: ToggleTile(
//                   text: items[index],
//                   isSelected:selected==items[index] ? true : false,
//                 ),
//           );
//         },
//       ),
//     );
//   }
// }
