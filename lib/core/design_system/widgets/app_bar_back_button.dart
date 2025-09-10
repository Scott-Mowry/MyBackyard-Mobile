import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  final Color iconColor;

  const AppBarBackButton({super.key, this.iconColor = CustomColors.black});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(CustomRadius.s),
      onTap: () async {
        final didPop = await context.maybePop();
        if (!didPop) return context.replaceRoute<void>(LandingRoute());
      },
      child: Icon(Icons.chevron_left, color: iconColor),
    );
  }
}
