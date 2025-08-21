import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final String? image;
  final double? size, padding;

  const IconContainer({super.key, this.child, this.image, required this.onTap, this.size, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Image.asset(image!, scale: 2));
  }
}
