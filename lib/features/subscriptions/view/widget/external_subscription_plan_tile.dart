import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/core/helper/string_helper.dart';
import 'package:backyard/features/subscriptions/model/subscription_plan_model.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExternalSubscriptionPlanTile extends StatelessWidget {
  final SubscriptionPlanModel subscriptionPlan;
  final int? userSubscribedPlanId;

  const ExternalSubscriptionPlanTile({super.key, required this.subscriptionPlan, required this.userSubscribedPlanId});

  @override
  Widget build(BuildContext context) {
    final isSubscribedToThisPlan = userSubscribedPlanId == subscriptionPlan.id;
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
                      title: '\$${subscriptionPlan.price!}',
                      clr: CustomColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      size: 30,
                    ),
                    Padding(
                      padding: CustomSpacer.left.xs,
                      child: MyText(
                        title: subscriptionPlan.billingCycle.capitalizeFirst,
                        clr: CustomColors.whiteColor.withValues(alpha: .5),
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                MyText(
                  title: subscriptionPlan.name,
                  clr: CustomColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  size: 16,
                  height: 1.1,
                ),
              ],
            ),
          ),
          if (subscriptionPlan.description != null && subscriptionPlan.description!.isNotEmpty)
            Padding(
              padding: CustomSpacer.horizontal.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),
                  MyText(title: 'Description:', clr: CustomColors.black, fontWeight: FontWeight.w600, size: 15),
                  MyText(
                    title: subscriptionPlan.description!,
                    clr: CustomColors.black,
                    align: TextAlign.left,
                    size: 14,
                  ),
                ],
              ),
            ),
          SizedBox(height: 2.h),
          Spacer(flex: 1),
          for (int i = 0; i < subscriptionPlan.subPoints.length; i++)
            Padding(
              padding: CustomSpacer.horizontal.md + CustomSpacer.top.xxs,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: CustomColors.primaryGreenColor),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: MyText(
                      title: subscriptionPlan.subPoints[i],
                      size: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.3,
                      clr: CustomColors.black,
                    ),
                  ),
                ],
              ),
            ),
          Spacer(flex: 1),
          Padding(
            padding: CustomSpacer.horizontal.md + CustomSpacer.vertical.md,
            child: MyButton(
              onTap: () async {
                if (isSubscribedToThisPlan) {
                  return showSnackbar(context: context, content: 'Already subscribed to this plan!');
                }

                // TODO(DavidGrunheidt): continue...
              },
              bgColor:
                  userSubscribedPlanId == null
                      ? Colors.black
                      : isSubscribedToThisPlan
                      ? Colors.black
                      : Colors.black.withValues(alpha: .5),
              title: isSubscribedToThisPlan ? 'Subscribed' : 'Subscribe',
            ),
          ),
        ],
      ),
    );
  }
}
