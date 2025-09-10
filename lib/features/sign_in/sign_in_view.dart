import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_web_view.dart';
import 'package:backyard/core/repositories/permission_repository.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool show = true;

  void hideShow() {
    show = !show;
    setState(() {});
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      child: CustomPadding(
        topPadding: 6.h,
        child: Column(
          children: [
            CustomAppBar(
              screenTitle: '',
              // leading: CustomBackButton(),
              bottom: 6.h,
            ),
            AppLogo(onTap: () {}),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: Utils.isTablet ? 60.w : null,
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      const MyText(
                        title: 'Login / Register', //'Login With Email',
                        size: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 2.h),
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              hintText: 'Email',
                              controller: email,
                              inputType: TextInputType.emailAddress,
                              prefixWidget: Image.asset(
                                ImagePath.email,
                                scale: 2,
                                color: CustomColors.primaryGreenColor,
                              ),
                              validation: (p0) => p0?.validateEmail,
                            ),
                            SizedBox(height: 2.h),
                            CustomTextFormField(
                              hintText: 'Password',
                              controller: password,
                              inputType: TextInputType.emailAddress,
                              prefixWidget: Icon(Icons.lock, color: CustomColors.primaryGreenColor),
                              obscureText: show,
                              suffixIcons: GestureDetector(
                                onTap: hideShow,
                                child: Image.asset(
                                  show ? ImagePath.showPass2 : ImagePath.showPass,
                                  scale: 3,
                                  color: CustomColors.primaryGreenColor,
                                ),
                              ),
                              validation: (p0) => p0?.validatePass,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await getIt<PermissionRepository>().requestTrackingPermission();
                              return context.pushRoute<void>(ForgotPasswordRoute());
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.roboto(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                decorationThickness: 2,
                                color: CustomColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      MyButton(title: 'Continue', onTap: onSubmit),
                    ],
                  ),
                ),
              ),
            ),
            if (MediaQuery.viewInsetsOf(context).bottom == 0)
              Padding(
                padding: CustomSpacer.bottom.xlg,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By sign-in, you agree to our ',
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 13, color: CustomColors.black),
                    children: [
                      TextSpan(
                        text: '\nTerms & Conditions',
                        style: GoogleFonts.roboto(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decorationThickness: 2,
                          color: CustomColors.black,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () => showWebViewBottomSheet(url: termsOfUseUrl, context: context),
                      ),
                      TextSpan(
                        text: ' & ',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decorationThickness: 2,
                          color: CustomColors.black,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.roboto(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decorationThickness: 2,
                          color: CustomColors.black,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () => showWebViewBottomSheet(url: privacyPolicyUrl, context: context),
                      ),
                    ],
                  ),
                  textScaler: TextScaler.linear(1.03),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    await getIt<PermissionRepository>().requestTrackingPermission();

    if (!_form.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    final userAuthRepository = getIt<UserAuthRepository>();
    final userProfile = await userAuthRepository.signIn(email: email.text, password: password.text);
    if (userProfile == null) return;

    if (!userProfile.isVerified) {
      CustomToast().showToast(
        message: 'OTP Verification code has been sent to your email address',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
      );

      return context.pushRoute<void>(EnterOTPRoute(userId: userProfile.id!));
    }

    if (!userProfile.isProfileCompleted) {
      await GeneralAPIS.getPlaces();
      return context.pushRoute<void>(ProfileSetupRoute(editProfile: false));
    }

    return context.pushRoute<void>(HomeRoute());
  }
}
