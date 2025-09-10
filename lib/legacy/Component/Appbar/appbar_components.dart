import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_icon_container.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, val, _) {
        return IconContainer(
          image: ImagePath.menuIcon,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.pushRoute(SettingsRoute());
          },
        );
      },
    );
  }
}

class EditIcon extends StatelessWidget {
  const EditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      image: ImagePath.editProfile,
      onTap: () => context.pushRoute(ProfileSetupRoute(editProfile: true)),
    );
  }
}

class FilterIcon extends StatelessWidget {
  final Function? onTap;

  const FilterIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      image: ImagePath.filterIcon,
      onTap: () {
        if (onTap != null) {
          onTap?.call();
        }
      },
      padding: 3.4.w,
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final double horizontal, top, bottom;
  final String screenTitle;
  final Color? titleColor;
  final Widget? leading, trailing;

  const CustomAppBar({
    super.key,
    this.horizontal = 0,
    this.top = 0,
    this.titleColor,
    this.bottom = 0,
    this.screenTitle = '',
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal) + EdgeInsets.only(top: top, bottom: bottom),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [leading ?? SizedBox(), trailing ?? SizedBox()],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: MyText(
                title: screenTitle,
                center: true,
                line: 2,
                size: Utils.isTablet ? 20 : 18,
                toverflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                clr: titleColor ?? CustomColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
