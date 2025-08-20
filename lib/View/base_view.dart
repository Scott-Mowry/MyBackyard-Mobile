import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

class BaseView extends StatelessWidget {
  final Widget? child, floating;
  final showAppBar;
  final String? screenTitle, screenSubtitle;
  String bgImage = ImagePath.splashImage;
  final Widget? leadingAppBar;
  final Widget? trailingAppBar;
  Function? onTapTrailing, onTapSubtitle;
  bool? extendBodyBehindAppBar;
  Color? backgroundColor, screenTitleColor, statusBarColor, appbarColor, backColor;
  final bool? bottomSafeArea,
      topSafeArea,
      showBackButton,
      showBackgroundImage,
      showBottomBar,
      resizeBottomInset,
      showDrawer;
  Function? onTapBackButton, onTapFloatingButton;
  // BottomBarController bottomBarController = Get.put(BottomBarController());
  final GlobalKey? scafoldkey;

  BaseView({
    super.key,
    this.child,
    this.screenTitle,
    this.showAppBar,
    this.floating,
    this.bgImage = ImagePath.splashImage,
    this.scafoldkey,
    this.bottomSafeArea = true,
    this.statusBarColor,
    this.onTapSubtitle,
    this.showDrawer = false,
    this.backColor,
    this.onTapBackButton,
    this.screenTitleColor,
    this.showBackButton = false,
    this.leadingAppBar,
    this.topSafeArea,
    this.screenSubtitle,
    this.showBackgroundImage = false,
    this.resizeBottomInset,
    this.onTapTrailing,
    this.appbarColor,
    this.backgroundColor,
    this.trailingAppBar,
    this.showBottomBar = false,
    this.extendBodyBehindAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? MyColors().whiteColor,
      resizeToAvoidBottomInset: resizeBottomInset ?? true,
      // key: showDrawer == true ? _scaffoldKey : null,
      // drawer:showDrawer == true ? Container(
      //   width: 400,
      //   color: Colors.red,
      // ):null,
      appBar:
          showAppBar == true
              ? AppBar(
                backgroundColor: backgroundColor ?? Colors.transparent,
                leading:
                    showBackButton == false
                        ? Padding(
                          padding: EdgeInsets.only(top: .8.h, bottom: .8.h, left: 3.w, right: 0.h),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                            child: leadingAppBar,
                          ),
                        )
                        // Padding(padding: EdgeInsets.only(top: .6.h, bottom: .6.h,left: 2.w,right: 0.h), child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(6),), child: leadingAppBar),)
                        // Padding(padding: EdgeInsets.only(top: 7, bottom: 7,left: 10,right: 0), child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(6),), child: leadingAppBar),)
                        : InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            onTapBackButton == null ? AppNavigation.navigatorPop() : onTapBackButton!();
                          },
                          splashFactory: NoSplash.splashFactory,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 1.h),
                            child: Image.asset(ImagePath.back, scale: 2, color: backColor),
                          ),
                        ),
                centerTitle: true,
                title: MyText(
                  title: screenTitle ?? '',
                  center: true,
                  line: 2,
                  size: 18,
                  toverflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  clr: screenTitleColor ?? MyColors().black,
                ),
                elevation: 0,
                actions: <Widget>[trailingAppBar ?? Container()],
              )
              : null,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          image: bgImage == '' ? null : DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
        ),
        child: SafeArea(top: topSafeArea ?? true, bottom: bottomSafeArea ?? true, child: child!),
      ),
      floatingActionButton: Padding(padding: EdgeInsets.only(bottom: 2.h), child: floating),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
