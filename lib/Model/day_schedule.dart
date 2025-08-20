import 'package:flutter/material.dart';

class DaySchedule {
  DaySchedule(
      {required this.day, this.startTime, this.endTime, required this.active});

  final daysOfWeek day;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool active;
}

enum daysOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}
