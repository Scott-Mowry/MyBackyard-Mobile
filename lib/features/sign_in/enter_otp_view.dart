import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/widgets/app_bar_back_button.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class EnterOTPView extends StatefulWidget {
  final int userId;
  final bool fromForgot;

  const EnterOTPView({super.key, required this.userId, this.fromForgot = false});

  @override
  State<EnterOTPView> createState() => _EnterOTPViewState();
}

class _EnterOTPViewState extends State<EnterOTPView> {
  final form = GlobalKey<FormState>();

  int resendOn = 0;
  Timer? resendTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => startTimer());
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
            CustomAppBar(screenTitle: '', leading: AppBarBackButton(), bottom: 6.h),
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
                      Text(
                        'We have sent you an email containing 6 digits verification code. Please enter the code to verify your identity.',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.poppins(
                          fontSize: Utils.isTablet ? 8.sp : 14.sp,
                          height: Utils.isTablet ? null : 1.1.sp,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.black,
                        ),
                      ),
                      Utils.isTablet ? 30.verticalSpace : 10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          onCompleted: verifyAccount,
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
                            color: resendOn == 0 ? CustomColors.black : CustomColors.hintColor,
                            fontSize: Utils.isTablet ? 18 : 16,
                          ),
                          recognizer: resendOn == 0 ? (TapGestureRecognizer()..onTap = resendCode) : null,
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
              "00:${resendOn < 10 ? "0$resendOn" : resendOn}",
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
              value: resendOn / 59,
              color: CustomColors.whiteColor,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> verifyAccount(String otpCode) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final userProfile = await getIt<UserAuthRepository>().verifyAccount(otpCode: otpCode, id: widget.userId);

    if (userProfile == null) return CustomToast().showToast(message: 'OTP validation failed.');

    CustomToast().showToast(message: 'Account validation completed. OTP verified');

    if (widget.fromForgot) return context.replaceRoute<void>(ChangePasswordRoute());
    if (userProfile.isProfileCompleted) return context.pushRoute<void>(HomeRoute());

    return context.pushRoute<void>(ProfileSetupRoute(isEditProfile: false));
  }

  Future<void> resendCode() async {
    if (resendOn > 0) return;

    final resent = await getIt<UserAuthRepository>().resendCode(widget.userId.toString());
    if (!resent) return CustomToast().showToast(message: 'We could not resend the OTP verification code');

    startTimer();
    CustomToast().showToast(message: 'We have resend OTP verification code at your email address');
  }

  void startTimer() {
    if (resendOn != 0) return CustomToast().showToast(message: 'Please wait...');
    setState(() => resendOn = 59);

    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOn == 0) return timer.cancel();
      setState(() => resendOn--);
    });
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }
}
