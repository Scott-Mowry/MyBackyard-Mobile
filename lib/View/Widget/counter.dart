// import 'package:flutter/material.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:sizer/sizer.dart';
// import 'package:get/get.dart';
// import '../../Component/custom_text.dart';
//
// class Counter extends StatefulWidget {
//   Counter({Key? key,required this.addToCart,required this.onTapRemove,required this.onTapAdd,this.onTapDelete,this.q=1}) : super(key: key);
//   bool? addToCart;
//   int q=1;
//   final Function(int) onTapRemove;
//   final Function()? onTapDelete;
//   final Function(int) onTapAdd;
//
//   @override
//   State<Counter> createState() => _CounterState();
// }
//
// class _CounterState extends State<Counter> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 28.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: MyColors().pinkColor
//       ),
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (widget.q == 1) {if(widget.onTapDelete!=null){widget.onTapDelete!();}}
//                 else if (widget.q > 1) {widget.q--; widget.onTapRemove(widget.q);}
//                 setState(() {});
//               },
//               child: (widget.q == 1 && widget.addToCart==true)? Image.asset(ImagePath.delete,width: 5.w,color: MyColors().whiteColor,):Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white,
//                 ),
//                 child:const Icon(Icons.remove_outlined)
//               ),
//             ),
//             Expanded(
//               child: MyText(
//                 title: '${widget.q}',
//                 weight: "Semi Bold",clr: MyColors().whiteColor,center: true,),
//             ),
//             GestureDetector(
//               onTap: () {
//                 widget.q++;
//                 setState(() {});
//                 widget.onTapAdd(widget.q);
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
