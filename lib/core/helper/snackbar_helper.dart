import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

void showSnackbar({
  Key? key,
  required BuildContext context,
  required String content,
  Duration duration = const Duration(seconds: 5),
  bool isError = false,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.hideCurrentSnackBar();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      key: key,
      behavior: SnackBarBehavior.floating,
      padding: CustomSpacer.all.md,
      backgroundColor: CustomColors.grey,
      content: Row(
        children: [
          Icon(isError ? Icons.warning_amber_outlined : Icons.info_outline, color: CustomColors.white),
          Expanded(
            child: Padding(
              padding: CustomSpacer.left.xs,
              child: Text(
                content,
                style: CustomTextStyle.labelSmall.copyWith(color: CustomColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: CustomSpacer.left.xs,
            child: InkWell(
              onTap: scaffoldMessenger.hideCurrentSnackBar,
              child: const Icon(Icons.close_outlined, color: CustomColors.white),
            ),
          ),
        ],
      ),
      duration: duration,
    ),
  );
}

void showCurrentlyDisabledSnackbar(BuildContext context) {
  return showSnackbar(context: context, content: 'Ops! This feature can\'t be used at this moment', isError: true);
}
