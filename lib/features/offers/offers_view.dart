import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/features/offers/offer_card_widget.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersView extends StatefulWidget {
  final bool wantKeepAlive;

  const OffersView({super.key, this.wantKeepAlive = false});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> with AutomaticKeepAliveClientMixin {
  late final homeController = context.read<HomeController>();
  late final userController = context.read<UserController>();

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => BusinessAPIS.getSavedOrOwnedOffers(isSwitch: userController.isSwitch),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeController>(
      builder: (context, homeController, _) {
        return SingleChildScrollView(
          padding: CustomSpacer.horizontal.sm + CustomSpacer.top.xlg,
          child: Column(
            children: [
              if (homeController.offers == null || homeController.offers!.isEmpty)
                Center(child: CustomEmptyData(title: 'No Offers Found', hasLoader: false))
              else
                ...homeController.offers!.map((offer) {
                  return Padding(padding: CustomSpacer.top.md, child: OfferCardWidget(offer: offer));
                }),
            ],
          ),
        );
      },
    );
  }
}
