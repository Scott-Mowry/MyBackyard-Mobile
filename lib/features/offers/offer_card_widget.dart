import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_radius.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferCardWidget extends StatelessWidget {
  final Offer offer;
  final bool fromSaved;
  final bool availed;

  const OfferCardWidget({super.key, required this.offer, this.fromSaved = false, this.availed = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(CustomRadius.s);
    return Card(
      elevation: 1,
      color: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.pushRoute(DiscountOffersRoute(offer: offer, fromSaved: fromSaved)),
        borderRadius: borderRadius,
        child: Row(
          children: [
            if (offer.image != null && offer.image!.isNotEmpty)
              CustomImage(width: 76.w, fit: BoxFit.cover, borderRadius: BorderRadius.circular(10), url: offer.image),
            Expanded(
              child: Padding(
                padding: CustomSpacer.left.xs + CustomSpacer.vertical.xs,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            offer.title ?? '',
                            maxLines: 1,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                          ),
                        ),
                        if (offer.category?.categoryName != null && offer.category!.categoryName!.isNotEmpty)
                          Flexible(
                            child: Padding(
                              padding: CustomSpacer.left.xs,
                              child: Container(
                                padding: CustomSpacer.horizontal.xs + CustomSpacer.vertical.xxs,
                                decoration: BoxDecoration(
                                  color: CustomColors.primaryGreenColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  offer.category!.categoryName?.split(' ').firstOrNull ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: CustomTextStyle.labelSmall.copyWith(color: CustomColors.white),
                                ),
                              ),
                            ),
                          ),
                        if (availed) ...[
                          Flexible(
                            child: Padding(
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
                          ),
                        ] else ...[
                          Flexible(
                            child: Padding(
                              padding: CustomSpacer.left.xs,
                              child: MyText(
                                title: '\$${offer.actualPrice?.toStringAsFixed(2) ?? ""}   ',
                                fontWeight: FontWeight.w600,
                                size: 14,
                                clr: CustomColors.grey,
                                cut: true,
                              ),
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
                      ],
                    ),
                    if (offer.address != null && offer.address!.isNotEmpty)
                      Padding(
                        padding: CustomSpacer.top.xs,
                        child: Row(
                          children: [
                            Image.asset(
                              ImagePath.location,
                              color: CustomColors.primaryGreenColor,
                              height: 18,
                              fit: BoxFit.fitHeight,
                            ),
                            Flexible(
                              child: Padding(
                                padding: CustomSpacer.left.xxs,
                                child: Text(
                                  offer.address ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
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
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          if (availed) ...[
                            SizedBox(width: 2.w),
                            Flexible(
                              child: MyText(
                                title: 'Received',
                                size: 14,
                                fontWeight: FontWeight.w600,
                                clr: CustomColors.primaryGreenColor,
                              ),
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
  }
}
