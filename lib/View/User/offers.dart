import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/Controller/home_controller.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/Model/offer_model.dart';
import 'package:backyard/Service/bus_apis.dart';
import 'package:backyard/Service/navigation_service.dart';
// import 'package:backyard/Model/session_model.dart';
// import 'package:backyard/Model/shop_model.dart';
// import 'package:backyard/Model/user_model.dart';
import 'package:backyard/Utils/app_router_name.dart';
import 'package:backyard/Utils/image_path.dart';
import 'package:backyard/Utils/my_colors.dart';
import 'package:backyard/Utils/utils.dart';
import 'package:backyard/View/User/discount_offers.dart';
import 'package:backyard/View/base_view.dart';
import 'package:backyard/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});
  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  TextEditingController s = TextEditingController();
  bool searchOn = false;
  List<String> trainerList = ['Assigned', 'In progress', 'Completed'],
      traineeList = ['Pending', 'Assigned', 'In progress', 'Completed'];
  String i = '';
  final homeController = navigatorKey.currentContext?.read<HomeController>();
  final userController = navigatorKey.currentContext?.read<UserController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getOffers();
      setLoading(false);
    });
    // TODO: implement initState
    super.initState();
  }

  void setLoading(bool val) {
    homeController?.setLoading(val);
  }

  Future<void> getOffers() async {
    await BusAPIS.getSavedOrOwnedOffers(isSwitch: userController?.isSwitch);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: BaseView(
        bgImage: '',
        topSafeArea: false,
        bottomSafeArea: false,
        child: CustomRefresh(
          onRefresh: () async {},
          child: Consumer<HomeController>(
            builder: (context, val, _) {
              return CustomPadding(
                topPadding: 0,
                horizontalPadding: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MyColors().whiteColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15), // Shadow color
                            blurRadius: 10, // Spread of the shadow
                            spreadRadius: 5, // Size of the shadow
                            offset: const Offset(0, 4), // Position of the shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 7.h) + EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomAppBar(
                            screenTitle: 'Saved',
                            leading: MenuIcon(),
                            trailing: NotificationIcon(),
                            bottom: 2.h,
                          ),
                          // SearchTile(
                          //   showFilter: false,
                          //   // search: location,
                          //   // readOnly: true,
                          //   onTap: ()async{
                          //     // await getAddress(context);
                          //   },
                          //   onChange: (v) async{
                          //     // await getAddress(context);
                          //   },
                          // ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                    //   child: MyText(
                    //     title: 'Trending Offers',
                    //     size: 16,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    if (val.loading)
                      Column(
                        children: [
                          SizedBox(height: 20.h),
                          Center(child: CircularProgressIndicator(color: MyColors().greenColor)),
                        ],
                      )
                    else if ((val.offers ?? []).isEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Center(child: CustomEmptyData(title: 'No Offers Found', hasLoader: false)),
                            ],
                          ),
                        ),
                      )
                    else
                      offerList(val.offers ?? []),
                    SizedBox(height: 2.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget offerList(List<Offer> val) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          for (int index = 0; index < val.length; index++) OfferTile(model: val[index], fromSaved: true),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  // sessionCard({required SessionModel s}) {
  //   return GestureDetector(
  //     onTap: () {
  //       HomeController.i.onTapCurrentSession(s: s);
  //       HomeController.i.getSessionData(id: s.id);
  //       if (i == traineeList[1] && s.isPaid == 0 && !trainer) {
  //         paymentDialog();
  //       } else if (i == traineeList[0] && !trainer) {
  //         CustomToast().showToast(
  //             'Waiting', 'Waiting for trainer to accept session', true);
  //       } else {
  //         AppNavigation.navigateTo( AppRouteName.START_SESSION_ROUTE);
  //       }
  //     },
  //     child: CustomCard(
  //         padding: EdgeInsets.all(3.w),
  //         margin: EdgeInsets.only(
  //               bottom: 2.h,
  //             ) +
  //             EdgeInsets.symmetric(horizontal: 2.w),
  //         child: Column(
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Image.asset(
  //                         ImagePath.location2,
  //                         scale: 2,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             MyText(
  //                               title: 'Current Location',
  //                               size: 16,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             MyText(
  //                               title: s.location?.address ?? '',
  //                               clr: MyColors().grey,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 MyText(
  //                   title: '${s.distance} km',
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 2.h,
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           MyText(
  //                             title: 'Date:',
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                           SizedBox(
  //                             width: 2.w,
  //                           ),
  //                           MyText(
  //                             title: s.pickDate,
  //                             clr: MyColors().grey,
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Row(
  //                         children: [
  //                           MyText(
  //                             title: 'Cost:',
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                           SizedBox(
  //                             width: 2.w,
  //                           ),
  //                           MyText(
  //                             title: '\$ ${s.cost}',
  //                             clr: MyColors().grey,
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Row(
  //                         children: [
  //                           MyText(
  //                             title: 'Time:',
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                           SizedBox(
  //                             width: 2.w,
  //                           ),
  //                           MyText(
  //                             title: s.pickTime,
  //                             clr: MyColors().grey,
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 1.h,
  //                       ),
  //                       Row(
  //                         children: [
  //                           MyText(
  //                             title: 'Duration:',
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                           SizedBox(
  //                             width: 2.w,
  //                           ),
  //                           MyText(
  //                             title: '${s.duration}',
  //                             clr: MyColors().grey,
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Image.asset(
  //                   ImagePath.scan2,
  //                   scale: 2,
  //                 )
  //               ],
  //             ),
  //           ],
  //         )),
  //   );
  // }

  // sessionCard2({required SessionModel s}) {
  //   return GestureDetector(
  //     onTap: () {
  //       HomeController.i.onTapCurrentSession(s: s);
  //       AppNavigation.navigateTo( AppRouteName.SESSION_DETAIL_ROUTE);
  //     },
  //     child: CustomCard(
  //         padding: EdgeInsets.all(3.w),
  //         margin: EdgeInsets.only(bottom: 1.h, top: 1.h) +
  //             EdgeInsets.symmetric(horizontal: 2.w),
  //         child: Column(
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Image.asset(
  //                         ImagePath.location2,
  //                         scale: 2,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             MyText(
  //                               title: 'Current Location',
  //                               size: 16,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                             MyText(
  //                               title:  "",//s.location?.address ?? '',
  //                               clr: MyColors().grey,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 MyText(
  //                   title: '${s.distance} km',
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 2.h,
  //             ),
  //             // userContainer(u: trainer ? s.trainee : s.trainer),
  //             SizedBox(
  //               height: 2.h,
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     children: [
  //                       MyText(
  //                         title: 'Date:',
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       MyText(
  //                         title: s.pickDate,
  //                         clr: MyColors().grey,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       MyText(
  //                         title: 'Cost:',
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       MyText(
  //                         title: '\$ ${s.cost}',
  //                         clr: MyColors().grey,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 1.h,
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     children: [
  //                       MyText(
  //                         title: 'Time:',
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       MyText(
  //                         title: s.pickTime,
  //                         clr: MyColors().grey,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       MyText(
  //                         title: 'Duration:',
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       SizedBox(
  //                         width: 2.w,
  //                       ),
  //                       MyText(
  //                         title: '${s.duration}',
  //                         clr: MyColors().grey,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         )),
  //   );
  // }

  // userContainer({required User? u}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: MyColors().secondaryColor.withValues(alpha: .3),
  //         borderRadius: BorderRadius.circular(100),
  //         border: Border.all(
  //           color: MyColors().secondaryColor,
  //         )),
  //     padding: EdgeInsets.all(2.w),
  //     margin: EdgeInsets.only(bottom: 2.h),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         CustomImage(
  //           url: u?.userImage,
  //           isProfile: true,
  //           photoView: false,
  //           height: 6.h,
  //           width: 6.h,
  //           radius: 200,
  //           fit: BoxFit.fill,
  //         ),
  //         // Image.asset(ImagePath.random1,scale: 2,),
  //         SizedBox(
  //           width: 3.w,
  //         ),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               MyText(
  //                 title: u?.fullName ?? '',
  //                 size: 13,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               if (!trainer)
  //                 Row(
  //                   children: [
  //                     Image.asset(
  //                       ImagePath.star,
  //                       scale: 2,
  //                     ),
  //                     MyText(
  //                       title: ' ${u?.avgRating}',
  //                       size: 13,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                     // MyText(title: ' (${u?.totalReviews})',size: 13,fontStyle: FontStyle.italic),
  //                   ],
  //                 ),
  //               if (!trainer)
  //                 SizedBox(
  //                   height: .5.h,
  //                 ),
  //               MyText(
  //                 title: trainer ? 'Trainee' : 'Trainer',
  //                 size: 12,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           width: 3.w,
  //         ),
  //         Image.asset(
  //           ImagePath.scan2,
  //           scale: 4,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Padding sessionButton({required String title}) {
    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: MyButton(
        title: title,
        onTap: () {
          i = title;
          setState(() {});
        },
        gradient: false,
        bgColor: i == title ? MyColors().secondaryColor : MyColors().whiteColor,
        borderColor: MyColors().secondaryColor,
        textColor: i == title ? null : MyColors().secondaryColor,
        height: 5.2.h,
        width: 30.w,
      ),
    );
  }

  // Widget offerList({required RxList<SessionModel> s}) {
  //   return Expanded(
  //       child: s.isNotEmpty
  //           ? CustomEmptyData(title: 'No Offers')
  //           : ListView.builder(
  //               // itemCount:s.length,
  //               padding: EdgeInsets.symmetric(horizontal: 17.sp, vertical: 0.h),
  //               physics: AlwaysScrollableScrollPhysics(
  //                   parent: const ClampingScrollPhysics()),
  //               shrinkWrap: true,
  //               itemBuilder: (_, index) => OfferTile()));
  // }

  // paymentDialog() {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //           child: AlertDialog(
  //             backgroundColor: Colors.transparent,
  //             contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //             content: PaymentDialog(
  //               onYes: () {
  //                 AppNavigation.navigateTo(
  //                     context, AppRouteName.PAYMENT_METHOD_ROUTE);
  //               },
  //             ),
  //           ),
  //         );
  //       });
  // }
}

class OfferTile extends StatelessWidget {
  final int? index;
  final Offer? model;
  final bool fromSaved;
  final bool availed;

  const OfferTile({super.key, this.index, this.fromSaved = false, this.model, this.availed = false});
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, val, _) {
        return GestureDetector(
          onTap: () {
            AppNavigation.navigateTo(
              AppRouteName.DISCOUNT_OFFER_ROUTE,
              arguments: DiscountOffersArguments(model: model, fromSaved: fromSaved),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors().whiteColor,
              boxShadow: [
                BoxShadow(
                  color: MyColors().container.withValues(alpha: 0.8), // Shadow color
                  blurRadius: 4, // Spread of the shadow
                  spreadRadius: 4, // Size of the shadow
                  offset: const Offset(0, 0), // Position of the shadow
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 1.5.h, top: 1.5.h),
            child: Row(
              children: [
                // Image.asset(
                //   ImagePath.random,
                //   scale: 2,
                //   fit: BoxFit.cover,
                // ),
                CustomImage(
                  width: 20.w,
                  // height: 10.h,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(10),
                  url: model?.image,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // SizedBox(width: 1.w),
                          SizedBox(
                            // width: 28.w,
                            width: 26.w,
                            child: Text(
                              model?.title ?? '',
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: Utils.isTablet ? 9.sp : 13.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // SizedBox(width: 1.5.w),
                          if (Utils.isTablet) const Spacer(flex: 5),
                          Container(
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: MyColors().primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(4) + EdgeInsets.symmetric(horizontal: 6),
                            child: MyText(
                              toverflow: TextOverflow.ellipsis,
                              title: model?.category?.categoryName ?? '',
                              clr: MyColors().whiteColor,
                              size: Utils.isTablet ? 15 : 9,
                            ),
                          ),
                          const Spacer(),
                          if (availed) ...[
                            SizedBox(width: 2.w),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors().primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(6) + EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  Image.asset(ImagePath.coins, color: MyColors().whiteColor, scale: 3),
                                  MyText(title: '  500', clr: MyColors().whiteColor, size: 11),
                                ],
                              ),
                            ),
                          ] else ...[
                            MyText(
                              title: '\$${model?.actualPrice?.toStringAsFixed(2) ?? ""}   ',
                              fontWeight: FontWeight.w600,
                              size: Utils.isTablet ? 6.sp : 12,
                              clr: MyColors().grey,
                              cut: true,
                            ),
                            MyText(
                              title: '\$${model?.discountPrice?.toStringAsFixed(2) ?? ""}',
                              fontWeight: FontWeight.w600,
                              size: Utils.isTablet ? 6.sp : 12,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: .5.h),
                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImagePath.location,
                                color: MyColors().primaryColor,
                                height: Utils.isTablet ? 9.sp : 13.sp,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 1.w),
                              SizedBox(
                                width: 60.w,
                                child: Text(
                                  model?.address ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: Utils.isTablet ? 7.sp : 10.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Expanded(
                          //   child: Row(
                          //     children: [
                          //       Image.asset(
                          //         ImagePath.man,
                          //         color: MyColors().primaryColor,
                          //         scale: 1,
                          //       ),
                          //       SizedBox(
                          //         width: 2.w,
                          //       ),
                          //       Expanded(
                          //           child: MyText(
                          //         title: '150 meters',
                          //         size: 11,
                          //       ))
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: .5.h),
                      Row(
                        children: [
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              // '15% Discount on food and beverage',
                              model?.shortDetail ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: Utils.isTablet ? 7.sp : 10.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (availed) ...[
                            SizedBox(width: 2.w),
                            MyText(
                              title: 'Received',
                              size: 11,
                              fontWeight: FontWeight.w600,
                              clr: MyColors().primaryColor,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
              ],
            ),
          ),
        );
      },
    );
  }
}
