import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

class CustomMonthPickerDialog extends StatefulWidget {
  final int? selectedMonth;
  final ValueChanged<String>? onChanged;
  final ValueChanged<int>? i;

  CustomMonthPickerDialog(
      {Key? key, this.selectedMonth, this.onChanged, this.i})
      : super(key: key);

  @override
  _CustomAppExitDialogState createState() => _CustomAppExitDialogState();
}

class _CustomAppExitDialogState extends State<CustomMonthPickerDialog> {
  static const List MONTH_LIST = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 5.w) ,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 3.h,
          ),
          MyText(
            title: 'Select Month',
            size: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Divider(),
          ),
          SizedBox(
            height: 2.h,
          ),
          GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
              ),
              // gridDelegate: _monthPickerGridDelegate,
              itemCount: MONTH_LIST.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: () {
                    widget.onChanged!(MONTH_LIST[index]);
                    widget.i!(index);
                    AppNavigation.navigatorPop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: widget.selectedMonth == (index + 1)
                            ? MyColors().pinkColor
                            : Colors
                                .transparent, //MyColors().pinkColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(
                            widget.selectedMonth == (index + 1) ? 4 : 0),
                        border: widget.selectedMonth == (index + 1)
                            ? Border.all(color: MyColors().pinkColor)
                            : null),
                    child: MyText(
                      title: MONTH_LIST[index].toString(),
                      clr: widget.selectedMonth == (index + 1)
                          ? Colors.white
                          : Colors.black,
                      size: 15,
                    ),
                  ),
                );
              }),
          SizedBox(height: 5.w),
          //CustomDividerWidget(),
        ],
      ),
    );
  }
}
