import 'package:auto_route/annotations.dart';
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
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Authentication/enter_otp.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController email = TextEditingController();
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
            CustomAppBar(screenTitle: '', leading: CustomBackButton(), bottom: 6.h),
            AppLogo(onTap: () {}),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    const MyText(title: 'Forgot Password', size: 20, fontWeight: FontWeight.w600),
                    SizedBox(height: 2.h),
                    Form(
                      key: _form,
                      child: CustomTextFormField(
                        hintText: 'Email',
                        controller: email,
                        maxLength: 35,
                        inputType: TextInputType.emailAddress,
                        prefixWidget: Image.asset(ImagePath.email, scale: 2, color: CustomColors.primaryGreenColor),
                        validation: (p0) => p0?.validateEmail,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    MyButton(
                      title: 'Continue',
                      onTap: () {
                        onSubmit();
                      },
                    ),
                  ],
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
    if (_form.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      getIt<AppNetwork>().loadingProgressIndicator();
      final val = await getIt<AuthService>().forgotPassword(email: email.text);
      AppNavigation.navigatorPop();
      if (val) {
        CustomToast().showToast(
          message: 'OTP code for Forgot Password has been sent to your email address',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
        );
        AppNavigation.navigateTo(AppRouteName.ENTER_OTP_VIEW_ROUTE, arguments: EnterOTPArguements(fromForgot: true));
      }
    }
  }
}
