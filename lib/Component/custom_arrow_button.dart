import 'package:flutter/material.dart';

class CustomArrow extends StatelessWidget {
  CustomArrow({Key? key,required this.icon,required this.onTap}) : super(key: key);
  IconData icon;
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       onTap();
      },
      child:  CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorDark,
        radius: 13,
        child: Icon(icon, color: Colors.white,),),
    );
  }
}
