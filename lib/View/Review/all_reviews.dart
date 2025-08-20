import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:backyard/Component/custom_empty_data.dart';
import 'package:backyard/Component/custom_image.dart';
import 'package:backyard/Component/custom_text.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Utils/my_colors.dart';
import 'package:sizer/sizer.dart';
import '../../Component/custom_refresh.dart';
import '../../Model/user_model.dart';
import '../base_view.dart';

class AllReviews extends StatefulWidget {
  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Rating & Reviews',
        showAppBar: true,
        showBackButton: true,
        resizeBottomInset: false,
        bgImage: '',
        child: CustomRefresh(
          onRefresh: () async {
            await getData(loading: false);
          },
          child: Consumer<HomeController>(builder: (context, val, _) {
            return Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                MyText(
                  title: '${22}',
                  fontWeight: FontWeight.w700,
                  size: 40,
                  clr: MyColors().primaryColor2,
                ),
                SizedBox(
                  height: 2.h,
                ),
                RatingBar(
                  // initialRating:5,
                  initialRating: 22,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  glowColor: Colors.yellow,
                  updateOnDrag: false,
                  ignoreGestures: true,
                  ratingWidget: RatingWidget(
                    full: Image.asset(
                      ImagePath.star,
                      width: 4.w,
                    ),
                    half: Image.asset(
                      ImagePath.starHalf,
                      width: 4.w,
                    ),
                    empty: Image.asset(
                      ImagePath.starOutlined,
                      width: 4.w,
                    ),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  onRatingUpdate: (rating) {},
                  itemSize: 5.w,
                ),
                SizedBox(
                  height: 1.h,
                ),
                MyText(
                  title: '${22} Reviews',
                  size: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                // Expanded(
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 4.w,vertical:  4.w),
                //     color: MyColors().secondaryColorLight,
                //     child: d.reviews.isEmpty?CustomEmptyData(title: 'No Reviews',):ListView.builder(
                //         physics: ClampingScrollPhysics(),
                //         itemCount:d.reviews.length,
                //         padding: EdgeInsets.zero,
                //         shrinkWrap: true,
                //         itemBuilder: (context,index){
                //           return Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   CustomImage(url: d.reviews[index].traineeId?.userImage, isProfile: true, photoView: false,height: 6.h,width: 6.h,radius: 200,fit: BoxFit.cover,),
                //                   // Image.asset(ImagePath.random2,scale: 2.3,),
                //                   SizedBox(width: 3.w,),
                //                   Expanded(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         MyText(title: d.reviews[index].traineeId?.fullName??'',size: 13,fontWeight: FontWeight.w600,),
                //                         RatingBar(
                //                           initialRating:d.reviews[index].rating,
                //                           direction: Axis.horizontal,
                //                           allowHalfRating: false,
                //                           itemCount: 5,
                //                           glowColor: Colors.yellow,
                //                           updateOnDrag:false,
                //                           ignoreGestures:true,
                //                           ratingWidget: RatingWidget(
                //                             full: Image.asset(ImagePath.star,width: 3.w,),
                //                             half: Image.asset(ImagePath.star,width: 3.w,),
                //                             empty:Image.asset(ImagePath.starOutlined,width: 3.w,),
                //                           ),
                //                           itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                //                           onRatingUpdate: (rating) {},
                //                           itemSize:4.w,
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height:1.h,),
                //               MyText(title: d.reviews[index].review,clr: MyColors().grey,fontStyle: FontStyle.italic,),
                //               SizedBox(height:2.h,),
                //             ],
                //           );
                //         })
                //   ),
                // ),
              ],
            );
          }),
        ));
  }

  Future<void> getData({bool? loading}) async {
    // await HomeController.i.allReviews(context: context,u: HomeController.i.endUser.value??User());
  }
  // onSubmit(context){
}
