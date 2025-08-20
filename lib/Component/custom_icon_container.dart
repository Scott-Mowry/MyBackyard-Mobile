import 'package:flutter/material.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:sizer/sizer.dart';

class IconContainer extends StatelessWidget {
  IconContainer({super.key,this.child,this.image,required this.onTap,this.size,this.padding});
  Widget? child;
  Function onTap;
  String? image;
  double? size, padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){onTap();},
      child:Image.asset(image!,scale: 2,),
      // Container(
      //   padding: EdgeInsets.all(padding??3.w),
      //   decoration: BoxDecoration(
      //     color: MyColors().blueColor,
      //     borderRadius: BorderRadius.circular(5),
      //   ), child: child??Image.asset(image!,width: size??5.w,height: size??5.w,),
      // ),
    );
  }
}
