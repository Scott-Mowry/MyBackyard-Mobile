import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class TitleDescription extends StatelessWidget {
  TitleDescription({Key? key,this.title,this.description}) : super(key: key);
  String? title,description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: MyText(
              title: title??"",
              fontWeight:FontWeight.w600,
              size: 16,
            ),
          ),
          SizedBox(width: 2.w,),
          Expanded(
            flex:3,
            child: Align(
              alignment: Alignment.centerRight,
              child: MyText(
                title: description??"",
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
