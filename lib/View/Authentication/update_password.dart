// import 'package:backyard/Controller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:backyard/View/Widget/appLogo.dart';
// import '../../../Component/custom_buttom.dart';
// import '../../../Utils/my_colors.dart';
// import '../../../Utils/image_path.dart';
// import '../../Component/custom_rectangle_textfield.dart';
// import '../base_view.dart';
//
// class UpdatePassword extends StatelessWidget {
//   UpdatePassword({super.key});
//
//   TextEditingController password = TextEditingController();
//   TextEditingController confirmPassword = TextEditingController();
//   Rx<bool> isVisible = false.obs;
//   Rx<bool> isVisibleConfirm = false.obs;
//   RxBool rememberMeLogin = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(()=> BaseView(
//       showAppBar: true,
//       showBackgroundImage: true,
//       backgroundColor: Colors.transparent,
//       showBackButton:false,
//       resizeBottomInset: false,
//       screenTitle: "RESET PASSWORD",
//       child: Padding(
//         padding:  EdgeInsets.only(left: 4.w,right: 4.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppLogo(),
//             CustomRectangulatTextFormField(
//               title: "PASSWORD",
//               prefixIconScale: 3.2,
//               controller: password,
//               hintText: "PASSWORD",
//               maxLength: 30,
//               iconPath: ImagePath.lockIcon,
//               isSuffixIcon: true,
//               keyType: TextInputType.text,
//               showSuffixIcn: true,
//               obscureText: isVisible.value == true ? false : true,
//               suffixIconData:isVisible.value == true ? Icons.visibility_off : Icons.visibility,
//               ontapSuffix: () {isVisible.value = !isVisible.value;},
//             ),
//             CustomRectangulatTextFormField(
//               title: "CONFIRM PASSWORD",
//               prefixIconScale: 3.2,
//               controller: confirmPassword,
//               maxLength: 30,
//               hintText: "CONFIRM PASSWORD",
//               iconPath: ImagePath.lockIcon,
//               isSuffixIcon: true,
//               keyType: TextInputType.text,
//               showSuffixIcn: true,
//               obscureText: isVisibleConfirm.value == true ? false : true,
//               suffixIconData:isVisibleConfirm.value == true ? Icons.visibility_off : Icons.visibility,
//               ontapSuffix: () {isVisibleConfirm.value = !isVisibleConfirm.value;
//               },
//             ),
//             SizedBox(height: 3.h,),
//             MyButton(title: 'RESET'.tr, onTap: () {onSubmit(context);}),
//             SizedBox(height: 5.h,)
//           ],
//         ),
//
//       ),
//     ),
//     );
//   }
//   onSubmit(context){
//     Get.put(AuthController());
//     AuthController.i.password=password.text;
//     AuthController.i.confirmPassword=confirmPassword.text;
//     AuthController.i.updatePasswordValidation(context);
//   }
// }
