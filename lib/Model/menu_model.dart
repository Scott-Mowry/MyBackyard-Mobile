import 'package:flutter/material.dart';

class MenuModel {
  MenuModel(
      {this.name,
      this.title,
      this.subTitle,
      this.image,
      this.value,
      this.color,
      this.onTap,
      this.val,
      this.price,
      List<String>? points,
      this.description})
      : points = points ?? [];
  String? name, title, subTitle, description, image;
  bool? val;
  String? value;
  Color? color;
  double? price;
  List<String> points;
  Function()? onTap;
}
