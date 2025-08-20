import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_card.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:provider/provider.dart';
import '../../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class PaymentHistory extends StatefulWidget {
  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  int i = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // HomeController.i.getEarnings(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Payment History',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        child: CustomPadding(
          horizontalPadding: 4.w,
          topPadding: 0,
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColors().secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      MyText(
                        title: 'Total Earnings',
                        fontWeight: FontWeight.w600,
                        size: 25,
                        clr: MyColors().whiteColor,
                      ),
                      MyText(
                          title: '\$${11}',
                          fontWeight: FontWeight.w600,
                          size: 30,
                          clr: MyColors().whiteColor),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                // sessionList(s: d.earnings),
              ],
            );
          }),
        ));
  }
  // Widget sessionList({required RxList<SessionModel> s}){
  //   return Expanded(
  //     child: s.isEmpty?CustomEmptyData(title: 'No Payments'):
  //     ListView.builder(
  //       itemCount:s.length,
  //       physics: AlwaysScrollableScrollPhysics(parent: const ClampingScrollPhysics()),
  //       shrinkWrap: true,
  //       itemBuilder: (_, index) =>sessionCard2(context,s:s[index]),
  //     ),
  //   );
  // }
  // sessionCard2(context,{required SessionModel s}){
  //   return GestureDetector(
  //     onTap: (){
  //       AppNavigation.navigateTo( AppRouteName.SESSION_DETAIL_ROUTE);
  //     },
  //     child: CustomCard(
  //         padding: EdgeInsets.all(3.w),
  //         margin: EdgeInsets.only(bottom: 1.h,top: 1.h)+EdgeInsets.symmetric(horizontal: 2.w),
  //         child:
  //         Column(
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Image.asset(ImagePath.location2,scale: 2,),
  //                       SizedBox(width: 2.w,),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             MyText(title: 'Current Location',size: 16,fontWeight: FontWeight.w600,),
  //                             MyText(title: s.location?.address??'',clr: MyColors().grey,),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 MyText(title: '${s.distance} km',fontWeight: FontWeight.w600,),
  //               ],
  //             ),
  //             SizedBox(height: 2.h,),
  //             userContainer(u:trainer?s.trainee:s.trainer),
  //             SizedBox(height: 2.h,),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Row(children: [
  //                     MyText(title: 'Date:',fontWeight: FontWeight.w600,),
  //                     SizedBox(width: 2.w,),
  //                     MyText(title: s.pickDate,clr: MyColors().grey,),

  //                   ],),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       MyText(title: 'Cost:',fontWeight: FontWeight.w600,),
  //                       SizedBox(width: 2.w,),
  //                       MyText(title: '\$ ${s.trainerCost}',clr: MyColors().grey,),
  //                     ],),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 1.h,),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Row(children: [
  //                     MyText(title: 'Time:',fontWeight: FontWeight.w600,),
  //                     SizedBox(width: 2.w,),
  //                     MyText(title: s.pickTime,clr: MyColors().grey,),

  //                   ],),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       MyText(title: 'Duration:',fontWeight: FontWeight.w600,),
  //                       SizedBox(width: 2.w,),
  //                       MyText(title: '${s.duration}',clr: MyColors().grey,),
  //                     ],),
  //                 ),
  //               ],
  //             ),
  //           ],)),
  //   );
  // }
  // userContainer({required User? u}){
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: MyColors().secondaryColor.withOpacity(.3),
  //         borderRadius: BorderRadius.circular(100),
  //         border: Border.all(color: MyColors().secondaryColor,)
  //     ),
  //     padding: EdgeInsets.all(2.w),
  //     margin: EdgeInsets.only(bottom: 2.h),
  //     child:  Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         CustomImage(url: u?.userImage, isProfile: true, photoView: false,height: 6.h,width: 6.h,radius: 200,fit: BoxFit.fill,),
  //         // Image.asset(ImagePath.random1,scale: 2,),
  //         SizedBox(width: 3.w,),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               MyText(title: u?.fullName??'',size: 13,fontWeight: FontWeight.w600,),
  //               if(!trainer)
  //               Row(
  //                 children: [
  //                   Image.asset(ImagePath.star,scale: 2,),
  //                   MyText(title: ' ${u?.avgRating}',size: 13,fontWeight: FontWeight.w600,),
  //                   // MyText(title: ' (${u?.totalReviews})',size: 13,fontStyle: FontStyle.italic),
  //                 ],
  //               ),
  //               if(trainer)
  //                 SizedBox(height: .5.h,),
  //                 MyText(title: trainer?'Trainee':'Trainer',size: 12,fontWeight: FontWeight.w600,),
  //             ],
  //           ),
  //         ),
  //         SizedBox(width: 3.w,),
  //         Image.asset(ImagePath.scan2 ,scale: 4,),
  //       ],
  //     ),
  //   );
  // }
}
