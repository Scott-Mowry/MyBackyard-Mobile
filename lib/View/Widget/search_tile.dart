import 'dart:ui';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_slider.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/Appbar/appbar_components.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';
import '../../Component/custom_bottomsheet_indicator.dart';
import '../../Utils/app_size.dart';

class SearchTile extends StatefulWidget {
  SearchTile(
      {Key? key,
      this.onChange,
      this.disabled = false,
      this.search,
      this.showFilter = true,
      this.readOnly = false,
      this.onTap,
      this.onTapFilter})
      : super(key: key);
  TextEditingController? search;
  final Function(String)? onChange;
  final Function? onTap, onTapFilter;
  bool showFilter;
  bool disabled;
  bool readOnly = false;

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
          border: Border.all(
            color: MyColors().lightGreyColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: MyTextField(
              enable: !widget.disabled,
              hintText: "Search...",
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
              prefixWidget: Icon(
                Icons.search,
                color: MyColors().primaryColor,
              ),
              onTapSuffixIcon: () {},
              // suffixIconData: Image.asset(ImagePath.filterIcon,scale: 4,)
              // suffixIcons: Image.asset(ImagePath.filterIcon,scale: 4,)
            ),
          ),
          if (widget.showFilter) ...[
            SizedBox(
              width: 2.w,
            ),
            FilterIcon(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.onTapFilter != null) {
                  widget.onTapFilter!();
                }
              },
            ),
            SizedBox(
              width: 2.w,
            ),
          ],
        ],
      ),
    );
  }

  onSubmit(context) {}
  setFilter() {}
}
