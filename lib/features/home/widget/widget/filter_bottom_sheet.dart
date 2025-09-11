import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/design_system/widgets/custom_bottom_sheet.dart';
import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:backyard/core/repositories/permission_repository.dart';
import 'package:backyard/features/home/widget/model/filter_model.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_dropdown.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:flutter/material.dart';

Future<FilterModel?> showFilterBottomSheet({
  required BuildContext context,
  required FilterModel filter,
  required List<CategoryModel> categories,
}) async {
  final filterResult = await showCustomBottomSheet<FilterModel>(
    context: context,
    routeName: 'OffersFilerBottomSheetRoute',
    maxHeightFactor: 0.5,
    child: FilterBottomSheet(filter: filter, categories: categories),
  );

  return filterResult;
}

class FilterBottomSheet extends StatefulWidget {
  final FilterModel filter;
  final List<CategoryModel> categories;

  const FilterBottomSheet({super.key, required this.filter, required this.categories});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late var _filter = widget.filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: CustomSpacer.horizontal.md + CustomSpacer.top.xs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onClearFilter,
                child: MyText(
                  title: 'Clear',
                  center: true,
                  line: 1,
                  size: 18,
                  fontWeight: FontWeight.w600,
                  clr: CustomColors.redColor,
                ),
              ),
              Spacer(flex: 1),
              MyText(
                title: 'Filter results',
                center: true,
                line: 1,
                size: 18,
                fontWeight: FontWeight.w600,
                clr: CustomColors.black,
              ),
              Spacer(flex: 1),
              InkWell(
                onTap: context.maybePop,
                child: MyText(
                  title: 'Cancel',
                  center: true,
                  line: 1,
                  size: 18,
                  fontWeight: FontWeight.w600,
                  clr: CustomColors.grey,
                ),
              ),
            ],
          ),
          Padding(padding: CustomSpacer.top.md, child: MyText(title: 'Business name')),
          Padding(
            padding: CustomSpacer.top.xxs,
            child: CustomTextFormField(
              hintText: 'Search...',
              onChanged: (query) => _filter = _filter.copyWith(query: query),
              showLabel: false,
              borderRadius: 8,
              backgroundColor: CustomColors.container,
              textColor: CustomColors.black,
              hintTextColor: CustomColors.greyColor,
              prefixWidget: Icon(Icons.search, color: CustomColors.primaryGreenColor),
            ),
          ),
          Padding(padding: CustomSpacer.top.md, child: MyText(title: 'Select category')),
          Padding(
            padding: CustomSpacer.top.xxs,
            child: CustomDropDown2(
              hintText: 'Select category',
              bgColor: CustomColors.container,
              dropDownData: widget.categories,
              dropdownValue: _filter.category,
              validator: (p0) => (p0 == null) ? "Category can't be empty" : null,
              onChanged: (category) => setState(() => _filter = _filter.copyWith(category: category)),
            ),
          ),
          Padding(padding: CustomSpacer.top.md, child: MyText(title: 'Select distance')),
          Padding(
            padding: CustomSpacer.top.xxs,
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
            child: MyButton(title: 'Set Filter', onTap: onSetFilter),
          ),
        ],
      ),
    );
  }

  Future<void> onClearFilter() async {
    await getIt<PermissionRepository>().requestLocationPermission();
    final devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
    final filter = FilterModel(latitude: devicePosition.latitude, longitude: devicePosition.longitude);

    FocusManager.instance.primaryFocus?.unfocus();
    unawaited(context.maybePop<FilterModel>(filter));
  }

  void onSetFilter() {
    FocusManager.instance.primaryFocus?.unfocus();
    unawaited(context.maybePop<FilterModel>(_filter));
  }
}
