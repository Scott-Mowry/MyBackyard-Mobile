import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/features/categories/categories_view.dart';
import 'package:backyard/features/customers/customers_view.dart';
import 'package:backyard/features/home/business_home_view.dart';
import 'package:backyard/features/home/user_home_view.dart';
import 'package:backyard/features/offers/offers_view.dart';
import 'package:backyard/features/settings/settings_view.dart';
import 'package:backyard/features/user_profile/user_profile_view.dart';
import 'package:backyard/legacy/Component/custom_drawer.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
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
  final key = GlobalKey<ScaffoldState>();
  int inActiveColor = 0XFFD2D2D2;
  int activeColor = 0XFF57BA00;

  late final isBusiness =
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;

  void setIndex(int val) {
    context.read<HomeController>().setIndex(val);
    setState(() {});
  }

  final userPages = <Widget>[
    const UserHomeView(wantKeepAlive: true),
    const CategoriesView(wantKeepAlive: true),
    const OffersView(wantKeepAlive: true),
    const UserProfileView(wantKeepAlive: true),
  ];

  final businessPages = <Widget>[
    const BusinessHomeView(wantKeepAlive: true),
    const Customers(wantKeepAlive: true),
    const SettingsView(wantKeepAlive: true),
    const UserProfileView(isUser: true, isMe: true, wantKeepAlive: true),
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

  @override
  void initState() {
    context.read<HomeController>().setGlobalKey(key);
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<HomeController>().setIndex(0));

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
                (!isBusiness)
                    ? null
                    : GestureDetector(
                      onTap: () async {
                        if (val2.user?.subId != null && val2.user?.subId != 4) {
                          return context.pushRoute<void>(CreateOfferRoute());
                        }

                        CustomToast().showToast(message: 'You Need to Subscribe to Create an Offer.');
                        return context.pushRoute<void>(SubscriptionRoute());
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
                        right: isBusiness ? ((i == ((businessTab.length / 2) - 1)) ? 10.w : 0) : 0,
                        left: isBusiness ? ((i == (businessTab.length / 2)) ? 10.w : 0) : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => setIndex(i),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              isBusiness ? (businessTab[i]['icon'] ?? '') : (userTabs[i]['icon'] ?? ''),
                              scale: 1,
                              fit: BoxFit.fitHeight,
                              color: Color(val.currentIndex == i ? activeColor : inActiveColor),
                              height: Utils.isTablet ? 11.sp : 22.sp,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isBusiness ? (businessTab[i]['title'] ?? '') : (userTabs[i]['title'] ?? ''),
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
            body: IndexedStack(index: val.currentIndex, children: isBusiness ? businessPages : userPages),
            extendBody: false,
          );
        },
      ),
    );
  }
}
