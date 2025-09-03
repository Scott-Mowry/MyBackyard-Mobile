import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ChangePasswordView extends StatefulWidget {
  final bool fromSettings;

  const ChangePasswordView({super.key, this.fromSettings = false});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController confPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  bool show = true;
  bool show2 = true;

  void hideShow() {
    show = !show;
    setState(() {});
  }

  void hideShow2() {
    show2 = !show2;
    setState(() {});
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      image: (widget.fromSettings) ? '' : null,
      color: (widget.fromSettings) ? CustomColors.whiteColor : null,
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
                    const MyText(title: 'Change Password', size: 20, fontWeight: FontWeight.w600),
                    SizedBox(height: 2.h),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
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
                          SizedBox(height: 2.h),
                          CustomTextFormField(
                            hintText: 'Confirm Password',
                            controller: confPassword,
                            inputType: TextInputType.emailAddress,
                            prefixWidget: Icon(Icons.lock, color: CustomColors.primaryGreenColor),
                            obscureText: show2,
                            suffixIcons: GestureDetector(
                              onTap: hideShow2,
                              child: Image.asset(
                                show2 ? ImagePath.showPass2 : ImagePath.showPass,
                                scale: 3,
                                color: CustomColors.primaryGreenColor,
                              ),
                            ),
                            validation: (p0) {
                              if (p0 != null) {
                                if (p0.isEmpty) {
                                  return "Confirm Password field can't be empty";
                                }
                                if (p0 != password.text) {
                                  return 'Confirm Password & Password must be same';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    MyButton(
                      title: 'Change',
                      onTap: () {
                        onSubmit();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (!_form.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final userProfile = await getIt<UserAuthRepository>().changePassword(password: password.text);
    if (userProfile == null) return;
    if (widget.fromSettings) {
      await context.maybePop();
      return;
    }

    MyBackyardApp.appRouter.popUntilRoot();
    return MyBackyardApp.appRouter.replace<void>(LandingRoute());
  }
}
