import 'dart:ui';

import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/auth_apis.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
// import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/local_shared_preferences.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/Widget/appLogo.dart';
// import 'package:backyard/legacy/Arguments/screen_arguments.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_terms_condition.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool show = true;
  User? savedUser;

  void hideShow() {
    show = !show;
    setState(() {});
  }

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    final val = SharedPreference().getSavedUser();
    if (val != null) {
      savedUser = User.setUser2(val, token: val['bearer_token']);
    }
    // TODO: implement initState
    super.initState();
  }

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
                      if (savedUser != null) ...[
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    contentPadding: const EdgeInsets.all(0),
                                    insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                    content: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      // height: responsive.setHeight(75),
                                      width: 100.w,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: MyColors().primaryColor,
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                                              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Image.asset(ImagePath.close, scale: 2, color: Colors.transparent),
                                                  MyText(
                                                    title: 'Remove Saved User',
                                                    clr: MyColors().whiteColor,
                                                    fontWeight: FontWeight.w600,
                                                    size: 18,
                                                  ),
                                                  GestureDetector(
                                                    onTap: AppNavigation.navigatorPop,
                                                    child: Image.asset(ImagePath.close, scale: 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 2.h),
                                                  const MyText(
                                                    title: 'Do you want to remove saved user?',
                                                    size: 14,
                                                    center: true,
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  MyButton(
                                                    onTap: () {
                                                      AppNavigation.navigatorPop();
                                                      SharedPreference().clear();
                                                      savedUser = null;
                                                      setState(() {});
                                                    },
                                                    title: 'Yes',
                                                  ),
                                                  SizedBox(height: 1.5.h),
                                                  MyButton(
                                                    onTap: () {
                                                      AppNavigation.navigatorPop();
                                                    },
                                                    title: 'No',
                                                  ),
                                                  SizedBox(height: 2.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          onTap: () async {
                            AppNetwork.loadingProgressIndicator();
                            final val = await AuthAPIS.signInWithId(id: savedUser?.id?.toString() ?? '');
                            AppNavigation.navigatorPop();
                            if (val) {
                              AppNavigation.navigateTo(AppRouteName.HOME_SCREEN_ROUTE);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: 85.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: MyColors().secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                CustomImage(
                                  shape: BoxShape.circle,
                                  height: 50,
                                  width: 50,
                                  url: savedUser?.profileImage ?? '',
                                ),
                                SizedBox(width: 1.w),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyText(
                                        title: "${savedUser?.name ?? ""} ${savedUser?.lastName ?? ""}",
                                        size: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      MyText(title: savedUser?.role?.name ?? '', size: 14),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'OR',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            decorationThickness: 2,
                            color: MyColors().black,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () {
                            savedUser = null;
                            setState(() {});
                          },
                          child: Text(
                            'Other Account',
                            style: GoogleFonts.roboto(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              decorationThickness: 2,
                              color: MyColors().black,
                            ),
                          ),
                        ),
                      ] else ...[
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                hintText: 'Email',
                                controller: email,
                                maxLength: 35,
                                inputType: TextInputType.emailAddress,
                                prefixWidget: Image.asset(ImagePath.email, scale: 2, color: MyColors().primaryColor),
                                validation: (p0) => p0?.validateEmail,
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                hintText: 'Password',
                                controller: password,
                                maxLength: 35,
                                inputType: TextInputType.emailAddress,
                                prefixWidget: Icon(Icons.lock, color: MyColors().primaryColor),
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
                                  color: MyColors().black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        MyButton(
                          title: 'Continue',
                          onTap: () {
                            onSubmit();
                          },
                        ),
                      ],
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
    if (_form.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      AppNetwork.loadingProgressIndicator();
      final val = await AuthAPIS.signIn(email: email.text, password: password.text);
      AppNavigation.navigatorPop();
      if (val) {
        final userController = navigatorKey.currentContext?.read<UserController>();
        if (userController?.user?.isVerified == 0) {
          CustomToast().showToast(
            message: 'OTP Verification code has been sent to your email address',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
          );
          AppNavigation.navigateTo(AppRouteName.ENTER_OTP_SCREEN_ROUTE);
        } else {
          if (userController?.user?.isProfileCompleted == 0) {
            GeneralAPIS.getPlaces();
            AppNavigation.navigateTo(AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
          } else {
            AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
          }
        }
      }
    }
  }
}
