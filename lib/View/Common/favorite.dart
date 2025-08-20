import 'dart:io';
import 'package:backyard/Arguments/profile_screen_arguments.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/View/User/offers.dart';
import 'package:backyard/View/Widget/search_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class Favorite extends StatefulWidget {
  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> items = ['Businesses', 'Offers & Discounts'];
  String i = 'Businesses';
  List<String> img = [
    ImagePath.random1,
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
    ImagePath.random2,
    ImagePath.random3,
    ImagePath.random1,
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView(
        bgImage: '',
        showAppBar: false,
        topSafeArea: false,
        bottomSafeArea: false,
        // backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 0.w,
          topPadding: 0,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: MyColors().whiteColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      blurRadius: 10, // Spread of the shadow
                      spreadRadius: 5, // Size of the shadow
                      offset: const Offset(0, 4), // Position of the shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: 7.h) +
                    EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomAppBar(
                      screenTitle: "Favorites",
                      leading: BackButton(),
                      bottom: 2.h,
                    ),
                    SearchTile(
                      showFilter: false,
                      // search: location,
                      onTap: () async {
                        // await getAddress(context);
                      },
                      onChange: (v) async {
                        // await getAddress(context);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Row(
                  children: [
                    sessionButton(title: items[0]),
                    SizedBox(
                      width: 3.w,
                    ),
                    sessionButton(title: items[1]),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              if (i == items[0]) ...[
                Expanded(
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 3.w,
                        mainAxisSpacing: 3.w,
                      ),
                      // gridDelegate: _monthPickerGridDelegate,
                      itemCount: img.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      itemBuilder: (BuildContext ctx, index) {
                        return businessTile(context: context, img: img[index]);
                      }),
                ),
              ],
              if (i == items[1]) ...[
                Expanded(
                  child: ListView.builder(
                      // itemCount:s.length,
                      itemCount: 8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) => OfferTile()),
                ),
              ],
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }

  sessionButton({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? MyColors().primaryColor : MyColors().whiteColor,
        borderColor: MyColors().primaryColor,
        textColor: i == title ? null : MyColors().primaryColor,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }

  businessTile({String? img, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(right: 0.w),
      child: GestureDetector(
        onTap: () {
          // HomeController.i.endUser.value=u??User();
          AppNavigation.navigateTo(AppRouteName.USER_PROFILE_ROUTE,
              arguments: ProfileScreenArguments(isMe: false, isUser: false));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              img ?? ImagePath.random1,
              scale: 1,
            ),
            SizedBox(
              height: 1.h,
            ),
            MyText(title: 'Business Name')
          ],
        ),
      ),
    );
  }
}
