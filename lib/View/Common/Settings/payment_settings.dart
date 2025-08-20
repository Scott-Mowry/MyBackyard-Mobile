// import 'package:backyard/Component/custom_buttom.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/View/Widget/card/add_alert.dart';
// import 'package:backyard/View/Widget/card/my_cards.dart';
// import 'package:flutter/material.dart';
// import '../../../../../Utils/my_colors.dart';
// import '../../../../../Utils/responsive.dart';
// import '../../../../Component/custom_text.dart';
// import 'package:sizer/sizer.dart';
// import '../../Component/custom_empty_data.dart';
// import '../Widget/card/delete_alert.dart';
// import '../base_view.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// import 'package:get/get.dart';
//
// class PaymentSettings extends StatefulWidget {
//   const PaymentSettings({super.key});
//
//   @override
//   State<PaymentSettings> createState() => _PaymentSettingsState();
// }
//
// class _PaymentSettingsState extends State<PaymentSettings> {
//   Responsive responsive = Responsive();
//   MyColors colors = MyColors();
//
//   @override
//   Widget build(BuildContext context) {
//     responsive.setContext(context);
//     return BaseView(
//         screenTitle: "PAYMENT SETTINGS",
//         showAppBar: true,
//         showBackButton: true,
//         resizeBottomInset: false,
//         screenTitleColor: Theme.of(context).primaryColor,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5.w),
//           child: Column(
//             children: [
//               SizedBox(height: 1.5.h),
//               const Divider(),
//               SizedBox(height: 1.5.h),
//               Expanded(child: MyCards()),
//               SizedBox(height:  3.h),
//               MyButton(
//                 title: "ADD NEW",
//                 onTap: (){
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           backgroundColor: Colors.transparent,
//                           contentPadding: const EdgeInsets.fromLTRB(
//                               0, 0, 0, 0),
//                           content: CardAlert(),
//                         );
//                       }
//                   );
//
//                 },
//               ),
//               SizedBox(height:  3.h),
//
//             ],
//           ),
//         )
//     );
//   }
// }
