import 'dart:io';
import 'package:backyard/Arguments/screen_arguments.dart';
import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Component/validations.dart';
import 'package:backyard/Service/app_network.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:backyard/Component/custom_buttom.dart';
import 'package:backyard/Component/custom_padding.dart';
import 'package:backyard/Component/custom_textfield.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Service/navigation_service.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/View/base_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../Component/custom_text.dart';
import 'package:sizer/sizer.dart';

class GiveReviewArguments {
  GiveReviewArguments({this.busId});
  final String? busId;
}

class GiveReview extends StatefulWidget {
  const GiveReview({super.key, this.busId});
  final String? busId;
  @override
  State<GiveReview> createState() => _GiveReviewState();
}

class _GiveReviewState extends State<GiveReview> {
  TextEditingController review = TextEditingController();
  double rate = 1;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseView(
        screenTitle: 'Rating And Reviews',
        bgImage: '',
        showAppBar: true,
        showBackButton: true,
        // trailingAppBar: Image.asset(
        //   ImagePath.favorite,
        //   color: MyColors().redColor,
        //   scale: 2,
        // ),
        // backgroundColor: Colors.white,
        child: CustomPadding(
          horizontalPadding: 4.w,
          topPadding: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                title: 'What is you rate?',
                size: 17,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2.h),
              RatingBar(
                initialRating: rate,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                glowColor: Colors.yellow,
                updateOnDrag: true,
                ratingWidget: RatingWidget(
                  full: Image.asset(
                    ImagePath.star,
                    scale: 1,
                  ),
                  half: Image.asset(
                    ImagePath.starHalf,
                    scale: 2,
                  ),
                  empty: Image.asset(
                    ImagePath.star,
                    scale: 1,
                    color: MyColors().grey.withOpacity(.1),
                  ),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                onRatingUpdate: (rating) {
                  rate = rating;
                  setState(() {});
                },
                itemSize: 7.w,
              ),
              SizedBox(height: 2.h),
              const MyText(
                  title: 'Write your feedback.',
                  size: 17,
                  fontWeight: FontWeight.w600),
              SizedBox(
                height: 2.h,
              ),
              Form(
                key: _form,
                child: MyTextField(
                  height: 16.h,
                  hintText: 'Write your review...', showLabel: false,
                  maxLines: 10, minLines: 10,
                  controller: review,
                  backgroundColor: MyColors().container,
                  // borderColor: MyColors().secondaryColor,
                  hintTextColor: MyColors().grey,
                  textColor: MyColors().black,
                  borderRadius: 10, maxLength: 275,
                  validate: true,
                  validation: (p0) => p0?.validateEmpty("Review Message"),
                ),
              ),
              const Spacer(),
              SizedBox(height: 2.h),
              if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
                MyButton(
                  title: 'Submit Review',
                  onTap: () async {
                    if (_form.currentState?.validate() ?? false) {
                      AppNetwork.loadingProgressIndicator();
                      final val = await BusAPIS.submiteReview(
                          busId: widget.busId,
                          rate: rate.toInt().toString(),
                          feedback: review.text);
                      AppNavigation.navigatorPop();
                      if (val) {
                        AppNavigation.navigatorPop();
                      }
                    }
                    // if (review.text.isEmpty) {
                    //   CustomToast()
                    //       .showToast(message: 'Review field can\'t be empty');
                    // } else {
                    //   AppNavigation.navigatorPop();
                    //   CustomToast()
                    //       .showToast(message: 'Review posted successfully');
                    //   // HomeController.i.rating=rate;
                    //   // HomeController.i.review=review.text;
                    //   // HomeController.i.giveReview(context, onSuccess: (){
                    //   //   AppNavigation.navigatorPop(context);
                    //   //   AppNavigation.navigatorPop(context);
                    //   //   AppNavigation.navigateTo( AppRouteName.ALL_REVIEWS_ROUTE);
                    //   //   CustomToast().showToast('Success', 'Review posted successfully', false);
                    //   // }, edit: false);
                    // }
                  },
                ),
              ],

              // SizedBox(
              //   height: MediaQuery.of(context).viewInsets.bottom,
              // ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }
}
