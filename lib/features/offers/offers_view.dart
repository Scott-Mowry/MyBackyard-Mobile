import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
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
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/base_view.dart';
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
      (_) => BusAPIS.getSavedOrOwnedOffers(isSwitch: userController.isSwitch),
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
          for (int index = 0; index < val.length; index++) OfferTile(model: val[index], fromSaved: true),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}

class OfferTile extends StatelessWidget {
  final int? index;
  final Offer? model;
  final bool fromSaved;
  final bool availed;

  const OfferTile({super.key, this.index, this.fromSaved = false, this.model, this.availed = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, val, _) {
        return GestureDetector(
          onTap: () => context.pushRoute(DiscountOffersRoute(model: model, fromSaved: fromSaved)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: CustomColors.container.withValues(alpha: 0.8), // Shadow color
                  blurRadius: 4, // Spread of the shadow
                  spreadRadius: 4, // Size of the shadow
                  offset: const Offset(0, 0), // Position of the shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 1.5.h, top: 1.5.h),
            child: Row(
              children: [
                // Image.asset(
                //   ImagePath.random,
                //   scale: 2,
                //   fit: BoxFit.cover,
                // ),
                CustomImage(
                  width: 20.w,
                  // height: 10.h,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(10),
                  url: model?.image,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // SizedBox(width: 1.w),
                          SizedBox(
                            // width: 28.w,
                            width: 26.w,
                            child: Text(
                              model?.title ?? '',
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: Utils.isTablet ? 9.sp : 13.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // SizedBox(width: 1.5.w),
                          if (Utils.isTablet) const Spacer(flex: 5),
                          Container(
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: CustomColors.primaryGreenColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(4) + EdgeInsets.symmetric(horizontal: 6),
                            child: MyText(
                              toverflow: TextOverflow.ellipsis,
                              title: model?.category?.categoryName ?? '',
                              clr: CustomColors.whiteColor,
                              size: Utils.isTablet ? 15 : 9,
                            ),
                          ),
                          const Spacer(),
                          if (availed) ...[
                            SizedBox(width: 2.w),
                            Container(
                              decoration: BoxDecoration(
                                color: CustomColors.primaryGreenColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(6) + EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  Image.asset(ImagePath.coins, color: CustomColors.whiteColor, scale: 3),
                                  MyText(title: '  500', clr: CustomColors.whiteColor, size: 11),
                                ],
                              ),
                            ),
                          ] else ...[
                            MyText(
                              title: '\$${model?.actualPrice?.toStringAsFixed(2) ?? ""}   ',
                              fontWeight: FontWeight.w600,
                              size: Utils.isTablet ? 6.sp : 12,
                              clr: CustomColors.grey,
                              cut: true,
                            ),
                            MyText(
                              title: '\$${model?.discountPrice?.toStringAsFixed(2) ?? ""}',
                              fontWeight: FontWeight.w600,
                              size: Utils.isTablet ? 6.sp : 12,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: .5.h),
                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImagePath.location,
                                color: CustomColors.primaryGreenColor,
                                height: Utils.isTablet ? 9.sp : 13.sp,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 1.w),
                              SizedBox(
                                width: 60.w,
                                child: Text(
                                  model?.address ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: Utils.isTablet ? 7.sp : 10.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: .5.h),
                      Row(
                        children: [
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              // '15% Discount on food and beverage',
                              model?.shortDetail ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: Utils.isTablet ? 7.sp : 10.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (availed) ...[
                            SizedBox(width: 2.w),
                            MyText(
                              title: 'Received',
                              size: 11,
                              fontWeight: FontWeight.w600,
                              clr: CustomColors.primaryGreenColor,
                            ),
                          ],
                        ],
                      ),
                    ],
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
