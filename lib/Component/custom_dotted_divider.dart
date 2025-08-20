import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CustomDottedDivider extends StatelessWidget {
  const CustomDottedDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Color(0xff6E727D),
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }
}
