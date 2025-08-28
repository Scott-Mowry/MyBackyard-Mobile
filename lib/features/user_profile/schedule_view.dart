import 'package:auto_route/annotations.dart';
import 'package:backyard/boot.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/features/time_schedule/time_schedule_edit_view.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/day_schedule.dart';
import 'package:backyard/legacy/Model/menu_model.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class ScheduleView extends StatefulWidget {
  final bool edit;
  final Map<String, dynamic>? args;

  const ScheduleView({super.key, this.edit = false, this.args});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<MenuModel> hours = [
    MenuModel(name: 'Mon', val: false),
    MenuModel(name: 'Tue', val: false),
    MenuModel(name: 'Wed', val: false),
    MenuModel(name: 'Thu', val: false),
    MenuModel(name: 'Fri', val: false),
    MenuModel(name: 'Sat', val: false),
    MenuModel(name: 'Sun', val: false),
  ];
  List<DaySchedule> daySchedules = [];

  String openTime = 'Open Time';
  String closeTime = 'Close Time';
  final _form = GlobalKey<FormState>();
  final userController = navigatorKey.currentContext?.read<UserController>();

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
    if (widget.edit) {
      if ((userController?.user?.days ?? []).isNotEmpty) {
        for (var temp in userController?.user?.days ?? []) {
          daySchedules.add(
            DaySchedule(
              day: daysOfWeek.values.byName(temp.day ?? ''),
              active: !(temp.startTime == null && temp.endTime == null),
              startTime: timeFormat(temp.startTime),
              endTime: timeFormat(temp.endTime),
            ),
          );
        }
      } else {
        for (var val in daysOfWeek.values) {
          daySchedules.add(
            DaySchedule(
              day: val,
              startTime: null,
              endTime: null,
              active: val == daysOfWeek.saturday || val == daysOfWeek.sunday ? false : true,
            ),
          );
        }
      }
    } else {
      for (var val in daysOfWeek.values) {
        daySchedules.add(
          DaySchedule(
            day: val,
            startTime: null,
            endTime: null,
            active: val == daysOfWeek.saturday || val == daysOfWeek.sunday ? false : true,
          ),
        );
      }
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      screenTitle: widget.edit ? 'Edit Opening Hours' : 'Opening Hours',
      bgImage: '',
      showAppBar: true,
      showBackButton: true,
      trailingAppBar: IconButton(
        icon: Icon(Icons.select_all_outlined, size: 24.sp, color: CustomColors.black),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            AppRouteName.TIME_SCHEDULE_EDIT_VIEW_ROUTE,
            arguments: TimeSchedulingEditArgs(multiSelect: true),
          ).then((value) {
            if (value != null) {
              final list = value as List<DaySchedule>?;
              for (var j = 0; j < (list?.length ?? 0); j++) {
                final temp = list?[j];
                if (temp != null) {
                  int? index;
                  for (var i = 0; i < daySchedules.length; i++) {
                    if (daySchedules[i].day == temp.day) {
                      index = i;
                    }
                  }
                  if (index != null) {
                    daySchedules[index] = temp;
                  }
                }
              }
              setState(() {});
            }
          });
        },
      ),
      child: CustomPadding(
        horizontalPadding: 4.w,
        topPadding: 0,
        child: Consumer<UserController>(
          builder: (context, val, _) {
            return Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // time(
                  //     t: openTime,
                  //     onTap: () async {
                  //       FocusManager.instance.primaryFocus?.unfocus();
                  //       await Utils().selectTime(context, onTap: (v) {
                  //         openTime = v.format(context);
                  //         setState(() {});
                  //       });
                  //     }),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // time(
                  //     t: closeTime,
                  //     onTap: () async {
                  //       FocusManager.instance.primaryFocus?.unfocus();
                  //       await Utils().selectTime(context, onTap: (v) {
                  //         closeTime = v.format(context);
                  //         setState(() {});
                  //       });
                  //     }),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 2.w),
                  //   child: MyText(
                  //     title: 'Set Days',
                  //     fontWeight: FontWeight.w600,
                  //     size: 16,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Wrap(
                  //   children: List.generate(
                  //     hours.length,
                  //     (index) => Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         CheckBoxWidget(
                  //           defaultVal: hours[index].val!,
                  //           onChange: (newValue) {
                  //             hours[index].val = newValue;
                  //           },
                  //         ),
                  //         Padding(
                  //             padding: EdgeInsets.symmetric(horizontal: 1.w) +
                  //                 EdgeInsets.only(right: 1.w, top: 0.h),
                  //             child: MyText(
                  //                 title: '${hours[index].name}',
                  //                 clr: MyColors().black,
                  //                 size: 12)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  for (DaySchedule val in daySchedules)
                    Padding(padding: EdgeInsets.only(bottom: 2.h), child: timeField(val)),
                  Spacer(),
                  MyButton(
                    title: widget.edit ? 'Update' : 'Next',
                    onTap: () {
                      onSubmit(context);
                    },
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onTapField(DaySchedule val) async {
    await Navigator.pushNamed(
      context,
      AppRouteName.TIME_SCHEDULE_EDIT_VIEW_ROUTE,
      arguments: TimeSchedulingEditArgs(val: val),
    ).then((value) {
      final temp = value as DaySchedule?;
      if (temp != null) {
        int? index;
        for (var i = 0; i < daySchedules.length; i++) {
          if (daySchedules[i].day == temp.day) {
            index = i;
          }
        }
        if (index != null) {
          daySchedules[index] = temp;
        }
      }
      setState(() {});
    });
  }

  Widget timeField(DaySchedule val) {
    return CustomTextFormField(
      controller: TextEditingController(text: getValues(val)),
      onTap: () => onTapField(val),
      hintText: 'None',
      readOnly: true,
      prefixWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Text(
          val.day.name.titleCase(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1),
        ),
      ),
      textAlign: TextAlign.end,
      suffixIconConstraints: BoxConstraints(minWidth: 8.w),
      borderRadius: 10,
      validation: (p0) => p0?.validateEmpty('${val.day.name.titleCase()} time'),
    );
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

  Future<void> onSubmit(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if ((_form.currentState?.validate() ?? false)) {
      var temp = <BussinessScheduling>[];
      final temp2 = daySchedules.where((element) => element.startTime != null && element.endTime != null).toList();
      temp =
          temp2
              .map(
                (e) => BussinessScheduling(
                  day: e.day.name,
                  startTime: e.startTime?.format(context),
                  endTime: e.endTime?.format(context),
                ),
              )
              .toList();
      if (widget.edit) {
        getIt<AppNetwork>().loadingProgressIndicator();
        final value = await getIt<UserAuthRepository>().completeProfile(days: temp);
        AppNavigation.navigatorPop();
        if (value) {
          AppNavigation.navigatorPop();
        }
      } else {
        final user =
            userController?.user
              ?..name = widget.args?['name']
              ..description = widget.args?['description']
              ..isPushNotify = widget.args?['isPushNotify']
              ..address = widget.args?['address']
              ..latitude = widget.args?['lat']
              ..longitude = widget.args?['lng']
              ..phone = widget.args?['phone']
              ..email = widget.args?['email']
              ..days = temp
              ..profileImage = widget.args?['image']
        // ..zipCode = widget.args?["zipCode"]
        ;

        userController?.setUser(user!);
        AppNavigation.navigateTo(AppRouteName.CATEGORY_VIEW_ROUTE);
      }
    }
  }

  GestureDetector time({required String t, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(color: CustomColors.lightGrey2, borderRadius: BorderRadius.circular(25)),
        child: MyText(title: t),
      ),
    );
  }
}
