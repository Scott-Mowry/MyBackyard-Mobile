import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Model/day_schedule.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class BusinessAvailabilityView extends StatefulWidget {
  final List<BusinessSchedulingModel> availabilities;

  const BusinessAvailabilityView({super.key, required this.availabilities});

  @override
  State<BusinessAvailabilityView> createState() => _BusinessAvailabilityViewState();
}

class _BusinessAvailabilityViewState extends State<BusinessAvailabilityView> {
  final _form = GlobalKey<FormState>();

  List<DaySchedule> daySchedules = [];

  TimeOfDay? timeFormat(String? val) {
    if (val != null) {
      final hour = int.parse(val.split(':')[0]);
      final min = int.parse(val.split(':')[1]);
      return TimeOfDay(hour: hour, minute: min);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.availabilities.isEmpty) {
      final schedules = WeekDayEnum.values.map(
        (el) => DaySchedule(
          day: el,
          startTime: null,
          endTime: null,
          active: el == WeekDayEnum.saturday || el == WeekDayEnum.sunday ? false : true,
        ),
      );

      daySchedules.addAll(schedules);
      return;
    }

    final schedules = widget.availabilities.map(
      (el) => DaySchedule(
        day: WeekDayEnum.values.byName(el.day ?? ''),
        active: !(el.startTime == null && el.endTime == null),
        startTime: timeFormat(el.startTime),
        endTime: timeFormat(el.endTime),
      ),
    );

    daySchedules.addAll(schedules);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      bgImage: '',
      screenTitle: 'Edit availability',
      showAppBar: true,
      showBackButton: true,
      trailingAppBar: IconButton(
        icon: Icon(Icons.select_all_outlined, size: 24.sp, color: CustomColors.black),
        onPressed: () async {
          final schedules = await context.pushRoute(TimeScheduleEditRoute(multiSelect: true));
          if (schedules == null || schedules is! List<DaySchedule?>) return;

          for (var j = 0; j < (schedules.length); j++) {
            final temp = schedules[j];
            if (temp == null) continue;

            int? index;
            for (var i = 0; i < daySchedules.length; i++) {
              if (daySchedules[i].day == temp.day) index = i;
            }

            if (index != null) daySchedules[index] = temp;
          }
          setState(() {});
        },
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: CustomSpacer.horizontal.md + CustomSpacer.top.md,
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...daySchedules.map(
                      (el) => Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: CustomTextFormField(
                          controller: TextEditingController(text: getValues(el)),
                          onTap: () => onTapField(el),
                          hintText: 'None',
                          readOnly: true,
                          prefixWidget: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Text(
                              el.day.name.titleCase(),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1),
                            ),
                          ),
                          textAlign: TextAlign.end,
                          suffixIconConstraints: BoxConstraints(minWidth: 8.w),
                          borderRadius: 10,
                          validation: (p0) => p0?.validateEmpty('${el.day.name.titleCase()} time'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: CustomSpacer.horizontal.md, child: MyButton(title: 'Save', onTap: onSave)),
        ],
      ),
    );
  }

  Future<void> onTapField(DaySchedule daySchedule) async {
    final newDaySchedule = await context.pushRoute(TimeScheduleEditRoute(daySchedule: daySchedule));
    if (newDaySchedule == null || newDaySchedule is! DaySchedule) return;

    int? index;
    for (var i = 0; i < daySchedules.length; i++) {
      if (daySchedules[i].day == newDaySchedule.day) index = i;
    }

    if (index != null) daySchedules[index] = newDaySchedule;
    setState(() {});
  }

  String getValues(DaySchedule val) {
    var value = '';
    if (val.endTime != null && val.startTime != null) {
      value = '${val.startTime?.format(context)} - ${val.endTime?.format(context)}';
    } else {
      if (val.active == false) {
        value = 'Closed';
      }
    }
    return value;
  }

  Future<void> onSave() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    final businessSchedules =
        daySchedules
            .where((element) => element.startTime != null && element.endTime != null)
            .map(
              (el) => BusinessSchedulingModel(
                day: el.day.name,
                startTime: el.startTime?.format(context),
                endTime: el.endTime?.format(context),
              ),
            )
            .toList();

    unawaited(context.maybePop(businessSchedules));
  }
}
