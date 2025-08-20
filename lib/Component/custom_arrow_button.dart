import 'package:flutter/material.dart';

class CustomArrow extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  const CustomArrow({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorDark,
        radius: 13,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
