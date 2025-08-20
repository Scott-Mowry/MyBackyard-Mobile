// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:get/get.dart';
// import '../../Component/custom_text.dart';
// import 'custom_toast.dart';
//
// class Counter extends StatefulWidget {
//   Counter({Key? key,required this.addToCart}) : super(key: key);
//   bool? addToCart;
//   @override
//   State<Counter> createState() => _CounterState();
// }
//
// class _CounterState extends State<Counter> {
//   int q=1;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 28.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Theme
//             .of(context)
//             .primaryColor,
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (q > 1) {q--;}
//                 setState(() {});
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white,
//                 ),
//                 child: const Icon(Icons.remove_outlined),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 2.w),
//               child: MyText(
//                 title: '${q}',
//                 weight: "Semi Bold",),
//             ),
//             GestureDetector(
//               onTap: () {
//                 q++;
//                 setState(() {});
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white,
//                 ),
//                 child: const Icon(Icons.add),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
