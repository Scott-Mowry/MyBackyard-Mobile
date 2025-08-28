import 'package:auto_route/annotations.dart';
import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/features/settings/settings_view.dart';
import 'package:backyard/features/user_profile/user_profile_view.dart';
import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Component/custom_drawer.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Service/socket_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Business/business_home.dart';
import 'package:backyard/legacy/View/Business/customers.dart';
import 'package:backyard/legacy/View/User/category.dart';
import 'package:backyard/legacy/View/User/offers.dart';
import 'package:backyard/legacy/View/User/user_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final key = GlobalKey<ScaffoldState>();
  int inActiveColor = 0XFFD2D2D2;
  int activeColor = 0XFF57BA00;

  late final business =
      (navigatorKey.currentContext?.read<UserController>().isSwitch ?? false)
          ? false
          : navigatorKey.currentContext?.read<UserController>().user?.role == UserRoleEnum.Business;

  void setIndex(int val) {
    navigatorKey.currentContext?.read<HomeController>().setIndex(val);
    setState(() {});
  }

  @override
  void initState() {
    navigatorKey.currentContext?.read<HomeController>().setGlobalKey(key);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navigatorKey.currentContext?.read<HomeController>().setIndex(0);
      SocketService.instance?.socketEmitMethod(
        eventName: 'get_user',
        eventParamaters: {'id': context.read<UserController>().user?.id?.toString()},
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer2<HomeController, UserController>(
        builder: (context, val, val2, _) {
          return Scaffold(
            key: key,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            drawer: CustomDrawer(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton:
                (!business)
                    ? null
                    : GestureDetector(
                      onTap: () {
                        if (val2.user?.subId != null && val2.user?.subId != 4) {
                          AppNavigation.navigateTo(AppRouteName.CREATE_OFFER_VIEW_ROUTE);
                        } else {
                          AppNavigation.navigateTo(
                            AppRouteName.CONTENT_SCREEN,
                            arguments: ContentRoutingArgument(
                              title: 'Subscriptions',
                              contentType: 'Subscriptions',
                              url: 'https://www.google.com/',
                            ),
                          );
                          CustomToast().showToast(message: 'You Need to Subscribe to Create an Offer.');
                        }
                      },
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(color: CustomColors.whiteColor, shape: BoxShape.circle),
                        child: Image.asset(ImagePath.add, fit: BoxFit.fitHeight, color: Color(activeColor)),
                      ),
                    ),
            bottomNavigationBar: Container(
              height: 90,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: Utils.isTablet ? 5.5.sp : 15.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, -5), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < userTabs.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        right: business ? ((i == ((businessTab.length / 2) - 1)) ? 10.w : 0) : 0,
                        left: business ? ((i == (businessTab.length / 2)) ? 10.w : 0) : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => setIndex(i),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              business ? (businessTab[i]['icon'] ?? '') : (userTabs[i]['icon'] ?? ''),
                              scale: 1,
                              fit: BoxFit.fitHeight,
                              color: Color(val.currentIndex == i ? activeColor : inActiveColor),
                              height: Utils.isTablet ? 11.sp : 22.sp,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              business ? (businessTab[i]['title'] ?? '') : (userTabs[i]['title'] ?? ''),
                              style: TextStyle(
                                color: Color(val.currentIndex == i ? activeColor : inActiveColor),
                                fontWeight: val.currentIndex == i ? FontWeight.w600 : FontWeight.w500,
                                fontSize:
                                    val.currentIndex == i
                                        ? (Utils.isTablet ? 8.sp : 14.sp)
                                        : (Utils.isTablet ? 7.sp : 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            body: (business) ? businessPages[val.currentIndex] : userPages[val.currentIndex],
            extendBody: false,
          );
        },
      ),
    );
  }

  List<Widget> userPages = <Widget>[UserHome(), const Category(), const Offers(), UserProfileView()];

  List<Widget> businessPages = <Widget>[
    const BusinessHome(),
    const Customers(),
    const SettingsView(),
    UserProfileView(isUser: true, isMe: true),
  ];

  List<Map<String, String>> userTabs = [
    {'title': 'Home', 'icon': ImagePath.homeAltered},
    {'title': 'Offers', 'icon': ImagePath.offerAltered},
    {'title': 'Saved', 'icon': ImagePath.savedOffersIcon},
    {'title': 'Profile', 'icon': ImagePath.profile},
  ];

  List<Map<String, String>> businessTab = [
    {'title': 'Home', 'icon': ImagePath.home5},
    {'title': 'Customers', 'icon': ImagePath.customers2},
    {'title': 'Settings', 'icon': ImagePath.setting2},
    {'title': 'Profile', 'icon': ImagePath.profile},
  ];
}
