import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/features/subscriptions/enum/subscription_type_enum.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class InAppSubscriptionPlanTile extends StatelessWidget {
  final UserController? value;
  final ProductDetails productDetails;
  final SubscriptionTypeEnum? userSubscriptionPlan;

  const InAppSubscriptionPlanTile({
    super.key,
    required this.value,
    required this.productDetails,
    this.userSubscriptionPlan,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserController>().user;
    final subscriptionType = getSubscriptionTypeFromProductId(productDetails.id);

    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.primaryGreenColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      title: productDetails.price,
                      clr: CustomColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      size: 30,
                    ),
                    MyText(
                      title: subscriptionType!.duration,
                      clr: CustomColors.whiteColor.withValues(alpha: .5),
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                  ],
                ),
                MyText(
                  title: productDetails.title.split('(').firstOrNull ?? '',
                  clr: CustomColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  size: 16,
                  height: 1.1,
                ),
              ],
            ),
          ),
          if (productDetails.description.isNotEmpty)
            Padding(
              padding: CustomSpacer.horizontal.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),
                  MyText(title: 'Description:', clr: CustomColors.black, fontWeight: FontWeight.w600, size: 15),
                  MyText(title: productDetails.description, clr: CustomColors.black, align: TextAlign.left, size: 14),
                ],
              ),
            ),
          SizedBox(height: 2.h),
          for (int i = 0; i < subscriptionType.textTopics.length; i++)
            Padding(
              padding: CustomSpacer.horizontal.md + CustomSpacer.top.xxs,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: CustomColors.primaryGreenColor),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: MyText(
                      title: subscriptionType.textTopics[i],
                      size: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.3,
                      clr: CustomColors.black,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 1.h),
          Padding(
            padding: CustomSpacer.horizontal.md + CustomSpacer.top.md,
            child: MyButton(
              onTap: () async {
                if (userSubscriptionPlan?.name == productDetails.id) {
                  return CustomToast().showToast(message: 'Already Subscribed');
                }

                await AppInAppPurchase().buySubscription(productDetails);
              },
              bgColor:
                  user?.subId == null
                      ? Colors.black
                      : (userSubscriptionPlan?.name == productDetails.id)
                      ? Colors.black
                      : Colors.black.withValues(alpha: .5),
              title: (userSubscriptionPlan?.name == productDetails.id) ? 'Subscribed' : 'Subscribe',
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
