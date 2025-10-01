import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/address_info_widget.dart';
import 'package:backyard/core/design_system/widgets/category_name_widget.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferCardWidget extends StatelessWidget {
  final Offer offer;
  final bool showAddress;
  final GestureTapCallback? onTap;

  const OfferCardWidget({super.key, required this.offer, this.showAddress = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(CustomRadius.s);
    final imageWidth = 76.w;
    return Card(
      elevation: 1,
      color: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.zero,
      child: Opacity(
        opacity: offer.isClaimed ? 0.6 : 1,
        child: InkWell(
          onTap: onTap ?? () => context.pushRoute(OfferItemRoute(offer: offer)),
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: offer.isClaimed ? CustomColors.grey.withValues(alpha: 0.2) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: imageWidth,
                  child: Stack(
                    children: [
                      if (offer.image != null && offer.image!.isNotEmpty)
                        CustomImage(
                          width: imageWidth,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(10),
                          url: offer.image,
                        ),
                      if (offer.category?.categoryName != null && offer.category!.categoryName!.isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: CustomSpacer.top.xxs,
                            child: CategoryNameWidget(
                              name: offer.category!.categoryName!.split(' ').first,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: CustomSpacer.all.xs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title ?? '',
                          maxLines: 2,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                        ),
                        if (showAddress && offer.address != null && offer.address!.isNotEmpty)
                          AddressInfoWidget(address: offer.address ?? ''),
                        Padding(
                          padding: CustomSpacer.top.xxs,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: MyText(
                                  title: '\$${offer.actualPrice?.toStringAsFixed(2) ?? ""}   ',
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  clr: CustomColors.grey,
                                  cut: true,
                                ),
                              ),
                              Flexible(
                                child: MyText(
                                  title: '\$${offer.discountPrice?.toStringAsFixed(2) ?? ""}',
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: CustomSpacer.top.xxs,
                          child: Row(
                            children: [
                              if (offer.shortDetail != null && offer.shortDetail!.isNotEmpty)
                                Flexible(
                                  child: Text(
                                    offer.shortDetail!,
                                    maxLines: 3,
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
                        ),
                        if (offer.isAvailed || offer.isClaimed)
                          Padding(
                            padding: CustomSpacer.top.md,
                            child: Row(
                              spacing: CustomSpacer.horizontal.xxs.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (offer.isClaimed)
                                  MyText(
                                    title: 'Already used',
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                    clr: CustomColors.fbColor,
                                  )
                                else if (offer.isAvailed)
                                  MyText(
                                    title: 'Saved',
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                    clr: CustomColors.primaryGreenColor,
                                  ),
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
        ),
      ),
    );
  }
}
