// import 'package:backyard/Component/custom_empty_data.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import '../../../Component/custom_text.dart';
// import '../../../Utils/image_path.dart';
// import 'add_alert.dart';
//
// class MyCards extends StatelessWidget {
//   MyCards({Key? key,this.showAddCard=false}) : super(key: key);
//   bool showAddCard=false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(()=> HomeController.i.cards.isEmpty?
//     // CustomEmptyData(title: "No cards"):
//       Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CustomEmptyData(title: "No cards",image:showAddCard?null: ImagePath.creditCard,),
//         if(showAddCard)
//         addCard(context),
//       ],
//     ):
//     ListView.builder(
//       itemCount: HomeController.i.cards.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) {
//         return  Padding(
//           padding: EdgeInsets.only(bottom: 2.w),
//           child: Slidable(
//             key: UniqueKey(),
//             endActionPane: ActionPane(
//               dragDismissible:false,
//               extentRatio: 0.20,
//               motion: ScrollMotion(),
//               children: [
//                 GestureDetector(
//                   onTap:(){
//                     HomeController.i.deleteCard(context,index: index, id:HomeController.i.cards[index].id??"",onSuccess: (){});
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     margin: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color:MyColors().errorColor,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.delete,color: Colors.white,),
//                   ),
//                 )
//               ],
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 HomeController.i.setCardDefault(context, onSuccess: (){},index: index, id: HomeController.i.cards[index].id??"");
//               },
//               child: ClipPath(
//                 clipper: ShapeBorderClipper(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10))),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color:Colors.white,border:
//                     HomeController.i.cards[index].isActive==true?
//                     Border(right: BorderSide(color: Theme.of(context).primaryColorDark, width: 15)):null,
//                   ),
//                   child:
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 2.w,horizontal: 2.w),
//                     child: Row(
//                       children: [
//                         Image.asset(ImagePath.creditCard,width: 7.w,),
//                         SizedBox(width: 5.w,),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             MyText(
//                               title:HomeController.i.cards[index].nameOnCard??"",
//                               size: 13,
//                               clr:  const Color(0xff282828),
//                               weight: "Semi Bold",
//                             ),
//                             MyText(
//                               title:HomeController.i.cards[index].cardNumber??"",
//                               size: 13,
//                               clr: const Color(0xff282828),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     ),);
//   }
//   Widget addCard(context){
//     return  InkWell(
//       onTap: (){
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 backgroundColor: Colors.transparent,
//                 contentPadding: const EdgeInsets.fromLTRB(
//                     0, 0, 0, 0),
//                 content: CardAlert(),
//               );
//             }
//         );
//       },
//       child: Row(
//         children: [
//         Image.asset(ImagePath.creditCard,width: 6.w,),
//         SizedBox(width: 2.w,),
//         MyText(title: "Add card",clr: Colors.black,),
//       ],),
//     );
//   }
// }
