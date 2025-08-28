import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class GiveReviewArgs {
  GiveReviewArgs({this.busId});

  final String? busId;
}

@RoutePage()
class GiveReviewView extends StatefulWidget {
  const GiveReviewView({super.key, this.busId});

  final String? busId;

  @override
  State<GiveReviewView> createState() => _GiveReviewViewState();
}

class _GiveReviewViewState extends State<GiveReviewView> {
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
      child: CustomPadding(
        horizontalPadding: 4.w,
        topPadding: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(title: 'What is you rate?', size: 17, fontWeight: FontWeight.w600),
            SizedBox(height: 2.h),
            RatingBar(
              initialRating: rate,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              glowColor: Colors.yellow,
              updateOnDrag: true,
              ratingWidget: RatingWidget(
                full: Image.asset(ImagePath.star, scale: 1),
                half: Image.asset(ImagePath.starHalf, scale: 2),
                empty: Image.asset(ImagePath.star, scale: 1, color: CustomColors.grey.withValues(alpha: .1)),
              ),
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              onRatingUpdate: (rating) {
                rate = rating;
                setState(() {});
              },
              itemSize: 7.w,
            ),
            SizedBox(height: 2.h),
            const MyText(title: 'Write your feedback.', size: 17, fontWeight: FontWeight.w600),
            SizedBox(height: 2.h),
            Form(
              key: _form,
              child: CustomTextFormField(
                height: 16.h,
                hintText: 'Write your review...',
                showLabel: false,
                maxLines: 10,
                minLines: 10,
                controller: review,
                backgroundColor: CustomColors.container,
                // borderColor: MyColors().secondaryColor,
                hintTextColor: CustomColors.grey,
                textColor: CustomColors.black,
                borderRadius: 10,
                maxLength: 275,
                validation: (p0) => p0?.validateEmpty('Review Message'),
              ),
            ),
            const Spacer(),
            SizedBox(height: 2.h),
            if (MediaQuery.viewInsetsOf(context).bottom == 0) ...[
              MyButton(
                title: 'Submit Review',
                onTap: () async {
                  if (_form.currentState?.validate() ?? false) {
                    getIt<AppNetwork>().loadingProgressIndicator();
                    final val = await BusAPIS.submiteReview(
                      busId: widget.busId,
                      rate: rate.toInt().toString(),
                      feedback: review.text,
                    );
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
                  //   //   AppNavigation.navigateTo( AppRouteName.ALL_REVIEWS_VIEW_ROUTE);
                  //   //   CustomToast().showToast('Success', 'Review posted successfully', false);
                  //   // }, edit: false);
                  // }
                },
              ),
            ],

            // SizedBox(
            //   height: MediaQuery.viewInsetsOf(context).bottom,
            // ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
