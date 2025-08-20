import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:backyard/Component/custom_checkbox.dart';
import 'package:backyard/Utils/image_path.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../Utils/my_colors.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({Key? key,required this.onTap,required this.select}) : super(key: key);
  Function onTap;
  bool select;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.h),//+EdgeInsets.only(left: selectedIndex.value==0?1.w:0, right:selectedIndex.value==buttons!.length?1.w:0 ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: MyColors().whiteColor
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: MyText(title: 'Haircut',size: 20,fontWeight: FontWeight.w600,line: 1,)),
                MyText(title: 'Select Services',size: 17,fontWeight: FontWeight.w400,line: 1,),
              ],),
              SizedBox(
                height: 1.h,
              ),
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (buildContext, int i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),//+EdgeInsets.only(left: selectedIndex.value==0?1.w:0, right:selectedIndex.value==buttons!.length?1.w:0 ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors().blackLight,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(2.w),
                        child:Row(
                          children: [
                            Container(
                              width: 6.h,height: 6.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(ImagePath.random,),
                                      fit: BoxFit.fill
                                  ),
                                  borderRadius: BorderRadius.circular(4)
                              ),
                            ),
                            SizedBox(width: 2.w,),
                            Expanded(child: MyText(title: 'Standard Haircut',clr: MyColors().whiteColor,size: 15,)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CheckBoxWidget(
                                  defaultVal: select,
                                  onChange: (newValue) {
                                    select=newValue;
                                    print(newValue);
                                    onTap();
                                    //
                                    // s(() {});
                                  },),
                                SizedBox(height: .5.h,),
                                MyText(title: '\$50.00',clr: MyColors().whiteColor,size: 20,fontWeight: FontWeight.w400,line: 1,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],),
        )
    );
  }
}
