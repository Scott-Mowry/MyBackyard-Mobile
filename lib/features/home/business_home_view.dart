import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_web_view.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/features/home/widget/widget/offer_card_widget.dart';
import 'package:backyard/features/subscription/enum/subscription_type_enum.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
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
    final bottomButtonsHeight = 46.0;
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
                      CustomAppBar(screenTitle: 'Offers', leading: MenuIcon(), bottom: 2.h),
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
                            child: OfferCardWidget(
                              offer: offer,
                              showAddress: false,
                              onTap: () => onTapOfferCard(offer),
                            ),
                          );
                        }),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                Padding(
                  padding: CustomSpacer.top.xxs + CustomSpacer.bottom.sm + CustomSpacer.horizontal.sm,
                  child: Row(
                    spacing: CustomSpacer.horizontal.xxs.horizontal,
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(25),
                          child: MyButton(
                            title: 'Scan QR',
                            height: bottomButtonsHeight,
                            onTap: () => context.pushRoute(ScanOfferRoute()),
                            bgColor: CustomColors.primaryGreenColor,
                            textColor: CustomColors.white,
                            prefixIconData: Icons.qr_code_scanner,
                            prefixIconColor: CustomColors.white,
                            prefixIconSize: 24,
                            showPrefix: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(25),
                          child: MyButton(
                            title: 'Add offer',
                            height: bottomButtonsHeight,
                            onTap: onCreateOffer,
                            bgColor: CustomColors.primaryGreenColor,
                            textColor: CustomColors.white,
                            prefixIconData: Icons.add,
                            prefixIconColor: CustomColors.white,
                            prefixIconSize: 24,
                            showPrefix: true,
                          ),
                        ),
                      ),
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

  Future<void> onTapOfferCard(Offer offer) async {
    final reload = await context.pushRoute(OfferItemRoute(offer: offer));
    if (reload == null || reload is! bool) return;
    if (reload) await loadOwnedOffers();
  }

  Future<void> onCreateOffer() async {
    final userController = context.read<UserController>();
    final subscriptionPlan = getSubscriptionTypeFromSubId(userController.user?.subId);
    if (subscriptionPlan == null || subscriptionPlan.isUserSub) {
      showSnackbar(context: context, content: 'You need to subscribe to create an offer.');
      return showWebViewBottomSheet(url: plansUrl, context: context);
    }

    final reload = await context.pushRoute(CreateOfferRoute());
    if (reload == null || reload is! bool) return;
    if (reload) await loadOwnedOffers();
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
