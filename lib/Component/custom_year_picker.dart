import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Component/custom_year_picker_style.dart' as my;
import 'package:backyard/Service/navigation_service.dart';
import 'package:sizer/sizer.dart';

class CustomYearPickerDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime)? onChanged;
  CustomYearPickerDialog({required this.selectedDate, required this.onChanged});

  @override
  _CustomAppExitDialogState createState() => _CustomAppExitDialogState();
}

class _CustomAppExitDialogState extends State<CustomYearPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 3.h,
          ),
          MyText(
            title: 'Select Year',
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
          SizedBox(
            height: 25.h,
            width: 80.w,
            child: my.YearPicker(
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 18000)),
                initialDate: widget.selectedDate,
                selectedDate: widget.selectedDate,
                onChanged: (v) {
                  AppNavigation.navigatorPop();
                  widget.onChanged!(v);
                }),
          ),
          SizedBox(height: 5.w),
        ],
      ),
    );
  }
}
