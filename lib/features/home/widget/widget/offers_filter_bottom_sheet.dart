import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_bottom_sheet.dart';
import 'package:backyard/core/helper/snackbar_helper.dart';
import 'package:backyard/features/home/widget/model/offers_filter_model.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';

Future<OffersFilterModel?> showOffersFilterBottomSheet({
  required BuildContext context,
  required OffersFilterModel filter,
}) async {
  final filterResult = await showCustomBottomSheet<OffersFilterModel>(
    context: context,
    routeName: 'OffersFilerBottomSheetRoute',
    maxHeightFactor: 0.25,
    child: OffersFilterBottomSheet(filter: filter),
  );

  return filterResult;
}

class OffersFilterBottomSheet extends StatefulWidget {
  final OffersFilterModel filter;

  const OffersFilterBottomSheet({super.key, required this.filter});

  @override
  State<OffersFilterBottomSheet> createState() => _OffersFilterBottomSheetState();
}

class _OffersFilterBottomSheetState extends State<OffersFilterBottomSheet> {
  late var _filter = widget.filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CustomSpacer.horizontal.md + CustomSpacer.top.xs,
      child: Column(
        children: [
          MyText(
            title: 'Offers filter',
            center: true,
            line: 1,
            size: 18,
            fontWeight: FontWeight.w600,
            clr: CustomColors.black,
          ),
          Padding(
            padding: CustomSpacer.top.md,
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    min: kMinMapRadiusInMiles,
                    max: kMaxMapRadiusInMiles,
                    divisions: kMapRadiusFilterDivisions,
                    value: _filter.radiusInMiles.toDouble(),
                    onChanged: (radiusInMiles) {
                      setState(() => _filter = _filter.copyWith(radiusInMiles: radiusInMiles.toInt()));
                    },
                  ),
                ),
                Text(
                  '${_filter.radiusInMiles.toInt()} Mile${_filter.radiusInMiles.toInt() > 1 ? "s" : ""}',
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
          Padding(
            padding: CustomSpacer.top.xmd + CustomSpacer.bottom.lg,
            child: MyButton(
              title: 'Set Filter',
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.maybePop<OffersFilterModel>(_filter);
              },
            ),
          ),
        ],
      ),
    );
  }
}
