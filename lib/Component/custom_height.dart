import 'package:flutter/material.dart';

class CustomHeight extends StatelessWidget {
  final Widget prototype;
  final PageView? pageView;
  final ListView? listView;

  const CustomHeight({
    Key? key,
    required this.prototype,
    this.listView,
    this.pageView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          child: Opacity(
            opacity: 0.0,
            child: prototype,
          ),
        ),
        SizedBox(width: double.infinity),
        Positioned.fill(child: pageView??listView!),
      ],
    );
  }
}