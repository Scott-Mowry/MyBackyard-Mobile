import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:backyard/boot.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Component/custom_bottomsheet_indicator.dart';
import 'package:backyard/legacy/Component/custom_buttom.dart';
import 'package:backyard/legacy/Component/custom_dropdown.dart';
import 'package:backyard/legacy/Component/custom_radio_tile.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/category_product_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Service/socket_service.dart';
import 'package:backyard/legacy/Utils/app_size.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  TextEditingController date = TextEditingController(),
      time = TextEditingController(),
      location = TextEditingController(),
      duration = TextEditingController();
  TimeOfDay t = TimeOfDay.now();
  List<Category> categories = [
    Category(id: 'Category 1', categoryName: 'Category 1'),
    Category(id: 'Category 2', categoryName: 'Category 2'),
    Category(id: 'Category 3', categoryName: 'Category 3'),
  ];
  CategoryModel? selected;
  int i = 99;
  bool filter = false;
  bool onTap = true;
  Position? pos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await Future.wait([getCategories(), getBuses()]);
      setLoading(false);
    });
  }

  Future<void> getBuses() async {
    try {
      final controller = navigatorKey.currentContext?.read<UserController>();
      if (Platform.isAndroid) {
        Permission.location.request();
      } else {
        Permission.locationAlways.request();
      }
      pos = await Geolocator.getLastKnownPosition();
      if (controller?.user?.role == UserRoleEnum.Business) {
        await BusAPIS.getBuses(pos?.latitude, pos?.longitude);
        // controller?.moveMap(CameraUpdate.newCameraPosition(CameraPosition(
        //     target: LatLng(pos?.latitude ?? 0, pos?.longitude ?? 0),
        //     zoom: 13.4746)));
        controller?.addCircles(
          Circle(
            circleId: const CircleId('myLocation'),
            radius: (controller.mile * 1609.344),
            strokeWidth: 1,
            zIndex: 0,
            center: LatLng(pos?.latitude ?? 0, pos?.longitude ?? 0),
            fillColor: CustomColors.primaryGreenColor.withValues(alpha: .15),
            strokeColor: CustomColors.primaryGreenColor,
          ),
        );
      } else {
        await BusAPIS.getBuses(pos?.latitude, pos?.longitude);
        // controller?.moveMap(CameraUpdate.newCameraPosition(CameraPosition(
        //     target: LatLng(pos?.latitude ?? 0, pos?.longitude ?? 0),
        //     zoom: 13.4746)));
        controller?.addCircles(
          Circle(
            circleId: const CircleId('myLocation'),
            radius: (controller.mile * 1609.344),
            strokeWidth: 1,
            zIndex: 0,
            center: LatLng(pos?.latitude ?? 0, pos?.longitude ?? 0),
            fillColor: CustomColors.primaryGreenColor.withValues(alpha: .15),
            strokeColor: CustomColors.primaryGreenColor,
          ),
        );
      }
    } catch (e) {
      log('GET BUSES FUNCTION ERROR: $e');
    }
  }

  void setLoading(bool val) {
    navigatorKey.currentContext?.read<HomeController>().setLoading(val);
  }

  Future<void> getCategories() async {
    await GeneralAPIS.getCategories();
  }

  @override
  void dispose() {
    navigatorKey.currentContext?.read<UserController>().setController(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, value, child) {
        return
        // GetBuilder<MapsController>(builder: (d) { return
        value.loading
            ? Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor))
            : Stack(
              children: [
                // GlobalController.values.location.isFalse?
                // GestureDetector(
                //   onTap: () async{
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 5.w),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         MyButton(
                //           title: 'Enable Location',onTap: () async{
                //           setState(() {});
                //           await Utils().requestLocation(openSettings: true);
                //           GlobalController.values.isLocationServiceEnabled();
                //           HomeController.i.setLocation();
                //           GlobalController.values.update();
                //           setState(() {});
                //         },),
                //       ],
                //     ),
                //   ),
                // ):
                Consumer<UserController>(
                  builder: (context, val, _) {
                    return Stack(
                      children: [
                        GoogleMap(
                          padding: Utils.isTablet ? EdgeInsets.only(top: 11.h, right: 2.w) : EdgeInsets.zero,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(val.user?.latitude ?? 0, val.user?.longitude ?? 0),
                            zoom: 14.4746,
                          ),
                          myLocationButtonEnabled: Utils.isTablet == false, //true
                          circles: val.circles,
                          myLocationEnabled: true,
                          onMapCreated: (controller) async {
                            controller.setMapStyle(
                              '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]',
                            );
                            val.setController(controller);
                            final pos = await Geolocator.getLastKnownPosition();
                            val.moveMap(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: LatLng(pos?.latitude ?? 0, pos?.longitude ?? 0), zoom: 13.4746),
                              ),
                            );
                          },
                          markers: context.watch<UserController>().markers,
                        ),
                        // Positioned(
                        //     left: 10,
                        //     bottom: 100,
                        //     child: Image.asset(ImagePath.appLogo,
                        //         width: 45,
                        //         height: 45,
                        //         opacity: const AlwaysStoppedAnimation(.4))),
                        // Positioned(
                        //   right: 10,
                        //   bottom: 100,
                        //   child: Consumer<UserController>(
                        //       builder: (context, val, _) {
                        //     return GestureDetector(
                        //       onTap: () async =>
                        //           await Geolocator.getLastKnownPosition()
                        //               .then((value) => val.animateMap(
                        //                   CameraUpdate.newCameraPosition(
                        //                       CameraPosition(
                        //                           target: LatLng(
                        //                               value?.latitude ?? 0,
                        //                               value?.longitude ??
                        //                                   0),
                        //                           zoom: 13.4746))))
                        //               .onError((error, stackTrace) =>
                        //       child: Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //             color: MyColors().whiteColor,
                        //             borderRadius:
                        //                 BorderRadius.circular(10)),
                        //         child: Icon(Icons.my_location_outlined,
                        //             color: MyColors().primaryColor),
                        //       ),
                        //     );
                        //   }),
                        // )
                      ],
                    );
                  },
                ),
                // GestureDetector(
                //   onTap: () {
                //     FocusManager.instance.primaryFocus?.unfocus();
                //   },
                //   child:
                Container(
                  decoration: BoxDecoration(
                    color: Utils.isTablet ? null : CustomColors.whiteColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                    boxShadow:
                        Utils.isTablet
                            ? null
                            : [
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: CustomAppBar(
                          screenTitle: 'Home',
                          leading:
                              Utils.isTablet
                                  ? Opacity(
                                    opacity: .8,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MenuIcon(),
                                    ),
                                  )
                                  : MenuIcon(),
                          trailing: Row(
                            children: [
                              Utils.isTablet
                                  ? Opacity(
                                    opacity: .8,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                          onTap
                                              ? FilterIcon(
                                                onTap:
                                                    () => [
                                                      FocusManager.instance.primaryFocus?.unfocus(),
                                                      setState(() => filter = !filter),
                                                    ],
                                              )
                                              : CircularProgressIndicator(color: CustomColors.greenColor),
                                    ),
                                  )
                                  : FilterIcon(
                                    onTap:
                                        () => [
                                          FocusManager.instance.primaryFocus?.unfocus(),
                                          setState(() => filter = !filter),
                                        ],
                                  ),
                              SizedBox(width: 4.w),
                              Utils.isTablet
                                  ? Opacity(
                                    opacity: .8,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: NotificationIcon(),
                                    ),
                                  )
                                  : NotificationIcon(),
                            ],
                          ),
                          bottom: 2.h,
                        ),
                      ),

                      if (filter) ...[
                        Consumer<UserController>(
                          builder: (context, val, _) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      min: 5,
                                      max: 50, //25
                                      divisions: 10,
                                      value: val.mile.toDouble(),
                                      onChangeEnd:
                                          (v) => SocketService.instance?.socketEmitMethod(
                                            eventName: 'get_buses',
                                            eventParamaters: {
                                              'lat': pos?.latitude,
                                              'long': pos?.longitude,
                                              'radius': val.mile,
                                            },
                                          ),
                                      onChanged: (v) => val.setMile(v.toInt()),
                                    ),
                                  ),
                                  Text(
                                    "${val.mile} Mile${val.mile > 1 ? "s" : ""}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      //         SearchTile(
                      //           showFilter: true,
                      //           search: location,
                      //           readOnly: true,
                      //           onTap: () async {
                      //             await getAddress(context);
                      //           },
                      //           onTapFilter: () {
                      //             filter = !filter;
                      //             setState(() {});
                      //           },
                      //           onChange: (v) async {
                      //             // await getAddress(context);
                      //           },
                      //         ),
                      //         SizedBox(
                      //           height: 2.h,
                      //         ),
                      //         if (filter) ...[
                      //           filterSheet(value.categories ?? []),
                      //           SizedBox(
                      //             height: 2.h,
                      //           ),
                      //         ],
                    ],
                  ),
                  //     // CustomAppBar(screenTitle:"Location",leading: CustomBackButton(),titleColor: MyColors().black,),
                  //   ),
                ),
              ],
            );
      },
    );
    // });
  }

  // void createSession(context) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       // backgroundColor: MyColors().whiteColor,
  //       builder: (BuildContext bc) {
  //         return StatefulBuilder(builder:
  //             (BuildContext context, StateSetter s /*You can rename this!*/) {
  //           return Container(
  //             padding: EdgeInsets.all(4.w),
  //             decoration: BoxDecoration(
  //                 color: MyColors().whiteColor,
  //                 borderRadius: BorderRadius.vertical(
  //                     top: Radius.circular(AppSize.BOTTOMSHEETRADIUS))),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 BottomSheetIndicator(),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 MyText(
  //                   title: 'Book Session',
  //                   fontWeight: FontWeight.w600,
  //                   size: 20,
  //                 ),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 MyTextField(
  //                   prefixWidget: Image.asset(ImagePath.location2,
  //                       scale: 2, color: MyColors().secondaryColor),
  //                   controller: location,
  //                   hintText: 'Location',
  //                   backgroundColor: MyColors().secondaryColor.withValues(alpha: .3),
  //                   borderColor: MyColors().secondaryColor,
  //                   hintTextColor: MyColors().grey,
  //                   textColor: MyColors().black,
  //                   readOnly: true,
  //                   onTap: () async {
  //                     await getAddress(context);
  //                   },
  //                 ),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 Row(
  //                   children: [
  //                     Flexible(
  //                       child: MyTextField(
  //                         controller: date,
  //                         prefixWidget: Image.asset(
  //                           ImagePath.calendar,
  //                           scale: 2,
  //                           color: MyColors().secondaryColor,
  //                         ),
  //                         hintText: 'Pick Date',
  //                         backgroundColor:
  //                             MyColors().secondaryColor.withValues(alpha: .3),
  //                         borderColor: MyColors().secondaryColor,
  //                         hintTextColor: MyColors().grey,
  //                         textColor: MyColors().black,
  //                         readOnly: true,
  //                         onTap: () async {
  //                           FocusManager.instance.primaryFocus?.unfocus();
  //                           date.text = await Utils().selectDate(context,
  //                               initialDate: date.text != ''
  //                                   ? Utils().convertToDateTime(d: date.text)
  //                                   : null,
  //                               firstDate: DateTime.now(),
  //                               lastDate:
  //                                   DateTime.now().add(Duration(days: 365)));
  //                         },
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 3.w,
  //                     ),
  //                     Flexible(
  //                       child: MyTextField(
  //                         controller: time,
  //                         prefixWidget: Image.asset(
  //                           ImagePath.clock,
  //                           scale: 2,
  //                         ),
  //                         textColor: MyColors().black,
  //                         hintText: 'Pick Time',
  //                         backgroundColor:
  //                             MyColors().secondaryColor.withValues(alpha: .3),
  //                         borderColor: MyColors().secondaryColor,
  //                         hintTextColor: MyColors().grey,
  //                         readOnly: true,
  //                         onTap: () async {
  //                           FocusManager.instance.primaryFocus?.unfocus();
  //                           await Utils().selectTime(context, onTap: (v) {
  //                             time.text = v.format(context);
  //                             t = v;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 MyTextField(
  //                   controller: duration,
  //                   prefixWidget: Image.asset(
  //                     ImagePath.clock,
  //                     scale: 2,
  //                   ),
  //                   hintText: 'Duration (min)',
  //                   textColor: MyColors().black,
  //                   backgroundColor: MyColors().secondaryColor.withValues(alpha: .3),
  //                   borderColor: MyColors().secondaryColor,
  //                   hintTextColor: MyColors().grey,
  //                   maxLength: 3,
  //                   inputType: TextInputType.number,
  //                   onlyNumber: true,
  //                 ),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 MyButton(
  //                   title: 'Continue',
  //                   onTap: () {
  //                     onSubmit(context);
  //                   },
  //                 ),
  //                 SizedBox(
  //                   height: 2.h,
  //                 ),
  //                 SizedBox(
  //                   height: MediaQuery.viewInsetsOf(context).bottom,
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  void confirmSession(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // backgroundColor: MyColors().whiteColor,
      builder: (bc) {
        return StatefulBuilder(
          builder: (context, s /*You can rename this!*/) {
            return Consumer<HomeController>(
              builder: (context, val, _) {
                return Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.BOTTOMSHEETRADIUS)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BottomSheetIndicator(),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(ImagePath.location2, scale: 2),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText(title: 'Current Location', size: 16, fontWeight: FontWeight.w600),
                                      // MyText(
                                      //   title: d.currentSession.value.location
                                      //           ?.address ??
                                      //       '',
                                      //   clr: MyColors().grey,
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // MyText(
                          //   title: '${d.currentSession.value.distance ?? 0} km',
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // d.currentSession.value.trainer == null
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Loader(),
                      //           SizedBox(
                      //             height: 1.h,
                      //           ),
                      //           MyText(title: 'Looking for Trainer'),
                      //         ],
                      //       )
                      //     : Container(
                      //         decoration: BoxDecoration(
                      //             color:
                      //                 MyColors().secondaryColor.withValues(alpha: .3),
                      //             borderRadius: BorderRadius.circular(100),
                      //             border: Border.all(
                      //               color: MyColors().secondaryColor,
                      //             )),
                      //         padding: EdgeInsets.all(2.w),
                      //         child: Row(
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             CustomImage(
                      //               url:
                      //                   d.currentSession.value.trainer?.userImage,
                      //               isProfile: true,
                      //               photoView: false,
                      //               height: 6.h,
                      //               width: 6.h,
                      //               radius: 200,
                      //               fit: BoxFit.cover,
                      //             ),
                      //             SizedBox(
                      //               width: 3.w,
                      //             ),
                      //             Expanded(
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   MyText(
                      //                     title: d.currentSession.value.trainer
                      //                             ?.fullName ??
                      //                         '',
                      //                     size: 13,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                   Row(
                      //                     children: [
                      //                       Image.asset(
                      //                         ImagePath.star,
                      //                         scale: 2,
                      //                       ),
                      //                       MyText(
                      //                         title:
                      //                             ' ${d.currentSession.value.trainer?.totalReviews}',
                      //                         size: 13,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                       MyText(
                      //                           title:
                      //                               ' (${d.currentSession.value.trainer?.avgRating})',
                      //                           size: 13,
                      //                           fontStyle: FontStyle.italic),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               width: 3.w,
                      //             ),
                      //             MyText(
                      //               title: 'Trainer',
                      //               size: 12,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                MyText(title: 'Date:', fontWeight: FontWeight.w600),
                                SizedBox(width: 2.w),
                                // MyText(
                                //   title: d.currentSession.value.pickDate,
                                //   clr: MyColors().grey,
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyText(title: 'Cost:', fontWeight: FontWeight.w600),
                                SizedBox(width: 2.w),
                                // MyText(
                                //   title: '\$ ${d.currentSession.value.cost}',
                                //   clr: MyColors().grey,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                MyText(title: 'Time:', fontWeight: FontWeight.w600),
                                SizedBox(width: 2.w),
                                // MyText(
                                //   title: d.currentSession.value.pickTime,
                                //   clr: MyColors().grey,
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyText(title: 'Duration:', fontWeight: FontWeight.w600),
                                SizedBox(width: 2.w),
                                // MyText(
                                //   title: '${d.currentSession.value.duration}',
                                //   clr: MyColors().grey,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // MyButton(
                      //   title:
                      //       HomeController.i.currentSession.value.trainer == null
                      //           ? 'Cancel'
                      //           : 'Continue',
                      //   onTap: () {
                      //     AppNavigation.navigatorPop(context);
                      //     if (HomeController.i.currentSession.value.trainer ==
                      //         null) {
                      //       HomeController.i.cancelSession(
                      //           id: HomeController.i.currentSession.value.id);
                      //     } else {
                      //       paymentDialog();
                      //     }
                      //   },
                      // ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

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

  void onSubmit(context) {
    // var h = HomeController.i;
    // h.address = location.text;
    // h.date = date.text;
    // h.time = time.text;
    // h.duration = duration.text;
    // h.bookingValidation(context, onSuccess: () {
    //   AppNavigation.navigatorPop();
    //   confirmSession(context);
    // });
  }

  Future<void> getAddress(context) async {
    // Prediction? p = await PlacesAutocomplete.show(offset: 0, logo: const Text(""), types: [], strictbounds: false, context: context, apiKey: Utils.googleApiKey, mode: Mode.overlay, language: "us",);
    // if(p!=null){
    //   location.text = p.description??'';
    // }
    final t = await Utils().showPlacePicker(context);
    // Map<String,dynamic> temp=  await Utils.findStreetAreaMethod(context:context,prediction: t.formattedAddress.toString());

    // HomeController.i.currentLocation =
    //     LatLng(t.latLng?.latitude ?? 0, t.latLng?.longitude ?? 0);
    // mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: HomeController.i.currentLocation, zoom: 14.4746)));
    // MapsController.i.getMarkers(l: HomeController.i.currentLocation);
    location.text = t.formattedAddress ?? '';
  }

  Column filterSheet(List<CategoryModel> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTitle(title: 'Select Category'),
        SizedBox(height: 1.h),
        CustomDropDown2(
          hintText: 'Select Category',
          bgColor: CustomColors.container,
          dropDownData: list,
          dropdownValue: selected,
          validator: (v) {
            selected = v;
            return null;
          },
        ),
        SizedBox(height: 2.h),
        customTitle(title: 'Locations'),
        SizedBox(height: 1.h),
        CustomTextFormField(
          hintText: 'Locations',
          // controller: name,
          // maxLength: 2,
          // inputType: TextInputType.number,
          showLabel: false,
          // onlyNumber: true,
          backgroundColor: CustomColors.container,
          // borderColor: MyColors().secondaryColor,
          // hintTextColor: MyColors().grey,
          // textColor: MyColors().black,
        ),
        SizedBox(height: 2.h),
        customTitle(title: 'Discount Percentages'),
        SizedBox(height: 1.h),
        CustomTextFormField(
          hintText: 'Discount Percentages',
          // controller: name,
          maxLength: 2,
          inputType: TextInputType.number,
          showLabel: false,
          onlyNumber: true,
          backgroundColor: CustomColors.container,
          // borderColor: MyColors().secondaryColor,
          // hintTextColor: MyColors().grey,
          // textColor: MyColors().black,
        ),
        SizedBox(height: 2.h),
        customTitle(title: 'Search By Rating'),
        SizedBox(height: 1.h),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                i = index;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 1.h),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    CustomRadioTile(v: (i == index), color: CustomColors.black),
                    SizedBox(width: 2.w),
                    RatingBar(
                      initialRating: 4,
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
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        MyButton(
          title: 'Set Filter',
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            filter = false;
            setState(() {});
            CustomToast().showToast(message: 'Filter updated successfully');
          },
        ),
      ],
    );
  }

  Padding customTitle({required String title}) {
    return Padding(padding: EdgeInsets.only(left: 0.w), child: MyText(title: title, fontWeight: FontWeight.w600));
  }
}
