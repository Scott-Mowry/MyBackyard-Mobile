import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:backyard/Arguments/content_argument.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/app_strings.dart';
import 'package:backyard/Utils/my_colors.dart';

class CustomTermsCondition extends StatelessWidget {
  const CustomTermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: 1.03,
      text: TextSpan(
        text: "By sign-in, you agree to our ",
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          color: MyColors().black,
        ),
        children: [
          TextSpan(
            text: '\nTerms & Conditions',
            style: GoogleFonts.roboto(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decorationThickness: 2,
              color: MyColors().black,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
                    arguments: ContentRoutingArgument(
                        title: 'Terms & Conditions',
                        url: 'https://www.google.com/',
                        contentType: AppStrings.TERMS_AND_CONDITION_TYPE));
              },
          ),
          TextSpan(
            text: ' & ',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decorationThickness: 2,
              color: MyColors().black,
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
              color: MyColors().black,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                AppNavigation.navigateTo(AppRouteName.CONTENT_SCREEN,
                    arguments: ContentRoutingArgument(
                        title: 'Privacy Policy',
                        url: 'https://www.google.com/',
                        contentType: AppStrings.PRIVACY_POLICY_TYPE));

                // AppNavigation.navigateTo( AppRouteName.CONTENT_SCREEN, arguments: ContentRoutingArgument(
                //     title: AppStrings.PRIVACY_POLICY,
                //     contentType: AppStrings.PRIVACY_POLICY_TYPE));
              },
          ),
        ],
      ),
    );
  }
}
