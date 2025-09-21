import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class PriceDiscountWidget extends StatelessWidget {
  final double actualPrice;
  final double discountPrice;

  const PriceDiscountWidget({super.key, required this.actualPrice, required this.discountPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: CustomColors.black, borderRadius: BorderRadius.circular(30)),
      padding: CustomSpacer.all.md,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: CustomSpacer.horizontal.xxs.horizontal,
        children: [
          Text(
            '\$$actualPrice',
            style: CustomTextStyle.labelSmall.copyWith(
              color: CustomColors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            '\$$discountPrice',
            maxLines: 2,
            style: CustomTextStyle.labelSmall.copyWith(
              color: CustomColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
