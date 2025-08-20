import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/View/Widget/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomToggle extends StatelessWidget {
  CustomToggle(
      {Key? key,
      this.buttons,
      required this.selectedIndex,
      this.fontSize = 12,
      this.onTap})
      : super(key: key);
  int selectedIndex = 0;
  List? buttons;
  double? fontSize;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ThemeButtons(
                text: buttons![0],
                borderColor: Colors.white,
                textColor: selectedIndex == 0 ? Colors.white : Colors.grey,
                color: selectedIndex == 0
                    ? Theme.of(context).primaryColorDark
                    : Colors.white,
                borderWidth: 4.0,
                elevation: 0,
                onChange: () {
                  selectedIndex = 0;
                  if (onTap != null) {
                    onTap?.call();
                  }
                },
                fontSize: fontSize,
              ),
            ),
            Expanded(
              child: ThemeButtons(
                text: buttons![1],
                borderColor: Colors.white,
                textColor: selectedIndex == 1 ? Colors.white : Colors.grey,
                color: selectedIndex == 1
                    ? Theme.of(context).primaryColorDark
                    : Colors.white,
                borderWidth: 4.0,
                elevation: 0,
                onChange: () {
                  selectedIndex = 1;
                  if (onTap != null) {
                    onTap?.call();
                  }
                },
                fontSize: fontSize,
              ),
            ),
            if (buttons!.length > 2)
              Expanded(
                child: ThemeButtons(
                  text: buttons![2],
                  borderColor: Colors.white,
                  textColor: selectedIndex == 2 ? Colors.white : Colors.grey,
                  color: selectedIndex == 2
                      ? Theme.of(context).primaryColorDark
                      : Colors.white,
                  borderWidth: 4.0,
                  elevation: 0,
                  onChange: () {
                    selectedIndex = 2;
                    if (onTap != null) {
                      onTap?.call();
                    }
                  },
                  fontSize: fontSize,
                ),
              ),
            if (buttons!.length > 3)
              Expanded(
                child: ThemeButtons(
                  text: buttons![3],
                  borderColor: Colors.white,
                  textColor: selectedIndex == 3 ? Colors.white : Colors.grey,
                  color: selectedIndex == 3
                      ? Theme.of(context).primaryColorDark
                      : Colors.white,
                  borderWidth: 4.0,
                  elevation: 0,
                  onChange: () {
                    selectedIndex = 3;
                    if (onTap != null) {
                      onTap?.call();
                    }
                  },
                  fontSize: fontSize,
                ),
              ),
          ],
        ),

        // ListView.builder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: buttons!.length,
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (BuildContext, int index) {
        //       return Flexible(
        //         child: ThemeButtons(
        //           text: buttons![index],
        //           borderColor: Colors.white,
        //           textColor: selectedIndex.value==index  ? Colors.white : Colors.grey,
        //           color: selectedIndex.value==index ? Theme
        //               .of(context)
        //               .primaryColorDark : Colors.white,
        //           borderWidth: 4.0,
        //           elevation: 0,
        //           onChange: () {
        //             selectedIndex.value=index;
        //             selectedIndex.refresh();
        //           },
        //         ),
        //       );
        //     }),
      ),
    );
    // Card(
    //   elevation: 4,
    //   child: Container(
    //     width: MediaQuery
    //         .of(context)
    //         .size
    //         .width * .9,
    //     height: 55,
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(5.0)
    //     ),
    //     child:
    //     Obx(() {
    //       return Center(
    //         child: ListView.builder(
    //           // physics: const NeverScrollableScrollPhysics(),
    //             itemCount: buttons!.length,
    //             shrinkWrap: true,
    //             scrollDirection: Axis.horizontal,
    //             itemBuilder: (BuildContext, int index) {
    //               return Padding(
    //                 padding: EdgeInsets.symmetric(vertical:1.w,horizontal: 1.w),//+EdgeInsets.only(left: selectedIndex.value==0?1.w:0, right:selectedIndex.value==buttons!.length?1.w:0 ),
    //                 child: GestureDetector(
    //                   onTap: (){
    //                     selectedIndex.value=index;
    //                   },
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         color: selectedIndex.value==index ? Theme.of(context).primaryColorDark : Colors.white,
    //                         borderRadius: BorderRadius.circular(5.0)
    //                     ),
    //                     alignment: Alignment.center,
    //                     child:MyText(title: buttons![index],clr:selectedIndex.value==index  ? Colors.white : Colors.grey,),
    //                   ),
    //                 ),
    //               );
    //             }),
    //       );
    //     }),

    //     // ListView.builder(
    //     //     physics: const NeverScrollableScrollPhysics(),
    //     //     itemCount: buttons!.length,
    //     //     shrinkWrap: true,
    //     //     scrollDirection: Axis.horizontal,
    //     //     itemBuilder: (BuildContext, int index) {
    //     //       return Flexible(
    //     //         child: ThemeButtons(
    //     //           text: buttons![index],
    //     //           borderColor: Colors.white,
    //     //           textColor: selectedIndex.value==index  ? Colors.white : Colors.grey,
    //     //           color: selectedIndex.value==index ? Theme
    //     //               .of(context)
    //     //               .primaryColorDark : Colors.white,
    //     //           borderWidth: 4.0,
    //     //           elevation: 0,
    //     //           onChange: () {
    //     //             selectedIndex.value=index;
    //     //             selectedIndex.refresh();
    //     //           },
    //     //         ),
    //     //       );
    //     //     }),
    //   ),
    // );
  }
}
//
