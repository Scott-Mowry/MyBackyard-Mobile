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
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferCardWidget extends StatelessWidget {
  final Offer offer;
  final bool fromSaved;
  final bool availed;
  final bool showAddress;

  const OfferCardWidget({
    super.key,
    required this.offer,
    this.fromSaved = false,
    this.availed = false,
    this.showAddress = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(CustomRadius.s);
    final imageWidth = 76.w;
    return Card(
      elevation: 1,
      color: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.pushRoute(OfferItemRoute(offer: offer, fromSaved: fromSaved)),
        borderRadius: borderRadius,
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
                        child: CategoryNameWidget(name: offer.category!.categoryName!.split(' ').first, fontSize: 12),
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
                          if (availed) ...[
                            Flexible(
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
