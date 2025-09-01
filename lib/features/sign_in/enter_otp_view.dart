import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EnterOTPArgs {
  final String? verification;
  final String? phoneNumber;
  final bool? fromForgot;

  const EnterOTPArgs({this.phoneNumber, this.verification, this.fromForgot});
}

@RoutePage()
class EnterOTPView extends StatefulWidget {
  final String? phoneNumber;
  final bool? fromForgot;
  final String? verification;

  const EnterOTPView({super.key, this.phoneNumber, this.verification, this.fromForgot});

  @override
  State<EnterOTPView> createState() => _EnterOTPViewState();
}

class _EnterOTPViewState extends State<EnterOTPView> {
  TextEditingController otp = TextEditingController(text: '');

  /// #Timer
  Timer? timer;
  int resend = 0;
  String pinCode = '0';
  final form = GlobalKey<FormState>();
  late final userController = context.read<UserController>();

  Future<void> startTimer({bool val = true}) async {
    if (resend == 0) {
      setState(() {
        resend = 59;
      });
      if (val) {
        if (widget.verification != null) {
          getIt<AppNetwork>().loadingProgressIndicator();
          await resendCode(phoneNumber: widget.phoneNumber ?? '');
          context.maybePop();
        } else {
          getIt<AppNetwork>().loadingProgressIndicator();
          final value = await getIt<UserAuthRepository>().resendCode(id: userController.user?.id.toString());
          context.maybePop();
          if (value) {
            CustomToast().showToast(message: 'We have resend OTP verification code at your email address');
          }
        }
      }
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resend == 0) {
          timer.cancel();
        } else {
          setState(() {
            resend--;
          });
        }
      });
    } else {
      CustomToast().showToast(message: 'Please wait...');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer(val: false);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      child: CustomPadding(
        topPadding: 6 * (1.sh / 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAppBar(screenTitle: '', leading: CustomBackButton(), bottom: 6.h),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Utils.isTablet ? .6.sw : null,
                  child: Column(
                    children: [
                      AppLogo(),
                      SizedBox(height: Utils.isTablet ? 15.h : 4.h),
                      const MyText(title: 'OTP Verification', size: 20, fontWeight: FontWeight.w600),
                      20.verticalSpace,
                      label(
                        label:
                            'We have sent you an email containing 6 digits verification code. Please enter the code to verify your identity.',
                      ),
                      Utils.isTablet ? 30.verticalSpace : 10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: otp,
                          onCompleted: (v) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _onCompleteNavigation();
                          },
                          autoDismissKeyboard: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            fieldHeight: Utils.isTablet ? 44.r : 48.r,
                            fieldWidth: Utils.isTablet ? 44.r : 48.r,
                            activeFillColor: CustomColors.secondaryColor,
                            inactiveFillColor: CustomColors.secondaryColor,
                            selectedFillColor: CustomColors.secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                            inactiveColor: CustomColors.whiteColor,
                            activeColor: CustomColors.whiteColor,
                            selectedColor: CustomColors.whiteColor,
                            borderWidth: 1,
                            errorBorderColor: Theme.of(context).colorScheme.error,
                          ),
                          textStyle: TextStyle(color: CustomColors.black, fontSize: 15),
                          cursorColor: CustomColors.whiteColor,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          enableActiveFill: true,
                        ),
                      ),
                      Utils.isTablet ? 100.verticalSpace : 35.verticalSpace,
                      timerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            if (MediaQuery.viewInsetsOf(context).bottom == 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Didn't receive a code? ",
                      style: GoogleFonts.roboto(color: CustomColors.black, fontSize: Utils.isTablet ? 18 : 15),
                      children: [
                        TextSpan(
                          text: 'Resend Code',
                          style: GoogleFonts.roboto(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            color: resend == 0 ? CustomColors.black : CustomColors.hintColor,
                            fontSize: Utils.isTablet ? 18 : 16,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = startTimer,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget label({required String label}) {
    return Text(
      label,
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      style: GoogleFonts.poppins(
        fontSize: Utils.isTablet ? 8.sp : 14.sp,
        height: Utils.isTablet ? null : 1.1.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.black,
      ),
    );
  }

  Widget timerWidget() {
    return Container(
      height: Utils.isTablet ? 100.r : 110.r,
      width: Utils.isTablet ? 100.r : 110.r,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: Utils.isTablet ? 100.r : 110.r,
            height: Utils.isTablet ? 100.r : 110.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: CustomColors.black, shape: BoxShape.circle),
            child: Text(
              "00:${resend < 10 ? "0$resend" : resend}",
              style: TextStyle(
                fontSize: Utils.isTablet ? 11.sp : 16.sp,
                fontWeight: FontWeight.w600,
                color: CustomColors.whiteColor,
              ),
            ),
          ),
          SizedBox(
            width: Utils.isTablet ? 97.r : 107.r,
            height: Utils.isTablet ? 97.r : 107.r,
            child: CircularProgressIndicator(
              value: resend / 59,
              color: CustomColors.whiteColor,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resendCode({required String phoneNumber}) async {
    try {
      getIt<AppNetwork>().loadingProgressIndicator();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1$phoneNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (authCredential) async {},
        verificationFailed: (authException) {
          context.maybePop();
          CustomToast().showToast(message: 'Invalid Phone Number');
        },
        codeSent: (verificationId, forceResendingToken) {
          context.maybePop();
          CustomToast().showToast(
            message: 'We have resend OTP verification code at your phone number',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
          );
          context.pushRoute(EnterOTPRoute(phoneNumber: phoneNumber, verification: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (error) {
      log('error');
      context.maybePop();
      CustomToast().showToast(message: error.toString());
    }
  }

  Future<void> _onCompleteNavigation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    getIt<AppNetwork>().loadingProgressIndicator();
    final value = await getIt<UserAuthRepository>().verifyAccount(otpCode: otp.text, id: userController.user?.id ?? 0);
    if (!(widget.fromForgot ?? false)) {
      await GeneralAPIS.getPlaces();
    }
    context.maybePop();
    if (value) {
      CustomToast().showToast(message: 'Account validation completed. OTP verified');
      navigation();
    } else {
      otp.clear();
    }
  }

  Future<void> navigation() async {
    if (widget.fromForgot ?? false) {
      context.replaceRoute(ChangePasswordRoute());
    } else {
      if (userController.user?.isProfileCompleted ?? false) {
        context.pushRoute(HomeRoute());
      } else {
        context.pushRoute(ProfileSetupRoute(editProfile: false));
      }
    }
  }

  /// #Timer
}
