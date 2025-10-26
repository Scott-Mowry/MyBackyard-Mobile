import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:flutter/material.dart';

class ScreenInitError extends StatelessWidget {
  final VoidCallback onTryAgain;
  final bool allowRetry;
  final String initErrorReason;

  const ScreenInitError({super.key, required this.allowRetry, required this.onTryAgain, required this.initErrorReason});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CustomSpacer.all.md,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(initErrorReason, textAlign: TextAlign.center)],
        ),
      ),
    );
  }
}
