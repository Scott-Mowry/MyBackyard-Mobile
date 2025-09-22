import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/features/home/widget/widget/offer_card_widget.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/View/Widget/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersView extends StatefulWidget {
  final bool wantKeepAlive;

  const OffersView({super.key, this.wantKeepAlive = false});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> with AutomaticKeepAliveClientMixin {
  late final userController = context.read<UserController>();

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  String searchQuery = '';
  final savedOffers = <Offer>[];
  final searchedOffers = <Offer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadOwnedOffers());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final offersList = searchQuery.isNotEmpty ? searchedOffers : savedOffers;

    return CustomRefresh(
      onRefresh: loadOwnedOffers,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        padding: CustomSpacer.horizontal.sm + CustomSpacer.top.xl,
        child: Column(
          children: [
            SearchTile(showFilter: false, onChange: searchOffer),
            if (offersList.isEmpty)
              Center(child: CustomEmptyData(title: 'No Offers Found', hasLoader: false))
            else
              ...offersList.map((offer) {
                return Padding(padding: CustomSpacer.top.md, child: OfferCardWidget(offer: offer));
              }),
          ],
        ),
      ),
    );
  }

  Future<void> loadOwnedOffers() async {
    final offers = await BusinessAPIS.getSavedOrOwnedOffers(isSwitch: userController.isSwitch);
    savedOffers.clear();
    savedOffers.addAll(offers);
    setState(() {});
  }

  void searchOffer(String val) {
    searchQuery = val;
    final offerResults =
        savedOffers.where((element) => ((element.title ?? '').toLowerCase()).contains(val.toLowerCase())).toList();

    searchedOffers.clear();
    searchedOffers.addAll(offerResults);
    setState(() {});
  }
}
