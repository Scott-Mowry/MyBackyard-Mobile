import 'dart:io' show Platform;

import 'package:backyard/View/Widget/appLogo.dart';
import 'package:backyard/legacy/Component/custom_background_image.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_terms_condition.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/auth_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  late final userController = context.read<UserController>();

  Future<void> appleFunction() async {
    AppNetwork.loadingProgressIndicator();
    final internet = await AppNetwork.checkInternet();
    if (internet) {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        );

        var name = "${(credential.givenName ?? "")} ${(credential.familyName ?? '')}";
        final email = credential.email ?? '';

        if (name.trim().isEmpty) {
          final decodedToken = JwtDecoder.decode(credential.identityToken ?? '');
          final String temp = decodedToken['email'] ?? '';
          name = temp.isNotEmpty ? temp.split('@').first : temp;
        }

        if (await AuthAPIS.socialLogin(
          socialType: 'apple',
          email: email,
          socialToken: credential.userIdentifier ?? '',
          name: name,
        )) {
          AppNavigation.navigatorPop();
          CustomToast().showToast(message: 'logged in succesfully');
          AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
        } else {
          //await auth.signOut();
          AppNavigation.navigatorPop();
          if (userController.user?.isProfileCompleted == 0) {
            AppNavigation.navigateTo(AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
          }
        }
      } catch (error) {
        AppNavigation.navigatorPop();
        CustomToast().showToast(message: 'Apple sign-in error: $error');
      }
    } else {
      AppNavigation.navigatorPop();
      CustomToast().showToast(message: 'No Internet Connection');
    }
  }

  Future<void> googleFunction() async {
    AppNetwork.loadingProgressIndicator();
    final internet = await AppNetwork.checkInternet();
    if (internet) {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      try {
        final googleSignIn0 = GoogleSignIn(scopes: ['email']);

        final googleSignInAccount = await googleSignIn0.signIn();

        if (googleSignInAccount != null) {
          await googleSignIn.signOut();
          if (await AuthAPIS.socialLogin(
            socialType: 'google',
            socialToken: googleSignInAccount.id,
            name: googleSignInAccount.displayName ?? '',
          )) {
            AppNavigation.navigatorPop();
            CustomToast().showToast(message: 'logged in succesfully');
            AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
          } else {
            if (userController.user?.isProfileCompleted == 0) {
              AppNavigation.navigateTo(AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE);
            }
          }
        } else {
          AppNavigation.navigatorPop();
          CustomToast().showToast(message: 'Google sign-in Cancel');
        }
      } catch (error) {
        AppNavigation.navigatorPop();
        CustomToast().showToast(message: 'Google sign-in error: $error');
      }
    } else {
      AppNavigation.navigatorPop();
      CustomToast().showToast(message: 'No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackgroundImage(
        child: CustomPadding(
          topPadding: 6.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Align(alignment: Alignment.centerLeft, child: CustomBackButton(color: MyColors().whiteColor,)),
              SizedBox(height: 3.h),
              AppLogo(onTap: () {}),
              SizedBox(height: 4.h),
              MyText(title: 'Login', size: 20, fontWeight: FontWeight.w600),
              SizedBox(height: 4.h),
              MyButton(
                prefixIconPath: ImagePath.email,
                showPrefix: true,
                prefixIconSize: 2,
                title: 'Sign in with Email',
                onTap: () {
                  AppNavigation.navigateTo(AppRouteName.LOGIN_SCREEN_ROUTE);
                },
              ),
              SizedBox(height: 2.h),
              MyButton(
                title: 'Sign in with Phone Number',
                prefixIconPath: ImagePath.phone,
                showPrefix: true,
                prefixIconSize: 2,
                bgColor: MyColors().greenColor,
                gradient: false,
                onTap: () {
                  AppNavigation.navigateTo(AppRouteName.PHONE_LOGIN_SCREEN_ROUTE);
                },
              ),
              SizedBox(height: 2.h),
              MyButton(
                title: 'Sign in with Google',
                bgColor: MyColors().gPayColor,
                prefixIconPath: ImagePath.google,
                prefixIconSize: 2,
                showPrefix: true,
                gradient: false,
                onTap: googleFunction,
              ),
              if (Platform.isIOS) ...[
                SizedBox(height: 2.h),
                MyButton(
                  title: 'Sign in with Apple',
                  textColor: MyColors().black,
                  bgColor: MyColors().whiteColor,
                  prefixIconPath: ImagePath.apple,
                  showPrefix: true,
                  gradient: false,
                  prefixIconSize: 2,
                  onTap: appleFunction,
                ),
              ],
              const Spacer(),
              const CustomTermsCondition(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
