import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/features/offers/offers_view.dart';
import 'package:backyard/features/subscription/enum/subscription_type_enum.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
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
  TextEditingController s = TextEditingController();
  late final homeController = context.read<HomeController>();
  String search = '';

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => BusinessAPIS.getSavedOrOwnedOffers());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        topSafeArea: false,
        child: CustomRefresh(
          onRefresh: BusinessAPIS.getSavedOrOwnedOffers,
          child: Consumer2<UserController, HomeController>(
            builder: (context, val, val2, _) {
              return CustomPadding(
                topPadding: 0.h,
                horizontalPadding: 0.w,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.whiteColor,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2), // Shadow color
                            blurRadius: 10, // Spread of the shadow
                            spreadRadius: 5, // Size of the shadow
                            offset: const Offset(0, 4), // Position of the shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 7.h) + EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomAppBar(
                            screenTitle: 'Home',
                            leading: MenuIcon(),
                            trailing: GestureDetector(
                              onTap: onCreateOffer,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(color: CustomColors.whiteColor, shape: BoxShape.circle),
                                child: Image.asset(
                                  ImagePath.add,
                                  fit: BoxFit.fitHeight,
                                  color: CustomColors.primaryGreenColor,
                                  scale: 3.0,
                                ),
                              ),
                            ),
                            bottom: 2.h,
                          ),
                          SearchTile(
                            showFilter: false,
                            onChange: (v) {
                              search = v;
                              val2.searchOffer(v);
                            },
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if ((val2.offers ?? []).isEmpty)
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
                      (search.isNotEmpty ? offerList(val2.searchOffers ?? []) : offerList(val2.offers ?? [])),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget offerList(List<Offer> val) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          for (int index = 0; index < val.length; index++) OfferTile(offer: val[index]),
          SizedBox(height: 5.h),
        ],
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
}
