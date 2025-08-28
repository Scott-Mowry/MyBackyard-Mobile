import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Utils/app_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTermsCondition extends StatelessWidget {
  const CustomTermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
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
                  ..onTap =
                      () async => context.pushRoute(
                        ContentRoute(title: 'Terms & Conditions', contentType: AppStrings.TERMS_AND_CONDITION_TYPE),
                      ),
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
                  ..onTap =
                      () async => context.pushRoute(
                        ContentRoute(title: 'Terms & Conditions', contentType: AppStrings.TERMS_AND_CONDITION_TYPE),
                      ),
          ),
        ],
      ),
      textScaler: TextScaler.linear(1.03),
    );
  }
}
