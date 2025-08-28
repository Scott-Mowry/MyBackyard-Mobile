import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
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
import 'package:backyard/legacy/Model/file_network.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/User/give_review.dart';
import 'package:backyard/legacy/View/User/offers.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  final bool isMe;
  final bool isUser;
  final bool isBusinessProfile;
  final User? user;

  const UserProfile({super.key, this.isMe = true, this.isBusinessProfile = false, this.user, this.isUser = true});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController s = TextEditingController();
  late final user = context.read<UserController>().user;
  late bool business =
      (navigatorKey.currentContext?.read<UserController>().isSwitch ?? false)
          ? false
          : navigatorKey.currentContext?.read<UserController>().user?.role == UserRoleEnum.Business;
  List<String> items = ['Offers', 'About', 'Reviews'];
  String i = 'Offers';

  void setLoading(bool val) {
    if (business) {
      context.read<UserController>().setLoading(val);
    } else {
      context.read<UserController>().setLoading(val);
      context.read<HomeController>().setLoading(val);
    }
  }

  @override
  void initState() {
    // business = !widget.isUser;
    if (business && widget.isMe) {
      i = 'About';
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (user != null) {
          if (widget.user?.id != null) {
            setLoading(true);
            await BusAPIS.getReview(widget.user?.id?.toString() ?? '');
            setLoading(false);
          }
        }
      });
    }
    if (!business || widget.isBusinessProfile) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (widget.user != null) {
          setLoading(true);
          widget.user?.id != null
              ? await Future.wait([
                BusAPIS.getReview(widget.user?.id?.toString() ?? ''),
                BusAPIS.getOfferById(widget.user?.id?.toString() ?? ''),
              ])
              : await BusAPIS.getOfferById(widget.user?.id?.toString() ?? '');
          setLoading(false);
        }
      });
    }
    // TODO: implement initState
    super.initState();
  }

  List<FileNetwork> images = List<FileNetwork>.empty();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BaseView(
        bgImage: '',
        child: CustomPadding(
          topPadding: widget.isMe ? 2.h : 0,
          horizontalPadding: widget.isMe ? 20.sp : 10.sp,
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
                          children:
                              val.loading
                                  ? [
                                    SizedBox(height: 30.h),
                                    Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor)),
                                  ]
                                  : [
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

                                            //'Lorum Ipsum Cafe'
                                            fontWeight: FontWeight.w600,
                                            size: 16,
                                          ),
                                        ),
                                        Image.asset(
                                          ImagePath.location,
                                          scale: 2,
                                          color: CustomColors.primaryGreenColor,
                                        ),
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
                                          children: [
                                            for (int i = 0; i < items.length; i++) sessionButton(title: items[i]),
                                          ],
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 2.h),
                                    if (i == items[0]) ...[
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       color: MyColors().primaryColor,
                                      //       borderRadius:
                                      //           BorderRadius.circular(10)),
                                      //   padding: EdgeInsets.all(12),
                                      //   child: Row(
                                      //     children: [
                                      //       Image.asset(
                                      //         ImagePath.offer,
                                      //         scale: 2,
                                      //       ),
                                      //       SizedBox(
                                      //         width: 2.w,
                                      //       ),
                                      //       Expanded(
                                      //         child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             MyText(
                                      //               title:
                                      //                   'Extra 25%, off, up to \$\$. 3,000.00',
                                      //               fontWeight: FontWeight.w600,
                                      //               clr: MyColors().whiteColor,
                                      //             ),
                                      //             MyText(
                                      //               title:
                                      //                   'Promo Code SAVE. Ends 6/9.',
                                      //               clr: MyColors().whiteColor,
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       SizedBox(
                                      //         width: 2.w,
                                      //       ),
                                      //       MyButton(
                                      //         title: 'Apply',
                                      //         onTap: () {},
                                      //         gradient: false,
                                      //         bgColor: MyColors().black,
                                      //         borderColor: MyColors().black,
                                      //         textColor: MyColors().whiteColor,
                                      //         height: 5.2.h,
                                      //         width: 24.w,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 2.h,
                                      // ),
                                      if ((val2.offers ?? []).isEmpty) ...[
                                        SizedBox(height: 14.h),
                                        CustomEmptyData(title: 'No Offer Found', hasLoader: true),
                                      ] else
                                        ListView.builder(
                                          itemCount: val2.offers?.length,
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.h),
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) => OfferTile(model: val2.offers?[index]),
                                        ),
                                      // Consumer<HomeController>(builder: (context, val, _) {
                                      //   if (val.loading) {
                                      //     return CircularProgressIndicator(
                                      //       color: MyColors().primaryColor,
                                      //     );
                                      //   } else {
                                      //     return ListView.builder(
                                      //         itemCount: val.offers?.length,
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 3.w, vertical: 0.h),
                                      //         physics: NeverScrollableScrollPhysics(),
                                      //         shrinkWrap: true,
                                      //         itemBuilder: (_, index) => OfferTile());
                                      //   }
                                      // })
                                    ],
                                    if (i == items[1]) ...[
                                      MyText(title: 'Description', fontWeight: FontWeight.w600, size: 14),
                                      SizedBox(height: .5.h),
                                      MyText(
                                        title:
                                            widget.isMe ? val.user?.description ?? '' : widget.user?.description ?? '',
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
                                                  title:
                                                      (widget.isMe)
                                                          ? (val.user?.phone ?? '')
                                                          : (widget.user?.phone ?? ''),
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
                                                      (widget.isMe)
                                                          ? (val.user?.address ?? '')
                                                          : (widget.user?.address ?? ''),
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
                                        i <
                                            (widget.isMe
                                                ? val.user?.days?.length ?? 0
                                                : widget.user?.days?.length ?? 0);
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
                                                            // initialRating:d.endUser.value.avgRating,
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
                                                          MyText(
                                                            title: val.reviews[i].feedback ?? '',
                                                            // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(height: 4.h),
                                          ],
                                        ),

                                        // SizedBox(height: 2.h,),
                                        // ListView.builder(
                                        //     itemCount:10,
                                        //     padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.h),
                                        //     physics: NeverScrollableScrollPhysics(),
                                        //     shrinkWrap: true,
                                        //     itemBuilder: (_, index) =>OfferTile()
                                        // )
                                      ] else ...[
                                        const Center(child: MyText(title: 'No Reviews Found', size: 18)),
                                        SizedBox(height: 34.h),
                                      ],
                                    if (widget.user?.id != val.user?.id && !widget.isMe) ...[
                                      MyButton(
                                        title: 'Write a Review',
                                        onTap: () {
                                          AppNavigation.navigateTo(
                                            AppRouteName.GIVE_REVIEW_VIEW_ROUTE,
                                            arguments: GiveReviewArguments(busId: widget.user?.id?.toString() ?? ''),
                                          );
                                        },
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
      padding: EdgeInsets.only(right: 2.w),
      child: MyButton(
        title: title,
        onTap: () async {
          i = title;
          if (title == items[2] && widget.user?.id != null) {
            setLoading(true);
            await BusAPIS.getReview(widget.user?.id?.toString() ?? '');
            setLoading(false);
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
