import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/features/offers/offer_card_widget.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_switch.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/validations.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class UserProfileView extends StatefulWidget {
  final bool isMe;
  final bool isUser;
  final bool isBusinessProfile;
  final UserProfileModel? user;
  final bool wantKeepAlive;

  const UserProfileView({
    super.key,
    this.isMe = true,
    this.isBusinessProfile = false,
    this.user,
    this.isUser = true,
    this.wantKeepAlive = false,
  });

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with AutomaticKeepAliveClientMixin {
  TextEditingController s = TextEditingController();
  late final user = context.read<UserController>().user;
  late bool business =
      (context.read<UserController>().isSwitch)
          ? false
          : context.read<UserController>().user?.role == UserRoleEnum.Business;

  List<String> items = ['Offers', 'About', 'Reviews'];
  String i = 'Offers';

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();

    if (business && widget.isMe) {
      i = 'About';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (user != null) {
          if (widget.user?.id != null) {
            await BusinessAPIS.getReview(widget.user?.id?.toString() ?? '');
          }
        }
      });
    }
    if (!business || widget.isBusinessProfile) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (widget.user != null) {
          widget.user?.id != null
              ? await Future.wait([
                BusinessAPIS.getReview(widget.user?.id?.toString() ?? ''),
                BusinessAPIS.getOfferById(widget.user?.id?.toString() ?? ''),
              ])
              : await BusinessAPIS.getOfferById(widget.user?.id?.toString() ?? '');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: 0,
          horizontalPadding: CustomSpacer.horizontal.xs.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isMe) ...[
                CustomAppBar(
                  screenTitle: business ? 'Business Profile' : 'Profile',
                  leading: MenuIcon(),
                  trailing: EditIcon(),
                  bottom: 2.h,
                ),
              ] else ...[
                CustomAppBar(
                  screenTitle: business ? 'Business Profile' : widget.user?.name ?? 'Profile',
                  leading: BackButton(),
                  trailing: business ? Image.asset(ImagePath.favorite, scale: 2.5, color: CustomColors.redColor) : null,
                  bottom: 2.h,
                ),
              ],
              if (business || widget.isBusinessProfile) ...[
                Consumer2<UserController, HomeController>(
                  builder: (context, val, val2, child) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (val.user != null)
                              CustomImage(
                                height: 20.h,
                                width: 100.w,
                                borderRadius: BorderRadius.circular(10),
                                url: widget.isMe ? val.user?.profileImage : widget.user?.profileImage,
                              )
                            else
                              Image.asset(ImagePath.random6),
                            SizedBox(height: 2.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: MyText(
                                    title: widget.isMe ? (val.user?.name ?? '') : (widget.user?.name ?? ''),
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                ),
                                Image.asset(ImagePath.location, scale: 2, color: CustomColors.primaryGreenColor),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            MyText(
                              title: widget.isMe ? (val.user?.address ?? '') : widget.user?.address ?? '',
                              // 'Peoples Plaza, New Road, Kathmandu - 600m'
                              size: 12,
                            ),
                            SizedBox(height: 1.h),
                            if (i != items[2])
                              Row(
                                children: [
                                  MyText(title: '${val.rating.toStringAsFixed(1)}  ', size: 12),
                                  RatingBar(
                                    initialRating: val.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    glowColor: Colors.yellow,
                                    updateOnDrag: false,
                                    ignoreGestures: true,
                                    ratingWidget: RatingWidget(
                                      full: Image.asset(ImagePath.star, width: 4.w),
                                      half: Image.asset(ImagePath.starHalf, width: 4.w),
                                      empty: Image.asset(ImagePath.starOutlined, width: 4.w),
                                    ),
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    onRatingUpdate: (rating) {},
                                    itemSize: 3.w,
                                  ),
                                  MyText(title: '  ${val.reviews.length} Ratings', size: 12),
                                ],
                              ),
                            SizedBox(height: 2.h),
                            if (widget.isMe) ...[
                              Row(
                                children: [
                                  sessionButton2(title: items[1]),
                                  SizedBox(width: 3.w),
                                  sessionButton2(title: items[2]),
                                ],
                              ),
                            ] else ...[
                              SizedBox(
                                height: 5.h,
                                width: 100.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [for (int i = 0; i < items.length; i++) sessionButton(title: items[i])],
                                ),
                              ),
                            ],
                            SizedBox(height: 2.h),
                            if (i == items[0]) ...[
                              if ((val2.offers ?? []).isEmpty) ...[
                                SizedBox(height: 14.h),
                                CustomEmptyData(title: 'No Offer Found', hasLoader: true),
                              ] else
                                ListView.builder(
                                  itemCount: val2.offers?.length,
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.h),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: CustomSpacer.top.md,
                                      child: OfferCardWidget(offer: val2.offers![index]),
                                    );
                                  },
                                ),
                            ],
                            if (i == items[1]) ...[
                              MyText(title: 'Description', fontWeight: FontWeight.w600, size: 14),
                              SizedBox(height: .5.h),
                              MyText(
                                title: widget.isMe ? val.user?.description ?? '' : widget.user?.description ?? '',
                                // 'Classic checkerboard slip ons with office white under tone and reinforced waffle cup soles is a tone and reinforced waffle cup soles.CIassic ka checkerboard slip ons with office white hnan dunder tone and reinforced.'
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(title: 'Contact No:', fontWeight: FontWeight.w600, size: 14),
                                        SizedBox(height: .5.h),
                                        MyText(
                                          title: (widget.isMe) ? (val.user?.phone ?? '') : (widget.user?.phone ?? ''),
                                          // '+1 234 567 890'
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(title: 'Location:', fontWeight: FontWeight.w600, size: 14),
                                        SizedBox(height: .5.h),
                                        MyText(
                                          title:
                                              (widget.isMe) ? (val.user?.address ?? '') : (widget.user?.address ?? ''),
                                          //'abc School & college'
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              const MyText(title: 'Opening Hours', fontWeight: FontWeight.w600),
                              SizedBox(height: 1.h),
                              MyText(
                                title: 'Open • Closes',
                                fontWeight: FontWeight.w600,
                                clr: CustomColors.primaryGreenColor,
                              ),
                              SizedBox(height: 2.h),
                              for (
                                int i = 0;
                                i < (widget.isMe ? val.user?.days?.length ?? 0 : widget.user?.days?.length ?? 0);
                                i++
                              )
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        title:
                                            widget.isMe
                                                ? (val.user?.days?[i].day ?? '').titleCase()
                                                : (widget.user?.days?[i].day ?? '').titleCase(),
                                        fontWeight: FontWeight.w600,
                                        clr: const Color(0xff717171),
                                      ),
                                      if (widget.isMe)
                                        MyText(
                                          title: Utils.checkClosed(
                                            val.user?.days?[i].startTime,
                                            val.user?.days?[i].endTime,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          clr: const Color(0xffB9BCBE),
                                        )
                                      else
                                        MyText(
                                          title: Utils.checkClosed(
                                            widget.user?.days?[i].startTime,
                                            widget.user?.days?[i].endTime,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          clr: const Color(0xffB9BCBE),
                                        ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 1.h),
                            ],
                            if (i == items[2])
                              if (val.reviews.isNotEmpty) ...[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MyText(
                                      title: val.rating.toStringAsFixed(1),
                                      fontWeight: FontWeight.w600,
                                      size: 48,
                                      clr: const Color(0xffF1A635),
                                      center: true,
                                    ),
                                    RatingBar(
                                      initialRating: val.rating,
                                      // initialRating:d.endUser.value.avgRating,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      glowColor: Colors.yellow,
                                      updateOnDrag: false,
                                      ignoreGestures: true,
                                      ratingWidget: RatingWidget(
                                        full: Image.asset(ImagePath.star, width: 4.w),
                                        half: Image.asset(ImagePath.starHalf, width: 4.w),
                                        empty: Image.asset(ImagePath.starOutlined, width: 4.w),
                                      ),
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      onRatingUpdate: (rating) {},
                                      itemSize: 5.w,
                                    ),
                                    SizedBox(height: 2.h),
                                    MyText(title: 'Based On ${val.reviews.length} Reviews', size: 14),
                                    SizedBox(height: 3.h),
                                    for (int i = 0; i < val.reviews.length; i++)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomImage(
                                              shape: BoxShape.circle,
                                              height: 62,
                                              width: 62,
                                              url: val.reviews[i].user?.profileImage ?? '',
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      MyText(title: val.reviews[i].user?.name ?? '', size: 14),
                                                      MyText(
                                                        title: Utils.getDuration(val.reviews[i].createdAt),
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                  RatingBar(
                                                    initialRating: double.parse(val.reviews[i].rate ?? ''),
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    glowColor: Colors.yellow,
                                                    updateOnDrag: false,
                                                    ignoreGestures: true,
                                                    ratingWidget: RatingWidget(
                                                      full: Image.asset(ImagePath.star, width: 4.w),
                                                      half: Image.asset(ImagePath.starHalf, width: 4.w),
                                                      empty: Image.asset(ImagePath.starOutlined, width: 4.w),
                                                    ),
                                                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                    onRatingUpdate: (rating) {},
                                                    itemSize: 3.w,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  MyText(title: val.reviews[i].feedback ?? '', size: 14),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 4.h),
                                  ],
                                ),
                              ] else ...[
                                const Center(child: MyText(title: 'No Reviews Found', size: 18)),
                                SizedBox(height: 34.h),
                              ],
                            if (widget.user?.id != val.user?.id && !widget.isMe) ...[
                              Padding(
                                padding: CustomSpacer.top.xmd,
                                child: MyButton(
                                  title: 'Write a Review',
                                  onTap:
                                      () =>
                                          context.pushRoute(GiveReviewRoute(busId: widget.user?.id?.toString() ?? '')),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                profileCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Consumer<UserController> profileCard() {
    return Consumer<UserController>(
      builder: (context, val, _) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    color: CustomColors.primaryGreenColor,
                    shape: BoxShape.circle,
                  ),
                  height: 15.9.h,
                  width: 15.9.h,
                  alignment: Alignment.center,
                  child: CustomImage(
                    height: 15.h,
                    width: 15.h,
                    isProfile: true,
                    photoView: false,
                    url: val.user?.profileImage,
                    radius: 100,
                  ),
                ),
                SizedBox(height: 2.h),
                MyText(title: val.user?.name ?? '', fontWeight: FontWeight.w500, size: 18),
                // SizedBox(
                //   height: 1.h,
                // ),
                if (val.user?.socialType == null || val.user?.socialType == 'phone') ...[
                  MyText(title: val.user?.email ?? '', size: 16),
                  // MyText(title: u.value.fullName,fontWeight: FontWeight.w600,size: 18,),
                  SizedBox(height: 3.5.h),
                ],

                if (!business) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(title: 'Personal Details', fontWeight: FontWeight.w600, size: 18),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 247, 235),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          blurRadius: 10, // Spread of the shadow
                          spreadRadius: 2, // Size of the shadow
                          offset: const Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        // if(u.value.email!='')...[
                        //                 userDetail(title: ImagePath.location,text: u.value.location?.address??''),
                        // ],
                        // userDetail(
                        //     title: 'Phone Number', text: val.user?.phone ?? ""),
                        userDetail(title: 'Email Address', text: val.user?.email ?? ''),
                        userDetail(
                          title: 'Geo Location',
                          widget: CustomSwitch(
                            height: 3,
                            width: Utils.isTablet ? 8 : 12,
                            switchValue: val.geo,
                            onChange: (v) {},
                            toggleColor: CustomColors.primaryGreenColor,
                            onChange2: (v) async {
                              val.setGeo(v);
                            },
                          ),
                        ),

                        // userDetail(
                        //     title: 'Address',
                        //     text: '812 street, dummy address, USA'),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Padding userDetail({String? text, String title = '', Widget? widget}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: title != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(title: title, size: Utils.isTablet ? 18 : 14, clr: CustomColors.black, fontWeight: FontWeight.w600),
          SizedBox(width: 2.w),
          if (text != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: MyText(title: text, size: Utils.isTablet ? 16 : 12),
              ),
            ),
          if (widget != null) widget,
        ],
      ),
    );
  }

  Padding sessionButton({required String title}) {
    return Padding(
      padding: EdgeInsets.only(right: 1.w),
      child: MyButton(
        title: title,
        onTap: () async {
          i = title;
          if (title == items[2] && widget.user?.id != null) {
            await BusinessAPIS.getReview(widget.user?.id?.toString() ?? '');
          }
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? CustomColors.black : CustomColors.whiteColor,
        borderColor: CustomColors.black,
        textColor: i == title ? null : CustomColors.black,
        height: 5.2.h,
        width: 29.w,
      ),
    );
  }

  Expanded sessionButton2({required String title}) {
    return Expanded(
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? CustomColors.black : CustomColors.whiteColor,
        borderColor: CustomColors.black,
        textColor: i == title ? null : CustomColors.black,
        height: 5.2.h,
        width: 40.w,
      ),
    );
  }
}
