// import 'package:backyard/Component/Appbar/appbar_components.dart';
// import 'package:backyard/Component/custom_background_image.dart';
// import 'package:backyard/Component/custom_padding.dart';
// import 'package:backyard/Component/custom_textfield.dart';
// import 'package:backyard/Component/title.dart';
// import 'package:backyard/Controller/auth_controller.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:backyard/Utils/utils.dart';
// import 'package:sizer/sizer.dart';
// import '../../Component/custom_buttom.dart';
// import '../../Component/custom_rectangle_textfield.dart';
// import '../../Utils/image_path.dart';
// import '../Widget/appLogo.dart';
// import '../base_view.dart';
//
// class SignupScreen extends StatelessWidget {
//   SignupScreen({super.key});
//   TextEditingController fullName = TextEditingController(),firstName = TextEditingController(),lastName = TextEditingController(),email = TextEditingController(),password = TextEditingController(), confirmPassword = TextEditingController(),phone = TextEditingController(),dob = TextEditingController();
//   // Rx<bool> isVisible = false.obs, isVisibleConfirm = false.obs, rememberMeLogin = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundImage(
//       child: CustomPadding(
//           topPadding: 6.h,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(alignment: Alignment.centerLeft, child: CustomBackButton(color: MyColors().whiteColor,)),
//               SizedBox(height: 3.h,),
//               AppLogo(
//                 onTap: () {
//                   fullName.text = "Test User";
//                   firstName.text = "John";
//                   lastName.text = "Smith";
//                   email.text = "test@gmail.com";
//                   password.text = "Abcd@1234";
//                   confirmPassword.text = "Abcd@1234";
//                 },
//               ),
//               Expanded(
//                 child:  SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       ScreenTitle(title: 'Sign Up'),
//                       SizedBox(
//                         height: 2.h,
//                       ),
//                       // MyTextField(
//                       //   controller: fullName,
//                       //   hintText: 'Full Name',
//                       // ),
//                       MyTextField(
//                         controller: firstName,
//                         hintText: 'First Name',
//                         maxLength: 30,
//                       ),
//                       SizedBox(height: 1.5.h,),
//                       MyTextField(
//                         controller: lastName,
//                         hintText: 'Last Name',
//                         maxLength: 30,
//                       ),
//                       SizedBox(height: 1.5.h,),
//                       MyTextField(
//                         controller: email,
//                         hintText: 'Email',
//                         maxLength: 35,
//                         inputType: TextInputType.emailAddress,
//                       ),
//                       SizedBox(
//                         height: 2.h,
//                       ),
//                       MyButton(
//                           title: 'Sign Up',
//                           onTap: () {
//                             onSubmit(context);
//                           }),
//
//                       // SizedBox(height: 1.5.h,),
//                       // MyTextField(
//                       //     controller: password,
//                       //     hintText: 'Password',
//                       //     obscureText: isVisible.isTrue ? false : true,
//                       //     suffixIconData: isVisible.isTrue ? const Icon(Icons.visibility_off,color: Colors.white,) : const Icon(Icons.visibility,color: Colors.white,),
//                       //     onTapSuffixIcon: () {isVisible.value = !isVisible.value;}),
//                       // SizedBox(height: 1.5.h,),
//                       // MyTextField(
//                       //     controller: confirmPassword,
//                       //     maxLength: 30,
//                       //     hintText: "Confirm Password",
//                       //     obscureText: isVisibleConfirm.isTrue ? false : true,
//                       //     suffixIconData: isVisibleConfirm.isTrue ? const Icon(Icons.visibility_off,color: Colors.white,) : const Icon(Icons.visibility,color: Colors.white,),
//                       //     onTapSuffixIcon: () {isVisibleConfirm.value = !isVisibleConfirm.value;}),
//                       // SizedBox(height: 1.5.h,),
//                       // MyTextField(
//                       //   controller: phone,
//                       //   hintText: 'Phone',
//                       //   inputType: TextInputType.phone,
//                       //   contact: true,
//                       // ),
//                       // SizedBox(height: 1.5.h,),
//                       // MyTextField(
//                       //   controller: dob,
//                       //   hintText: 'Date of birth',
//                       //   readOnly: true,
//                       //   onTap: ()async{
//                       //     FocusManager.instance.primaryFocus?.unfocus();
//                       //     dob.text=await Utils().selectDate(context);
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//
//
//               // SizedBox(
//               //   height: 35.h,
//               //   // height: 25.h,
//               // ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 3.h),
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     textScaleFactor: 1.03,
//                     text: TextSpan(
//                       text: "Already have an account? ",
//                       style: GoogleFonts.roboto(
//                         color: MyColors().whiteColor,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Login',
//                           style: GoogleFonts.roboto(
//                             decoration:  TextDecoration.underline,
//                             decorationThickness: 2,
//                             color: MyColors().pinkColor,
//                           ),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               FocusManager.instance.primaryFocus?.unfocus();
//                               AppNavigation.navigatorPop(context);
//                             },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//             ],
//           )
//       ),
//     );
//   }
//
//   onSubmit(context) {
//     AuthController.i.firstName = firstName.text;
//     AuthController.i.lastName = lastName.text;
//     AuthController.i.email = email.text;
//
//
//     // AuthController.i.password = password.text;
//     // AuthController.i.confirmPassword = confirmPassword.text;
//     // AuthController.i.phone = phone.text;
//     // AuthController.i.dob = dob.text;
//     AuthController.i.signUpValidation(context);
//   }
// }
