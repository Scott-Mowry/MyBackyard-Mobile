import 'dart:ui';

import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/legacy/Arguments/profile_screen_arguments.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_image.dart';
import 'package:backyard/legacy/Component/custom_padding.dart';
import 'package:backyard/legacy/Component/custom_refresh.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/legacy/View/Widget/Dialog/reject_dialog.dart';
import 'package:backyard/legacy/View/Widget/search_tile.dart';
import 'package:backyard/legacy/View/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  TextEditingController s = TextEditingController();
  final homeController = navigatorKey.currentContext?.read<HomeController>();
  bool searchOn = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await getCustomers();
      setLoading(false);
    });
    // TODO: implement initState
    super.initState();
  }

  void setLoading(bool val) {
    homeController?.setLoading(val);
  }

  Future<void> getCustomers() => BusAPIS.getCustomers();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
        // return Utils().onWillPop(context, currentBackPressTime: currentBackPressTime);
      },
      child: BaseView(
        bgImage: '',
        bottomSafeArea: false,
        topSafeArea: false,
        child: CustomRefresh(
          onRefresh: getCustomers,
          child: Consumer<HomeController>(
            builder: (context, val, _) {
              return CustomPadding(
                topPadding: 0.h,
                horizontalPadding: 0.w,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.whiteColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2), // Shadow color
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
                            screenTitle: 'Customers',
                            leading: MenuIcon(),
                            trailing: NotificationIcon(),
                            bottom: 2.h,
                          ),
                          SearchTile(
                            disabled: val.loading,
                            showFilter: false,
                            // search: location,
                            onTap: () async {
                              // await getAddress(context);
                            },
                            onChange: (v) async {
                              // await getAddress(context);
                            },
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Expanded(
                    //     child: ListView.builder(
                    //         itemCount: 0,
                    //         //s.length,
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 3.w, vertical: 0.h),
                    //         physics: AlwaysScrollableScrollPhysics(
                    //             parent: const ClampingScrollPhysics()),
                    //         shrinkWrap: true,
                    //         itemBuilder: (_, i) => CustomerTile(
                    //               position: (i + 1) >= 1 && (i + 1) <= 3
                    //                   ? (i + 1)
                    //                   : null,
                    //             ))),
                    val.loading
                        ? Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor))
                        : Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child:
                                (val.customersList.isEmpty)
                                    ? Column(
                                      children: [
                                        SizedBox(height: 20.h),
                                        Center(child: CustomEmptyData(title: 'No Customers Found', hasLoader: false)),
                                      ],
                                    )
                                    : ListView(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        for (int i = 0; i < val.customersList.length; i++)
                                          CustomerTile(
                                            model: val.customersList[i],
                                            position: (i + 1) >= 1 && (i + 1) <= 3 ? (i + 1) : null,
                                          ),
                                      ],
                                    ),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future rejectDialog({required Function onTap}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            content: RejectDialog(
              onYes: (v) {
                onTap();
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomerTile extends StatelessWidget {
  const CustomerTile({super.key, this.position, this.model});
  final int? position;
  final User? model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
          AppRouteName.CustomerProfile,
          arguments: ProfileScreenArguments(isMe: false, user: model),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: CustomColors.container.withValues(alpha: 0.8), // Shadow color
                  blurRadius: 10, // Spread of the shadow
                  spreadRadius: 5, // Size of the shadow
                  offset: const Offset(0, 4), // Position of the shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 1.5.h),
            child: Row(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border:
                //           Border.all(color: MyColors().primaryColor, width: 2)),
                //   child: Image.asset(
                //     ImagePath.random7,
                //     scale: 3.2,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                CustomImage(
                  height: 40,
                  width: 40,
                  border: true,
                  shape: BoxShape.circle,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(10),
                  url: model?.profileImage ?? '',
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: MyText(
                          title: "${model?.name ?? ""} ${model?.lastName ?? ""}",
                          fontWeight: FontWeight.w600,
                          size: 14,
                          toverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: .15.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const MyText(title: 'Offers Redeemed:  ', fontWeight: FontWeight.w400, size: 10),
                          Expanded(
                            child: MyText(
                              title: model?.offerCount.toString() ?? '0',
                              clr: CustomColors.primaryGreenColor,
                              fontWeight: FontWeight.bold,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Container(decoration: BoxDecoration(color: MyColors().primaryColor,borderRadius: BorderRadius.circular(20)),
                      //       padding: EdgeInsets.all(4)+EdgeInsets.symmetric(horizontal: 6),
                      //       child: MyText(title: 'Deal 01',clr: MyColors().whiteColor,size: 11,),
                      //     ),
                      //     SizedBox(width: 2.w,),
                      //     Container(decoration: BoxDecoration(color: MyColors().primaryColor,borderRadius: BorderRadius.circular(20)),
                      //       padding: EdgeInsets.all(4)+EdgeInsets.symmetric(horizontal: 6),
                      //       child: MyText(title: 'Food',clr: MyColors().whiteColor,size: 11,),
                      //     ),
                      //     SizedBox(width: 2.w,),
                      //     Expanded(
                      //       child: Row(children: [
                      //         Image.asset(ImagePath.location,color: MyColors().primaryColor,scale: 2,),
                      //         MyText(title: ' Bouddha, Chabil',size: 11,)
                      //       ],),
                      //     ),
                      //     SizedBox(width: 2.w,),
                      //     Container(decoration: BoxDecoration(color: MyColors().primaryColor,borderRadius: BorderRadius.circular(20)),
                      //       padding: EdgeInsets.all(6)+EdgeInsets.symmetric(horizontal: 6),
                      //       child: Row(
                      //         children: [
                      //           Image.asset(ImagePath.coins,color: MyColors().whiteColor,scale: 3,),
                      //           MyText(title: '  500',clr: MyColors().whiteColor,size: 11,),
                      //         ],
                      //       ),
                      //     ),
                      //   ],),
                      // SizedBox(height: .5.h,),
                      // MyText(title: '15% Discount on food and beverage',size: 11,)
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
              ],
            ),
          ),
          if (position != null)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: CustomColors.primaryGreenColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      title: position?.toString() ?? '',
                      size: Utils.isTablet ? 7.sp : 13.sp,
                      clr: CustomColors.whiteColor,
                    ),
                    MyText(
                      title: getPosition(position ?? 0),
                      size: Utils.isTablet ? 5.sp : 9.sp,
                      clr: CustomColors.whiteColor,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String getPosition(int val) {
    switch (val) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return '';
    }
  }
}
