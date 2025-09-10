import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/widgets/custom_web_view.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/features/subscription/enum/subscription_type_enum.dart';
import 'package:backyard/features/subscription/widget/subscription_tile.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/app_in_app_purchase.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class SubscriptionView extends StatefulWidget {
  final bool fromCompleteProfile;

  const SubscriptionView({super.key, this.fromCompleteProfile = false});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  late final user = context.read<UserController>().user;
  final pageController = PageController();

  StreamSubscription<List<PurchaseDetails>>? purchaseStream;
  SubscriptionTypeEnum? userSubscriptionPlan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUserSubscriptions());
    purchaseStream = AppInAppPurchase().purchaseStream.listen(purchaseStreamListener);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Choose your package',
      topSafeArea: false,
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      extendBodyBehindAppBar: false,
      child: Column(
        children: [
          Expanded(
            child: Consumer<UserController>(
              builder: (context, value, child) {
                return SingleChildScrollView(
                  child:
                      value.productDetails.length == 1
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SubscriptionTile(
                              value: value,
                              productDetails: value.productDetails[0],
                              userSubscriptionPlan: userSubscriptionPlan,
                            ),
                          )
                          : Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            runSpacing: 10,
                            children:
                                value.productDetails.mapIndexed((index, productDetails) {
                                  final subscriptionType = getSubscriptionTypeFromProductId(productDetails.id);
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: true,
                                        barrierColor: Colors.white70,
                                        context: context,
                                        builder:
                                            (c) => Scaffold(
                                              backgroundColor: Colors.transparent,
                                              body: Center(
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: SubscriptionTile(
                                                        value: value,
                                                        productDetails: productDetails,
                                                        userSubscriptionPlan: userSubscriptionPlan,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: context.maybePop,
                                                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                                                      icon: const Icon(Icons.close, size: 30, color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          width: cardWidth(index),
                                          height: 22.h,
                                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                                          decoration: BoxDecoration(
                                            color: CustomColors.primaryGreenColor,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.1), // Shadow color
                                                blurRadius: 10, // Spread of the shadow
                                                spreadRadius: 5, // Size of the shadow
                                                offset: const Offset(0, 4), // Position of the shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MyText(
                                                    title: productDetails.price,
                                                    clr: CustomColors.whiteColor,
                                                    fontWeight: FontWeight.w600,
                                                    size: 26,
                                                  ),
                                                  MyText(
                                                    title: subscriptionType!.duration,
                                                    clr: CustomColors.whiteColor.withValues(alpha: .5),
                                                    fontWeight: FontWeight.w600,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                              MyText(
                                                title: productDetails.title.split('(').firstOrNull ?? '',
                                                clr: CustomColors.whiteColor,
                                                align: TextAlign.center,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w500,
                                                size: 14,
                                                height: 1.1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.arrow_forward_rounded,
                                            color: CustomColors.whiteColor.withValues(alpha: .5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                );
              },
            ),
          ),
          if (widget.fromCompleteProfile && (user?.role == UserRoleEnum.User))
            GestureDetector(onTap: () {}, child: const Text('Skip')),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 13, color: CustomColors.black),
              children: [
                TextSpan(
                  text: '\nTerms & Conditions',
                  style: GoogleFonts.roboto(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decorationThickness: 2,
                    color: CustomColors.greenColor,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => showWebViewBottomSheet(url: termsOfUseUrl, context: context),
                ),
                TextSpan(
                  text: ' & ',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decorationThickness: 2,
                    color: CustomColors.black,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.roboto(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decorationThickness: 2,
                    color: CustomColors.greenColor,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => showWebViewBottomSheet(url: privacyPolicyUrl, context: context),
                ),
              ],
            ),
            textScaler: TextScaler.linear(1.03),
          ),
        ],
      ),
    );
  }

  Future<void> checkUserSubscriptions() async {
    try {
      final userProfile = context.read<UserController>().user!;
      await EasyLoading.show();
      if (!widget.fromCompleteProfile) {
        userSubscriptionPlan = getSubscriptionTypeFromSubId(userProfile.subId);
      }

      userProfile.role == UserRoleEnum.Business
          ? await AppInAppPurchase().fetchSubscriptions([
            SubscriptionTypeEnum.bus_basic.name,
            SubscriptionTypeEnum.bus_sub_annually.name,
            SubscriptionTypeEnum.bus_sub_monthly.name,
          ])
          : await AppInAppPurchase().fetchSubscriptions([SubscriptionTypeEnum.user_sub.name]);

      if (context.read<UserController>().productDetails.isEmpty) {
        context.read<UserController>().setProductDetails(
          userProfile.role == UserRoleEnum.Business ? defaultBusinessSubscriptionPlans : defaultUserSubscriptionPlans,
        );
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> purchaseStreamListener(events) async {
    AppInAppPurchase().handlePurchaseUpdates(events);
    for (var event in events) {
      if (event.status != PurchaseStatus.purchased) continue;

      try {
        await EasyLoading.show();
        final subscriptionType = getSubscriptionTypeFromProductId(event.productID);
        final userProfile = await getIt<UserAuthRepository>().completeProfile(
          subId: subscriptionType?.subId.toString(),
        );

        if (userProfile != null) {
          setState(() => userSubscriptionPlan = subscriptionType);
          unawaited(context.maybePop());
        }
      } finally {
        await EasyLoading.dismiss();
      }
    }
  }

  double cardWidth(int i) {
    final length = context.read<UserController>().productDetails.length;
    if (length % 2 == 0) {
      return 45.w;
    } else {
      if (i == length - 1) {
        return 93.w;
      } else {
        return 45.w;
      }
    }
  }

  @override
  void dispose() {
    purchaseStream?.cancel();
    super.dispose();
  }
}
