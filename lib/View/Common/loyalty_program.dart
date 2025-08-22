import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoyaltyProgram extends StatelessWidget {
  const LoyaltyProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Loyalty Program',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      // backgroundColor: Colors.white,
      child: CustomPadding(
        horizontalPadding: 0.w,
        topPadding: 0,
        child: Column(
          children: <Widget>[
            CustomPadding(
              horizontalPadding: 4.w,
              topPadding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors().primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 5, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12) + EdgeInsets.symmetric(vertical: 2.h),
                    child: Column(
                      children: [
                        MyText(
                          title: 'Rewards Coins',
                          fontWeight: FontWeight.w700,
                          center: true,
                          clr: MyColors().whiteColor,
                          size: 20,
                        ),
                        SizedBox(height: .5.h),
                        MyText(
                          title: '5000',
                          fontWeight: FontWeight.w700,
                          center: true,
                          clr: MyColors().whiteColor,
                          size: 20,
                        ),
                        SizedBox(height: 2.h),
                        Image.asset(ImagePath.coins),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  MyText(title: 'History', fontWeight: FontWeight.w600, size: 18),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                // itemCount:s.length,
                itemCount: 8,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) => HistoryTile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final bool availed;

  const HistoryTile({super.key, this.availed = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // AppNavigation.navigateTo( AppRouteName.DISCOUNT_OFFER_ROUTE);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MyColors().whiteColor,
          boxShadow: [
            BoxShadow(
              color: MyColors().container.withValues(alpha: 0.8), // Shadow color
              blurRadius: 10, // Spread of the shadow
              spreadRadius: 5, // Size of the shadow
              offset: const Offset(0, 4), // Position of the shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(title: '06', fontWeight: FontWeight.w600, size: 14),
                  MyText(title: 'Jun', fontWeight: FontWeight.w600, size: 14),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(title: 'Offer 03', fontWeight: FontWeight.w600, size: 12),
                  MyText(title: 'Successful', clr: MyColors().grey, size: 14),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(title: 'Lorum Ipsum Cafe', fontWeight: FontWeight.w600, size: 12),
                  MyText(title: 'Business Name', clr: MyColors().grey, size: 14),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(flex: 1, child: MyText(title: '+80', fontWeight: FontWeight.w600, size: 18)),
          ],
        ),
      ),
    );
  }
}
