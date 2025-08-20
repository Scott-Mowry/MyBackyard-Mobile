import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_background_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:backyard/View/Widget/appLogo.dart';
import '../../Component/custom_buttom.dart';
import '../../Component/custom_text.dart';
import '../../Utils/image_path.dart';

class ChangePasswordArguments {
  const ChangePasswordArguments({this.fromSettings});

  final bool? fromSettings;
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, this.fromSettings});

  final bool? fromSettings;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
      image: (widget.fromSettings ?? false) ? "" : null,
      color: (widget.fromSettings ?? false) ? MyColors().whiteColor : null,
      child: CustomPadding(
        topPadding: 6.h,
        child: Column(
          children: [
            CustomAppBar(
              screenTitle: '',
              leading: CustomBackButton(),
              bottom: 6.h,
            ),
            AppLogo(
              onTap: () {},
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    const MyText(
                      title: 'Change Password',
                      size: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          MyTextField(
                            hintText: 'Password',
                            controller: password,
                            maxLength: 35,
                            inputType: TextInputType.emailAddress,
                            prefixWidget: Icon(
                              Icons.lock,
                              color: MyColors().primaryColor,
                            ),
                            obscureText: show,
                            suffixIcons: GestureDetector(
                              onTap: hideShow,
                              child: Image.asset(
                                show ? ImagePath.showPass2 : ImagePath.showPass,
                                scale: 3,
                                color: MyColors().primaryColor,
                              ),
                            ),
                            validation: (p0) => p0?.validatePass,
                          ),
                          SizedBox(height: 2.h),
                          MyTextField(
                            hintText: 'Confirm Password',
                            controller: confPassword,
                            maxLength: 35,
                            inputType: TextInputType.emailAddress,
                            prefixWidget: Icon(
                              Icons.lock,
                              color: MyColors().primaryColor,
                            ),
                            obscureText: show2,
                            suffixIcons: GestureDetector(
                              onTap: hideShow2,
                              child: Image.asset(
                                show2
                                    ? ImagePath.showPass2
                                    : ImagePath.showPass,
                                scale: 3,
                                color: MyColors().primaryColor,
                              ),
                            ),
                            validation: (p0) {
                              if (p0 != null) {
                                if (p0.isEmpty) {
                                  return "Confirm Password field can't be empty";
                                }
                                if (p0 != password.text) {
                                  return "Confirm Password & Password must be same";
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    MyButton(
                        title: 'Change',
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
    );
  }

  onSubmit() async {
    if (_form.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      AppNetwork.loadingProgressIndicator();
      final user = context.read<UserController>().user;
      final val = await AuthAPIS.changePassword(
          id: user?.id ?? 0, password: password.text);
      AppNavigation.navigatorPop();
      if (val) {
        if (widget.fromSettings ?? false) {
          AppNavigation.navigatorPop();
        } else {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
        }
      }
    }
  }
}
