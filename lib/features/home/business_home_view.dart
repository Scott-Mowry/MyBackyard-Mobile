import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/features/home/widget/widget/offer_card_widget.dart';
import 'package:backyard/features/subscription/enum/subscription_type_enum.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/Widget/search_tile.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class BusinessHomeView extends StatefulWidget {
  final bool wantKeepAlive;

  const BusinessHomeView({super.key, this.wantKeepAlive = false});

  @override
  State<BusinessHomeView> createState() => _BusinessHomeViewState();
}

class _BusinessHomeViewState extends State<BusinessHomeView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  String searchQuery = '';
  final ownedOffers = <Offer>[];
  final searchedOffers = <Offer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadOwnedOffers());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trailingBtnSize = 32.0;
    final offersList = searchQuery.isNotEmpty ? searchedOffers : ownedOffers;

    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        topSafeArea: false,
        child: CustomRefresh(
          onRefresh: loadOwnedOffers,
          child: CustomPadding(
            topPadding: 0.h,
            horizontalPadding: 0.w,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.whiteColor,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 7.h) + EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        screenTitle: 'Offers',
                        leading: MenuIcon(),
                        trailing: Row(
                          children: [
                            Padding(
                              padding: CustomSpacer.right.xs,
                              child: GestureDetector(
                                onTap: () => context.pushRoute(ScanOfferRoute()),
                                child: Container(
                                  height: trailingBtnSize,
                                  width: trailingBtnSize,
                                  decoration: BoxDecoration(color: CustomColors.whiteColor, shape: BoxShape.circle),
                                  child: Image.asset(
                                    ImagePath.scan2,
                                    fit: BoxFit.fitHeight,
                                    color: CustomColors.primaryGreenColor,
                                    scale: 3.0,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onCreateOffer,
                              child: Container(
                                height: trailingBtnSize,
                                width: trailingBtnSize,
                                decoration: BoxDecoration(color: CustomColors.whiteColor, shape: BoxShape.circle),
                                child: Image.asset(
                                  ImagePath.add,
                                  fit: BoxFit.fitHeight,
                                  color: CustomColors.primaryGreenColor,
                                  scale: 3.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        bottom: 2.h,
                      ),
                      SearchTile(showFilter: false, onChange: searchOffer),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                if (ownedOffers.isEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Center(child: CustomEmptyData(title: 'No Offers Found', hasLoader: false)),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ...offersList.map((offer) {
                          return Padding(
                            padding: CustomSpacer.top.md,
                            child: OfferCardWidget(offer: offer, showAddress: false),
                          );
                        }),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onCreateOffer() async {
    final userController = context.read<UserController>();
    final subscriptionPlan = getSubscriptionTypeFromSubId(userController.user?.subId);
    if (subscriptionPlan == null || subscriptionPlan.isBusinessSubBasic || subscriptionPlan.isUserSub) {
      showSnackbar(context: context, content: 'You need to subscribe to monthly or yearly plans to create an offer.');
      return context.pushRoute<void>(SubscriptionRoute());
    }

    return context.pushRoute<void>(CreateOfferRoute());
  }

  Future<void> loadOwnedOffers() async {
    final offers = await BusinessAPIS.getSavedOrOwnedOffers();
    ownedOffers.clear();
    ownedOffers.addAll(offers);
    setState(() {});
  }

  void searchOffer(String val) {
    searchQuery = val;
    final offerResults =
        ownedOffers.where((element) => ((element.title ?? '').toLowerCase()).contains(val.toLowerCase())).toList();

    searchedOffers.clear();
    searchedOffers.addAll(offerResults);
    setState(() {});
  }
}
