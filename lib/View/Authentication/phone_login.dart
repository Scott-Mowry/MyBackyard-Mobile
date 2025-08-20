import 'dart:developer';

import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_background_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/View/Authentication/enter_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/View/Widget/appLogo.dart';
import '../../Component/custom_buttom.dart';
import '../../Component/custom_text.dart';
import '../../Utils/image_path.dart';
import '../../Utils/my_colors.dart';

class PhoneLogin extends StatelessWidget {
  PhoneLogin({super.key});
  TextEditingController phone = TextEditingController();
  String dialCode = "1";
  String countryCode = "US";
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: CustomBackgroundImage(
        child: CustomPadding(
          topPadding: 6.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                screenTitle: '',
                leading: CustomBackButton(),
                bottom: 6.h,
              ),
              AppLogo(),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      const MyText(
                        title: 'Login With Phone',
                        size: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Form(
                        key: _form,
                        child: MyTextField(
                          prefixWidget: Image.asset(
                            ImagePath.phone,
                            scale: 2,
                            color: MyColors().primaryColor,
                          ),
                          controller: phone,
                          hintText: 'Phone Number',
                          prefixText: "+1",
                          inputType: TextInputType.phone,
                          contact: true,
                          validation: (value) {
                            final cleanedPhoneNumber = value
                                .toString()
                                .replaceAll(RegExp(r'[()-\s]'),
                                    ''); // Remove brackets, dashes, and spaces
                            log(cleanedPhoneNumber);

                            if (cleanedPhoneNumber == null ||
                                !isNumeric(cleanedPhoneNumber)) {
                              return "Phone number field can\"t be empty";
                            }
                            if (cleanedPhoneNumber.length < 10) {
                              return "Invalid Phone Number";
                            }

                            return null;
                          },
                        ),
                      ),
                      // PhoneNumberTextField(
                      //     controller: phone, onCountryChanged:(c){dialCode=c.dialCode; print(c.dialCode);countryCode=c.code;phone.text='';}
                      // ),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyButton(
                          title: "Continue",
                          onTap: () {
                            onSubmit();
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithPhone(
      {required String phoneNumber,
      required VoidCallback setProgressBar,
      required VoidCallback cancelProgressBar}) async {
    try {
      setProgressBar();
      //  print("$countryCode$phoneNumber");
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+1$phoneNumber",
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            cancelProgressBar();
            CustomToast().showToast(message: "Invalid Phone Number");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            cancelProgressBar();
            CustomToast().showToast(
                message:
                    "OTP Verification code has been sent to your phone number",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5);
            AppNavigation.navigateTo(
              AppRouteName.ENTER_OTP_SCREEN_ROUTE,
              arguments: EnterOTPArguements(
                phoneNumber: phoneNumber,
                verification: verificationId,
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (error) {
      log("error");
      cancelProgressBar();
      CustomToast().showToast(message: error.toString());
    }
  }

  onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_form.currentState?.validate() ?? false) {
      await signInWithPhone(
          phoneNumber: phone.text.replaceAll(" ", ""),
          setProgressBar: () {
            AppNetwork.loadingProgressIndicator();
          },
          cancelProgressBar: () {
            AppNavigation.navigatorPop();
          });
    }
  }
}
