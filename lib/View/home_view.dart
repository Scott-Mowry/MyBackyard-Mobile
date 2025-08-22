import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Service/socket_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/Business/business_home.dart';
import 'package:backyard/View/Business/customers.dart';
import 'package:backyard/View/Common/Settings/settings.dart';
import 'package:backyard/View/Common/user_profile.dart';
import 'package:backyard/View/User/category.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/User/user_home.dart';
import 'package:backyard/legacy/Arguments/content_argument.dart';
import 'package:backyard/legacy/Component/custom_drawer.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
          : navigatorKey.currentContext?.read<UserController>().user?.role == Role.Business;

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
    // TODO: implement initState
    super.initState();
  }

  /// Controller to handle bottom nav bar and also handles initial page
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
      },
      child: Consumer2<HomeController, UserController>(
        builder: (context, val, val2, _) {
          return Scaffold(
            key: key,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            // extendBodyBehindAppBar: true,
            drawer: CustomDrawer(),

            // body: GetBuilder<HomeController>(
            //     builder: (context) {
            //       return business? (businessPages[h.currentval.currentIndex.value]):userPages[h.currentval.currentIndex.value];
            //     }
            // ),
            // bottomNavigationBar: CustomBottomBar(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton:
                (!business)
                    ? null
                    : GestureDetector(
                      onTap: () {
                        if (val2.user?.subId != null && val2.user?.subId != 4) {
                          AppNavigation.navigateTo(AppRouteName.CREATE_OFFER_ROUTE);
                        } else {
                          // AppNavigation.navigateTo(
                          //     AppRouteName.SUBSCRIPTION_SCREEN_ROUTE);
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
                        decoration: BoxDecoration(color: MyColors().whiteColor, shape: BoxShape.circle),
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

            // :
            // PersistentTabView(
            //     context,
            //     controller: val.homeBottom,
            //     screens: businessPages,
            //     // (trainer? (trainerPages[h.currentval.currentIndex.value]):traineePages[h.currentval.currentIndex.value]),
            //     items: businessTab,
            //     confineToSafeArea: false,
            //     navBarHeight: 65,
            //     stateManagement: false,
            //     backgroundColor:
            //         Colors.white, // Customize the background color
            //     handleAndroidBackButtonPress: true,
            //     resizeToAvoidBottomInset: false,
            //     decoration: NavBarDecoration(
            //       borderRadius: BorderRadius.circular(0.0),
            //       colorBehindNavBar: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withValues(alpha: 0.2), // Shadow color
            //           blurRadius: 10, // Spread of the shadow
            //           spreadRadius: 5, // Size of the shadow
            //           offset: const Offset(0, 4), // Position of the shadow
            //         ),
            //       ],
            //     ),
            //     bottomScreenMargin: 75,
            //     padding: EdgeInsets.only(top: 0, bottom: 10),
            //     // margin: const EdgeInsets.symmetric(vertical: 50), // Adjust the margin if needed
            //     navBarStyle: NavBarStyle.style15, // Set the style to style15
            //   ),
            extendBody: false,
          );
        },
      ),
    );
  }

  List<Widget> userPages = <Widget>[
    UserHome(),
    const Category(),
    // ScanQR(),
    const Offers(),
    UserProfile(),
  ];
  List<Widget> businessPages = <Widget>[
    const BusinessHome(),
    const Customers(),
    // CreateOffer(),
    const Settings(),
    UserProfile(isUser: true, isMe: true),
  ];

  // List<PersistentBottomNavBarItem> userTab = <PersistentBottomNavBarItem>[
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.home2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.home, scale: 1),
  //       title: 'Home',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.offer2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.offers, scale: 1),
  //       title: 'Offers',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   // PersistentBottomNavBarItem(icon: Image.asset(ImagePath.scan,scale: 1), title: '',activeColorSecondary: MyColors().primaryColor,activeColorPrimary: MyColors().whiteColor,contentPadding: 50,iconSize: 40),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.category2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.savedOffersIcon, scale: 1),
  //       title: 'Saved',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.profile2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.profile, scale: 1),
  //       title: 'Profile',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  // ];
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
  // List<PersistentBottomNavBarItem> businessTab = <PersistentBottomNavBarItem>[
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.home5, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.home4, scale: 1),
  //       title: 'Home',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.customers2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.customers, scale: 1),
  //       title: 'Customers',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.add, scale: 2),
  //       title: '',
  //       activeColorSecondary: MyColors().primaryColor,
  //       activeColorPrimary: MyColors().whiteColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.setting2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.settings, scale: 1),
  //       title: 'Settings',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  //   PersistentBottomNavBarItem(
  //       icon: Image.asset(ImagePath.profile2, scale: 1),
  //       inactiveIcon: Image.asset(ImagePath.profile, scale: 1),
  //       title: 'Profile',
  //       activeColorPrimary: MyColors().primaryColor,
  //       activeColorSecondary: MyColors().primaryColor),
  // ];

  Future<bool> onWillPop(context) async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }
}
