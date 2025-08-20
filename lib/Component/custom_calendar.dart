// import 'package:flutter/material.dart';
// import 'package:backyard/Component/custom_card.dart';
// import 'package:backyard/Controller/home_controller.dart';
// import 'package:backyard/Utils/my_colors.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
//
//
// class MyCalendar extends StatefulWidget {
//   MyCalendar({Key? key,this.selectedDay,this.rangeStart,this.rangeEnd,this.startRange,this.endRange,this.highLightedDay}) : super(key: key);
//   final ValueChanged<DateTime?>? selectedDay;
//   final ValueChanged<DateTime?>? rangeStart;
//   final ValueChanged<DateTime?>? rangeEnd;
//   DateTime? startRange;
//   DateTime? endRange;
//   DateTime? highLightedDay;
//
//   @override
//   _MyCalendarState createState() => _MyCalendarState();
// }
//
//
// class _MyCalendarState extends State<MyCalendar> {
//   // CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOn; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return CustomCard(
//       margin: EdgeInsets.symmetric(horizontal: 4.w),
//       child: TableCalendar(
//         firstDay:DateTime.now(),// kFirstDay,
//         lastDay: DateTime.now().add(Duration(days: 90)),// kFirstDay,
//         focusedDay: HomeController.i.selectedDate.value,// _focusedDay,
//         currentDay: DateTime.now().add(Duration(days: 3)),// HomeController.i.selectedDate.value,// _focusedDay,
//         selectedDayPredicate: (day) => isSameDay(HomeController.i.selectedDate.value, day),
//         rangeStartDay: widget.startRange,
//         rangeEndDay: widget.endRange,
//         calendarBuilders: CalendarBuilders(
//           dowBuilder: (context, day) {
//             final text = DateFormat.E().format(day);
//             return Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 00.0, vertical: 0),
//               child: CircleAvatar(
//                 radius: 17,
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   text[0].toUpperCase(), //+text[1],
//                   style:  TextStyle(
//                       color:  MyColors().black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           },
//         ),
//         daysOfWeekHeight: 50,
//         headerStyle: HeaderStyle(
//           // leftChevronPadding: const EdgeInsets.only(left: 0, top: 6, bottom: 6),
//           // rightChevronPadding: const EdgeInsets.only(right: 000, top: 6, bottom: 6),
//           // leftChevronIcon: Container(
//           //   decoration: BoxDecoration(
//           //       color: MyColors().black,
//           //       borderRadius: BorderRadius.circular(8)
//           //   ),
//           //   child: const Icon(
//           //     Icons.chevron_left_rounded,
//           //     color: Colors.white,
//           //   ),
//           // ),
//           // rightChevronIcon: Container(
//           //   decoration: BoxDecoration(
//           //       color: MyColors().black,
//           //       borderRadius: BorderRadius.circular(8)
//           //   ),
//           //   child: const Icon(
//           //     Icons.chevron_right_rounded,
//           //     color: Colors.white,
//           //   ),
//           // ),
//           formatButtonVisible: false,
//           titleCentered: true,
//           formatButtonShowsNext: false,
//
//         ),
//         calendarStyle: CalendarStyle(
//           isTodayHighlighted: false,
//           rangeEndDecoration: myDecoration,
//           rangeStartDecoration: myDecoration,
//           selectedDecoration: myDecoration,
//           rangeHighlightColor: MyColors().pinkColor,
//           withinRangeTextStyle: TextStyle(color: Colors.white),
//           // markerDecoration: myDecoration,
//           todayDecoration: myDecoration,
//           withinRangeDecoration:myDecoration,
//           // defaultDecoration:myDecoration,
//           // outsideDecoration :myDecoration,
//           // disabledDecoration:myDecoration,
//           // holidayDecoration :myDecoration,
//           // weekendDecoration:myDecoration,
//         ),
//         // rangeSelectionMode: _rangeSelectionMode,
//         onDaySelected: (selectedDay, focusedDay) {
//           if (!isSameDay(widget.highLightedDay, selectedDay)) {
//             setState(() {
//               widget.highLightedDay = selectedDay;
//               _focusedDay = focusedDay;
//               HomeController.i.selectedDate.value = focusedDay;
//               // HomeController.i.selectedDate.refresh();
//               widget.startRange = null; // Important to clean those
//               widget.endRange = null;
//               widget.selectedDay!(widget.highLightedDay);
//
//               // _rangeSelectionMode = RangeSelectionMode.toggledOff;
//             });
//             HomeController.i.update();
//             HomeController.i.selectedDate.refresh();
//           }
//         },
//         onRangeSelected: (start, end, focusedDay) {
//           setState(() {
//             widget.highLightedDay = null;
//             _focusedDay = focusedDay;
//             widget.startRange = start;
//             widget.endRange = end;
//             widget.rangeStart!(widget.startRange);
//             widget.rangeEnd!(widget.endRange);
//             // widget.selectedDay!(_selectedDay);
//             _rangeSelectionMode = RangeSelectionMode.toggledOn;
//           });
//         },
//         onPageChanged: (focusedDay) {
//           _focusedDay = focusedDay;
//         },
//         availableGestures: AvailableGestures.horizontalSwipe,
//       ),
//     );
//   }
//
//   BoxDecoration myDecoration = BoxDecoration(
//       color: MyColors().pinkColor,
//       // borderRadius: BorderRadius.circular(10),
//       shape: BoxShape.circle
//   );
// }