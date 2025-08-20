import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_icon_container.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Controller/home_controller.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key});
  @override
  Widget build(BuildContext context) {
    // return Padding(padding: EdgeInsets.only(top: 1.h, bottom: 1.h,left: 4.w,right: 0.h), child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(6),), child: IconContainer(image: ImagePath.menuIcon, onTap: (){AuthController.i.zoom.toggle?.call();},size: 6.w,padding: 1.8.w,)),);
    return Consumer<HomeController>(
      builder: (context, val, _) {
        return IconContainer(
          image: ImagePath.menuIcon,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            val.drawerKey?.currentState?.openDrawer();
          },
        );
      },
    );
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // return Padding(padding: EdgeInsets.only(top: 7, bottom: 7,left: 7,right: 10), child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(6),), child: IconContainer(image: ImagePath.notificationIcon, onTap: (){},size: 7.w,padding: 2.2.w,)),);
    // return Padding(padding: EdgeInsets.only(top: .6.h, bottom: .6.h,left: 4.w,right: 4.w), child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(6),), child: IconContainer(image: ImagePath.notificationIcon, onTap: (){},size: 7.w,padding: 2.2.w,)),);
    return IconContainer(
      image: ImagePath.notificationIcon,
      onTap: () {
        AppNavigation.navigateTo(AppRouteName.NOTIFICATION_SCREEN_ROUTE);
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
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          arguments: ScreenArguments(fromEdit: true),
        );
      },
    );
  }
}

class ChatIcon extends StatelessWidget {
  ChatIcon({super.key, this.onTap});
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return IconContainer(
      image: ImagePath.chatIcon,
      onTap: () {
        if (onTap != null) {
          onTap?.call();
        } else {
          AppNavigation.navigateTo(AppRouteName.CHAT_SCREEN_ROUTE);
        }
      },
    );
  }
}

class CustomBackButton extends StatelessWidget {
  CustomBackButton({super.key, this.color});
  Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigatorPop();
      },
      child: Icon(Icons.arrow_back, color: Colors.black),
      // Image.asset(ImagePath.back,scale: 2,)
    );
  }
}

class FilterIcon extends StatelessWidget {
  FilterIcon({super.key, this.onTap});
  Function? onTap;
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
  CustomAppBar({
    super.key,
    this.horizontal = 0,
    this.top = 0,
    this.titleColor,
    this.bottom = 0,
    this.screenTitle = '',
    this.leading,
    this.trailing,
  });
  double horizontal, top, bottom;
  String screenTitle;
  Color? titleColor;
  Widget? leading, trailing;
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
                clr: titleColor ?? MyColors().black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
