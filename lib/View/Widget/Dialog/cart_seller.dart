import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:sizer/sizer.dart';

class CartSeller extends StatefulWidget {
  CartSeller({required this.onYes});
  Function onYes;
  @override
  State<CartSeller> createState() => _CartSellerState();
}

class _CartSellerState extends State<CartSeller> {
  @override
  Widget build(BuildContext c) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyColors().purpleLight,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close_outlined,
                    color: Colors.transparent,
                  ),
                  MyText(
                    title: 'Remove your previous items?',
                    clr: MyColors().whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigation.navigatorPop();
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 2.h,),
                  // Center(child: CircleAvatar(radius: 45, backgroundColor: MyColors().purpleColor,child:Image.asset(ImagePath.delete,scale: 3,color: MyColors().whiteColor,),)),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                      child: MyText(
                    title:
                        'You still have items from another seller. Start over with a fresh cart?',
                    clr: MyColors().black,
                    size: 13,
                    center: true,
                  )),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: MyButton(
                          onTap: () {
                            AppNavigation.navigatorPop();
                          },
                          title: "Close",
                          bgColor: MyColors().purpleColor,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Flexible(
                        child: MyButton(
                            onTap: () {
                              AppNavigation.navigatorPop();
                              widget.onYes();
                            },
                            title: "Remove items"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.5.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
