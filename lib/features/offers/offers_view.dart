import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        topSafeArea: false,
        bottomSafeArea: false,
        child: CustomRefresh(
          onRefresh: () async {},
          child: Consumer<HomeController>(
            builder: (context, val, _) {
              return CustomPadding(
                topPadding: 0,
                horizontalPadding: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.whiteColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15), // Shadow color
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
                          CustomAppBar(screenTitle: 'Saved', leading: MenuIcon(), bottom: 2.h),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    if (val.offers == null || val.offers!.isEmpty)
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
                      offerList(val.offers ?? []),
                    SizedBox(height: 2.h),
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
          for (int index = 0; index < val.length; index++) OfferTile(offer: val[index], fromSaved: true),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}

class OfferTile extends StatelessWidget {
  final int? index;
  final Offer? offer;
  final bool fromSaved;
  final bool availed;

  const OfferTile({super.key, this.index, this.fromSaved = false, this.offer, this.availed = false});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeController, UserController>(
      builder: (context, homeController, userController, child) {
        final businesses = userController.businessesList;
        final offerBusiness = offer == null ? null : businesses.firstWhereOrNull((el) => el.id == offer?.userId);
        print('offerBusiness ${offerBusiness?.address}');
        return GestureDetector(
          onTap: () => context.pushRoute(DiscountOffersRoute(offer: offer, fromSaved: fromSaved)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: CustomColors.container.withValues(alpha: 0.8),
                  blurRadius: 4,
                  spreadRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 1.5.h, top: 1.5.h),
            child: Row(
              children: [
                CustomImage(width: 20.w, fit: BoxFit.cover, borderRadius: BorderRadius.circular(10), url: offer?.image),
                Expanded(
                  child: Padding(
                    padding: CustomSpacer.left.xs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 26.w),
                              child: Text(
                                offer?.title ?? '',
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (offer?.category?.categoryName != null && offer!.category!.categoryName!.isNotEmpty)
                              Padding(
                                padding: CustomSpacer.left.xs,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 24.w),
                                  child: Container(
                                    padding: CustomSpacer.horizontal.xs + CustomSpacer.vertical.xxs,
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryGreenColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      offer!.category!.categoryName?.split(' ').firstOrNull ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: CustomTextStyle.labelSmall.copyWith(color: CustomColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            if (availed) ...[
                              Padding(
                                padding: CustomSpacer.left.xs,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryGreenColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(6) + EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    children: [
                                      Image.asset(ImagePath.coins, color: CustomColors.whiteColor, scale: 3),
                                      MyText(title: '  500', clr: CustomColors.whiteColor, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: CustomSpacer.left.xs,
                                child: MyText(
                                  title: '\$${offer?.actualPrice?.toStringAsFixed(2) ?? ""}   ',
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  clr: CustomColors.grey,
                                  cut: true,
                                ),
                              ),
                              MyText(
                                title: '\$${offer?.discountPrice?.toStringAsFixed(2) ?? ""}',
                                fontWeight: FontWeight.w600,
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                        if (offer?.address != null && offer!.address!.isNotEmpty)
                          Padding(
                            padding: CustomSpacer.top.xs,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      ImagePath.location,
                                      color: CustomColors.primaryGreenColor,
                                      height: 18,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Padding(
                                      padding: CustomSpacer.left.xxs,
                                      child: Text(
                                        offer?.address ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: CustomSpacer.top.xxs,
                          child: Row(
                            children: [
                              if (offer?.shortDetail != null && offer!.shortDetail!.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    offer!.shortDetail!,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              if (availed) ...[
                                SizedBox(width: 2.w),
                                MyText(
                                  title: 'Received',
                                  size: 14,
                                  fontWeight: FontWeight.w600,
                                  clr: CustomColors.primaryGreenColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
              ],
            ),
          ),
        );
      },
    );
  }
}
