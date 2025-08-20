import 'package:flutter/material.dart';

// class MyRadioList extends StatefulWidget {
//   MyRadioList({Key? key,required this.oneValue}) : super(key: key);
//   var oneValue = '';
//   @override
//   State<MyRadioList> createState() => _MyRadioListState();
// }
//
// class _MyRadioListState extends State<MyRadioList> {
//
//   final List<String> one = [
//     AppStrings.HIRE_IMMEDIATELY,
//     AppStrings.CASUAL_BROWSING,
//     AppStrings.NO_WORK,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height:13.h,
//         child: ListView.builder(
//           itemCount: one.length,
//           itemBuilder: (context, index) => Padding(
//             padding: EdgeInsets.only(bottom: 0.5.h),
//             child: InkWell(
//               onTap: () {
//                 widget.oneValue = one[index];
//                 setState(() {});
//               },
//               child: Row(
//                 children: [
//                   SizedBox(
//                     height: 24.0,
//                     width: 24.0, child: Radio(
//                     value: one[index],
//                     groupValue: widget.oneValue,
//                     activeColor: Theme
//                         .of(context)
//                         .primaryColor,
//                     onChanged: (value) {
//                       setState(() {
//                         widget.oneValue = value.toString();
//                       });
//                     },
//                   ),
//                   ),
//                   SizedBox(width: 2.w,),
//                   MyText(
//                     title: one[index],
//                     clr: MyColors().black,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//   }
// }

class CustomRadioTile extends StatelessWidget {
  CustomRadioTile({Key? key, required this.v, this.color}) : super(key: key);
  bool v = true;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 8,
        backgroundColor: color,
        child: CircleAvatar(
            radius: 7,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: v ? color : Colors.white,
            )));
  }
}

// class CustomRadioList extends StatelessWidget {
//   CustomRadioList({Key? key,required this.items,required this.onSelect,required this.value}) : super(key: key);
//   List items=[];
//   RxString value = ''.obs;
//   Function(String?)? onSelect;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10)
//       ),
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(vertical: 1.5.h),
//       child: ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: items.length,
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         itemBuilder: (context, index) => Padding(
//           padding: EdgeInsets.only(bottom: 0.5.h,left: 4.w),
//           child: InkWell(
//             onTap: () {
//               value.value = items[index];
//               onSelect!(value.value);
//             },
//             child: Row(
//               children: [
//                 Obx(()=> CustomRadioTile(v: value.value == items[index],)),
//                 SizedBox(width: 2.w,),
//                 MyText(
//                   title: items[index],
//                   clr: MyColors().black,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



