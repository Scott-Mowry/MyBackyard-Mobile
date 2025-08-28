import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartSeller extends StatefulWidget {
  final Function onYes;

  const CartSeller({super.key, required this.onYes});

  @override
  State<CartSeller> createState() => _CartSellerState();
}

class _CartSellerState extends State<CartSeller> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      // height: responsive.setHeight(75),
      width: 100.w,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.purpleColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              margin: EdgeInsets.symmetric(vertical: 1.w, horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.close_outlined, color: Colors.transparent),
                  MyText(
                    title: 'Remove your previous items?',
                    clr: CustomColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: context.maybePop,
                    child: const Icon(Icons.close_outlined, color: Colors.white),
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
                  SizedBox(height: 2.h),
                  Center(
                    child: MyText(
                      title: 'You still have items from another seller. Start over with a fresh cart?',
                      clr: CustomColors.black,
                      size: 13,
                      center: true,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Flexible(
                        child: MyButton(
                          onTap: () {
                            context.maybePop();
                          },
                          title: 'Close',
                          bgColor: CustomColors.purpleColor,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: MyButton(
                          onTap: () {
                            context.maybePop();
                            widget.onYes();
                          },
                          title: 'Remove items',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
