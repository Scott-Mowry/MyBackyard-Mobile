// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:backyard/Component/custom_buttom.dart';
// import 'package:backyard/Component/custom_text.dart';
// import 'package:backyard/Component/custom_toast.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/app_router_name.dart';
// import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:backyard/View/Widget/upload_media.dart';
// import 'package:sizer/sizer.dart';
//
// class UploadThumbnailDialog extends StatelessWidget {
//   Rx<File> img = File('').obs;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       // insetPadding: EdgeInsets.symmetric(horizontal: 5.w) ,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 5.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: 3.h,
//             ),
//             MyText(title: 'Upload Thumbnail',size: 18,fontWeight: FontWeight.w600,center: true,),
//             SizedBox(
//               height: 1.5.h,
//             ),
//             Divider(),
//             SizedBox(
//               height: 2.h,
//             ),
//
//             MyText(title: 'Please upload a thumbnail for your live streaming. Thumbnails help viewers find and watch your live streaming.',clr: MyColors().hintColor,center: true,),
//             SizedBox(
//               height: 1.5.h,
//             ),
//             GestureDetector(
//               onTap: (){
//                 FocusManager.instance.primaryFocus?.unfocus();
//                 Get.bottomSheet(
//                   UploadMedia(
//                     file: (val) {
//                       img.value=val!;
//                     },
//                     singlePick: true,
//                   ),
//                   isScrollControlled: true,
//                   backgroundColor: Theme.of(context).selectedRowColor,
//                   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//                 );
//               },
//               child: Obx(()=> Container(
//                     height: 20.h,
//                     width: 100.w,
//                     decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(ImagePath.dottedBorder),fit: BoxFit.fill)),
//                     child: img.value.path==''? Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(ImagePath.upload,width: 5.w,),
//                         SizedBox(height: 1.h,),
//                         MyText(title: 'Upload Image',clr: MyColors().purpleLight.withOpacity(.7),fontWeight: FontWeight.w600,)
//                       ],
//                     ) : Container(
//                       padding: const EdgeInsets.all(4.0),
//                       child: ClipRRect(borderRadius: BorderRadius.circular(8),child: Image.file(img.value,fit: BoxFit.fill,)),
//                     )
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 2.h,
//             ),
//             MyButton(onTap: (){
//               onSubmit(context);
//             },title: 'Go Live',),
//             SizedBox(
//               height: 2.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   onSubmit(context){
//     var h=HomeController.i;
//     h.temp=[];
//     h.temp.add(FileNetwork(isNetwork: false, path: img.value.path));
//     h.startStreamingValidation(context,onSuccess: (){
//       AppNavigation.navigatorPop(context);
//       });
//   }
// }