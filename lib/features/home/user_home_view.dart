import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:backyard/core/repositories/permission_repository.dart';
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
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/app_size.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final location = TextEditingController();

  CategoryModel? selected;
  int i = 99;
  bool filter = false;
  Position? devicePosition;

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Future.wait([GeneralAPIS.getCategories(), getBuses()]));
  }

  Future<void> getBuses() async {
    try {
      await getIt<PermissionRepository>().requestLocationPermission();
      final controller = context.read<UserController>();

      await getIt<PermissionRepository>().requestLocationPermission();
      devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
      await BusAPIS.getBuses(devicePosition?.latitude, devicePosition?.longitude);
      controller.addCircles(
        Circle(
          circleId: const CircleId('myLocation'),
          radius: (controller.mile * 1609.344),
          strokeWidth: 1,
          zIndex: 0,
          center: LatLng(devicePosition?.latitude ?? 0, devicePosition?.longitude ?? 0),
          fillColor: CustomColors.primaryGreenColor.withValues(alpha: .15),
          strokeColor: CustomColors.primaryGreenColor,
        ),
      );
    } catch (e) {
      log('GET BUSES FUNCTION ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeController>(
      builder: (context, value, child) {
        return Stack(
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
                      myLocationButtonEnabled: Utils.isTablet == false,
                      circles: val.circles,
                      myLocationEnabled: true,
                      onMapCreated: (controller) async {
                        await controller.setMapStyle(
                          '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]',
                        );
                        val.setMapController(controller);

                        await getIt<PermissionRepository>().requestLocationPermission();
                        final devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
                        val.moveMap(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(devicePosition.latitude, devicePosition.longitude),
                              zoom: 13.4746,
                            ),
                          ),
                        );
                      },
                      markers: context.watch<UserController>().markers,
                    ),
                    Positioned(
                      right: CustomSpacer.right.xs.right,
                      bottom: 82,
                      child: Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: Container(
                          padding: CustomSpacer.all.md,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: FilterIcon(onTap: () => setState(() => filter = !filter)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 7.h) + EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                  max: 50,
                                  //25
                                  divisions: 10,
                                  value: val.mile.toDouble(),
                                  onChangeEnd: (_) => getBuses(),
                                  onChanged: (radius) => val.setMile(radius.toInt()),
                                ),
                              ),
                              Text(
                                "${val.mile} Mile${val.mile > 1 ? "s" : ""}",
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
