import 'dart:io';
import 'dart:ui';

import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_refresh.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/auth_apis.dart';
import 'package:backyard/Service/general_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/Widget/Dialog/profile_complete_dialog.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  // List<MenuModel> categories = [
  int i = 999;

  List<int> selected = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getCategories();
      setLoading(false);
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> getCategories() async {
    await GeneralAPIS.getCategories();
  }

  void setLoading(bool val) {
    context.read<HomeController>().setLoading(val);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Select Business Categories',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      child: CustomRefresh(
        onRefresh: () async {
          await getCategories();
        },
        child: CustomPadding(
          horizontalPadding: 4.w,
          topPadding: 0,
          child: Consumer<HomeController>(
            builder: (context, val, _) {
              return val.loading
                  ? Center(child: CircularProgressIndicator(color: MyColors().primaryColor))
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 3.w,
                            mainAxisSpacing: 3.w,
                          ),
                          // gridDelegate: _monthPickerGridDelegate,
                          itemCount: val.categories?.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (ctx, index) {
                            return Stack(
                              children: [
                                CustomImage(
                                  width: 100.w,
                                  height: 20.h,
                                  borderRadius: BorderRadius.circular(10),
                                  url: val.categories?[index].categoryIcon,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (selected.contains(index)) {
                                      selected.remove(index);
                                      // i = 999;
                                    } else {
                                      selected.add(index);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF183400).withValues(alpha: .8),
                                          spreadRadius: 0,
                                          blurRadius: 0,
                                          offset: Offset(0, 0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              selected.contains(index)
                                                  ? Icons.check_circle_rounded
                                                  : Icons.circle_outlined,
                                              color: i == index ? MyColors().primaryColor : MyColors().whiteColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        MyText(
                                          title: val.categories?[index].categoryName ?? '',
                                          clr: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 16,
                                          center: true,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.transparent,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 2.h),
                      MyButton(
                        title: 'Next',
                        onTap: () {
                          onSubmit(val);
                        },
                      ),
                      SizedBox(height: 2.h),
                    ],
                  );
            },
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(HomeController val) async {
    if (
    // i == 999
    selected.isEmpty) {
      CustomToast().showToast(message: 'Select category first');
    } else {
      final userController = context.read<UserController>();
      userController.setCategory(val.categories?[selected.first].id);
      final user = userController.user;
      AppNetwork.loadingProgressIndicator();
      final result = await AuthAPIS.completeProfile(
        firstName: user?.name,
        lastName: user?.lastName,
        description: user?.description,
        // zipCode: user?.zipCode,
        address: user?.address,
        lat: user?.latitude,
        long: user?.longitude,
        email: user?.email,
        categoryId: user?.categoryId,
        role: Role.Business.name,
        phone: user?.phone,
        days: user?.days,
        image: File(user?.profileImage ?? ''),
      );
      AppNavigation.navigatorPop();
      if (result) {
        completeDialog(
          onTap: () {
            AppNavigation.navigateToRemovingAll(AppRouteName.HOME_SCREEN_ROUTE);
          },
        );
      }
      // AppNavigation.navigateTo(AppRouteName.SUBSCRIPTION_SCREEN_ROUTE,
      //     arguments: ScreenArguments(fromCompleteProfile: true));
      // AppNavigation.navigateToRemovingAll(context, AppRouteName.HOME_SCREEN_ROUTE,);
    }
  }

  Future completeDialog({required Function onTap}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
              content: ProfileCompleteDialog(
                onYes: (v) {
                  onTap();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
