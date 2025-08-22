import 'package:flutter/material.dart';

class CustomRefresh extends StatelessWidget {
  const CustomRefresh({super.key, required this.child, required this.onRefresh});
  final Widget child;
  final Function onRefresh;

  Future _refreshData() async {
    // await Future.delayed(Duration(seconds: 3));
    await onRefresh();
    // await Future.wait(onRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      // edgeOffset: -1000,
      color: Color(0xffB4B4B4),
      backgroundColor: Colors.white,
      child: child,
    );
  }
}
