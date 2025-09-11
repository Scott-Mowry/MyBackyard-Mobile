import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/features/offers/offer_card_widget.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class TrendingOffersView extends StatefulWidget {
  const TrendingOffersView({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<TrendingOffersView> createState() => _TrendingOffersViewState();
}

class _TrendingOffersViewState extends State<TrendingOffersView> {
  late final homeController = context.read<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => BusinessAPIS.getTrendingOffers(widget.categoryId ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: 'Trending Offers',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      child: CustomPadding(
        horizontalPadding: 0.w,
        topPadding: 0,
        child: Consumer<HomeController>(
          builder: (context, homeController, _) {
            return SingleChildScrollView(
              padding: CustomSpacer.horizontal.sm,
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (homeController.offers == null || homeController.offers!.isEmpty)
                    Center(child: CustomEmptyData(title: 'No Trending Offers Found', hasLoader: false))
                  else
                    ...homeController.offers!.map(
                      (el) => Padding(padding: CustomSpacer.top.md, child: OfferCardWidget(offer: el)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
