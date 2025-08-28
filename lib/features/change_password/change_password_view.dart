import 'package:auto_route/auto_route.dart';
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
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/appLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordViewArgs {
  const ChangePasswordViewArgs({this.fromSettings});

  final bool? fromSettings;
}

@RoutePage()
class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key, this.fromSettings});

  final bool? fromSettings;

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
      image: (widget.fromSettings ?? false) ? '' : null,
      color: (widget.fromSettings ?? false) ? CustomColors.whiteColor : null,
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
                          SizedBox(height: 2.h),
                          CustomTextFormField(
                            hintText: 'Confirm Password',
                            controller: confPassword,
                            maxLength: 35,
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
    if (_form.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      getIt<AppNetwork>().loadingProgressIndicator();
      final user = context.read<UserController>().user;
      final val = await getIt<UserAuthRepository>().changePassword(id: user?.id ?? 0, password: password.text);
      context.maybePop();
      if (val) {
        if (widget.fromSettings ?? false) {
          context.maybePop();
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    }
  }
}
