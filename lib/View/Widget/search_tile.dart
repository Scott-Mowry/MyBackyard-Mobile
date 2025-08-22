import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_text_form_field.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchTile extends StatefulWidget {
  final TextEditingController? search;
  final Function(String)? onChange;
  final Function? onTap, onTapFilter;
  final bool showFilter;
  final bool disabled;
  final bool readOnly;

  const SearchTile({
    super.key,
    this.onChange,
    this.disabled = false,
    this.search,
    this.showFilter = true,
    this.readOnly = false,
    this.onTap,
    this.onTapFilter,
  });

  @override
  State<SearchTile> createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 5.5.h,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors().lightGreyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomTextFormField(
              enable: !widget.disabled,
              hintText: 'Search...',
              controller: widget.search,
              onChanged: widget.onChange,
              showLabel: false,
              readOnly: widget.readOnly,
              borderRadius: 8,
              backgroundColor: MyColors().whiteColor,
              // borderColor: MyColors().lightGreyColor,
              textColor: MyColors().black,
              hintTextColor: MyColors().greyColor,
              onTap: widget.onTap,
              prefixWidget: Icon(Icons.search, color: MyColors().primaryColor),
              onTapSuffixIcon: () {},
              // suffixIconData: Image.asset(ImagePath.filterIcon,scale: 4,)
              // suffixIcons: Image.asset(ImagePath.filterIcon,scale: 4,)
            ),
          ),
          if (widget.showFilter) ...[
            SizedBox(width: 2.w),
            FilterIcon(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.onTapFilter != null) {
                  widget.onTapFilter!();
                }
              },
            ),
            SizedBox(width: 2.w),
          ],
        ],
      ),
    );
  }

  void onSubmit(context) {}
  void setFilter() {}
}
