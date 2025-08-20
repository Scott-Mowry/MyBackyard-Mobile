import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Model/menu_model.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({
    Key? key,
  }) : super(key: key);
  List<MenuModel> items = [
    MenuModel(image: ImagePath.home2, title: 'Home'),
    MenuModel(image: ImagePath.home2, title: 'Home'),
    MenuModel(image: ImagePath.home2, title: 'Home'),
    MenuModel(image: ImagePath.home2, title: 'Home'),
    MenuModel(image: ImagePath.home2, title: 'Home'),
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: 7.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: MyColors().whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 10, // Spread of the shadow
                spreadRadius: 5, // Size of the shadow
                offset: const Offset(0, 4), // Position of the shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              item(i: items[0], index: 0),
              item(i: items[1], index: 1),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                // child:  item(i: items[1]),
              ),
              item(i: items[2], index: 2),
              item(i: items[3], index: 3),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green,
            // child:  item(i: items[1]),
          ),
        ),
      ],
    );
  }

  item({required MenuModel i, required int index}) {
    return Builder(builder: (context) {
      return Consumer<HomeController>(builder: (context, val, _) {
        return InkWell(
          onTap: () {
            val.setIndex(index);
          },
          child: SizedBox(
            width: 18.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  i.image!,
                  // color: currentIndex == items.indexOf(0)
                  //     ? Colors.blue
                  //     : Colors.grey,
                  scale: 2,
                ),
                Text(
                  i.title!,
                  style: TextStyle(
                    // color: currentIndex == items.indexOf(item)
                    //     ? Colors.blue
                    //     : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
