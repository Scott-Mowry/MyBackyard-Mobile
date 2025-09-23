import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/features/customers/customers_view.dart';
import 'package:backyard/features/home/business_home_view.dart';
import 'package:backyard/features/home/user_home_view.dart';
import 'package:backyard/features/offers/offers_view.dart';
import 'package:backyard/features/user_profile/user_profile_view.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
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
  final _pageController = PageController();
  final key = GlobalKey<ScaffoldState>();

  int inActiveColor = 0XFFD2D2D2;
  int activeColor = 0XFF57BA00;

  late final isBusiness =
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;

  void setIndex(int index) {
    _pageController.jumpToPage(index);
    context.read<HomeController>().setIndex(index);
    setState(() {});
  }

  final userPages = <Widget>[
    const UserHomeView(wantKeepAlive: true),
    const OffersView(wantKeepAlive: true),
    const UserProfileView(wantKeepAlive: true),
  ];

  final businessPages = <Widget>[
    const BusinessHomeView(wantKeepAlive: true),
    const Customers(wantKeepAlive: true),
    const UserProfileView(isUser: true, isMe: true, wantKeepAlive: true),
  ];

  List<Map<String, String>> userTabs = [
    {'title': 'Home', 'icon': ImagePath.homeAltered},
    {'title': 'Saved', 'icon': ImagePath.savedOffersIcon},
    {'title': 'Profile', 'icon': ImagePath.profile},
  ];

  List<Map<String, String>> businessTab = [
    {'title': 'Offers', 'icon': ImagePath.offerAltered},
    {'title': 'Customers', 'icon': ImagePath.customers2},
    {'title': 'Profile', 'icon': ImagePath.profile},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<HomeController>().setIndex(0));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<HomeController>(
        builder: (context, homeController, _) {
          final isUserHome = !isBusiness && homeController.currentIndex == 0;
          return Scaffold(
            key: key,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              height: 90,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: Utils.isTablet ? 5.5.sp : 15.sp),
              decoration:
                  isUserHome
                      ? null
                      : BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, -5), blurRadius: 10)],
                      ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < (isBusiness ? businessTab : userTabs).length; i++)
                    GestureDetector(
                      onTap: () => setIndex(i),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            isBusiness ? (businessTab[i]['icon'] ?? '') : (userTabs[i]['icon'] ?? ''),
                            scale: 1,
                            fit: BoxFit.fitHeight,
                            color: Color(homeController.currentIndex == i ? activeColor : inActiveColor),
                            height: Utils.isTablet ? 8.sp : 22.sp,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isBusiness ? (businessTab[i]['title'] ?? '') : (userTabs[i]['title'] ?? ''),
                            style: TextStyle(
                              color: Color(homeController.currentIndex == i ? activeColor : inActiveColor),
                              fontWeight: homeController.currentIndex == i ? FontWeight.w600 : FontWeight.w500,
                              fontSize:
                                  homeController.currentIndex == i
                                      ? (Utils.isTablet ? 8.sp : 14.sp)
                                      : (Utils.isTablet ? 7.sp : 12.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: isBusiness ? businessPages : userPages,
            ),
            extendBody: false,
          );
        },
      ),
    );
  }
}
