import 'package:auto_route/annotations.dart';
import 'package:backyard/boot.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/services/auth_service.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_terms_condition.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
                              maxLength: 35,
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
                              maxLength: 35,
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
                            onTap: () {
                              AppNavigation.navigateTo(AppRouteName.FORGET_PASSWORD_ROUTE);
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
            if (MediaQuery.viewInsetsOf(context).bottom == 0) ...[const CustomTermsCondition(), SizedBox(height: 4.h)],
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (!_form.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    getIt<AppNetwork>().loadingProgressIndicator();

    final signInSuccess = await getIt<AuthService>().signIn(email: email.text, password: password.text);
    AppNavigation.navigatorPop();

    if (!signInSuccess) return;
    final userController = navigatorKey.currentContext?.read<UserController>();

    if (userController?.user?.isVerified == 0) {
      CustomToast().showToast(
        message: 'OTP Verification code has been sent to your email address',
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
      );
      return AppNavigation.navigateTo(AppRouteName.ENTER_OTP_SCREEN_ROUTE);
    }

    if (userController?.user?.isProfileCompleted == 0) {
      await GeneralAPIS.getPlaces();
      return AppNavigation.navigateTo(AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
    }

    return AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
  }
}
