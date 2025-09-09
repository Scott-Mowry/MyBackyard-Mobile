import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  required String routeName,
  double? maxHeightFactor,
  double? height,
}) async {
  if (maxHeightFactor != null) assert(height == null);
  if (height != null) assert(maxHeightFactor == null);

  final screenSize = MediaQuery.sizeOf(context);
  final childWidget = Container(height: height, width: screenSize.width, color: CustomColors.white, child: child);

  const borderRadius = const BorderRadius.vertical(top: Radius.circular(CustomRadius.m));
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: CustomColors.white,
    routeSettings: RouteSettings(name: routeName),
    shape: const RoundedRectangleBorder(borderRadius: borderRadius),
    builder:
        (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: ClipRRect(
            borderRadius: borderRadius,
            child:
                maxHeightFactor == null
                    ? childWidget
                    : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: screenSize.height * maxHeightFactor),
                      child: childWidget,
                    ),
          ),
        ),
  );
}
