import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/annotations.dart';
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

@RoutePage()
class UserHomeView extends StatefulWidget {
  final bool wantKeepAlive;

  const UserHomeView({super.key, this.wantKeepAlive = false});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setLoading(true);
      await Future.wait([getCategories(), getBuses()]);
      setLoading(false);
    });
  }

  Future<void> getBuses() async {
    try {
      final controller = context.read<UserController>();
      if (Platform.isAndroid) {
        await Permission.location.request();
      } else {
        await Permission.locationAlways.request();
      }

      pos = await Geolocator.getLastKnownPosition();
      if (controller.user?.role == UserRoleEnum.Business) {
        await BusAPIS.getBuses(pos?.latitude, pos?.longitude);
        controller.addCircles(
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
        controller.addCircles(
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

  void setLoading(bool val) => context.read<HomeController>().setLoading(val);

  Future<void> getCategories() async {
    await GeneralAPIS.getCategories();
  }

  @override
  void dispose() {
    context.read<UserController>().setController(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeController>(
      builder: (context, value, child) {
        return value.loading
            ? Center(child: CircularProgressIndicator(color: CustomColors.primaryGreenColor))
            : Stack(
              children: [
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
                            await controller.setMapStyle(
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
                      ],
                    );
                  },
                ),
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
                    ],
                  ),
                ),
              ],
            );
      },
    );
  }

  void confirmSession(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [MyText(title: 'Date:', fontWeight: FontWeight.w600), SizedBox(width: 2.w)],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [MyText(title: 'Cost:', fontWeight: FontWeight.w600), SizedBox(width: 2.w)],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [MyText(title: 'Time:', fontWeight: FontWeight.w600), SizedBox(width: 2.w)],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [MyText(title: 'Duration:', fontWeight: FontWeight.w600), SizedBox(width: 2.w)],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
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

  Future<void> getAddress(context) async {
    final t = await Utils().showPlacePicker(context);
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
        CustomTextFormField(hintText: 'Locations', showLabel: false, backgroundColor: CustomColors.container),
        SizedBox(height: 2.h),
        customTitle(title: 'Discount Percentages'),
        SizedBox(height: 1.h),
        CustomTextFormField(
          hintText: 'Discount Percentages',
          maxLength: 2,
          inputType: TextInputType.number,
          showLabel: false,
          onlyNumber: true,
          backgroundColor: CustomColors.container,
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
