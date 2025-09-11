import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:backyard/core/repositories/permission_repository.dart';
import 'package:backyard/features/home/widget/model/offers_filter_model.dart';
import 'package:backyard/features/home/widget/widget/offers_filter_bottom_sheet.dart';
import 'package:backyard/legacy/Component/Appbar/appbar_components.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Service/bus_apis.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
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

  int i = 99;
  Position? devicePosition;
  CategoryModel? selectedCategory;

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeController>(
      builder: (context, value, child) {
        return Stack(
          children: [
            Consumer<UserController>(
              builder: (context, userController, _) {
                return Stack(
                  children: [
                    GoogleMap(
                      padding: Utils.isTablet ? EdgeInsets.only(top: 11.h, right: 2.w) : EdgeInsets.zero,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(userController.user?.latitude ?? 0, userController.user?.longitude ?? 0),
                        zoom: 14.4746,
                      ),
                      myLocationButtonEnabled: Utils.isTablet == false,
                      circles: userController.circles,
                      myLocationEnabled: true,
                      onMapCreated: onMapCreated,
                      markers: context.watch<UserController>().markers,
                    ),
                    if (userController.mapController != null)
                      Positioned(
                        right: CustomSpacer.right.xs.right,
                        bottom: 82,
                        child: Material(
                          elevation: 4,
                          shape: const CircleBorder(),
                          child: Container(
                            padding: CustomSpacer.all.md,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: FilterIcon(onTap: onFilterTap),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onFilterTap() async {
    final userController = context.read<UserController>();
    final currentFilter = userController.offersFilter;
    final filterResult = await showOffersFilterBottomSheet(context: context, filter: currentFilter);

    if (filterResult == null || filterResult == userController.offersFilter) return;
    userController.setOffersFilter(filterResult);

    return loadBusinesses();
  }

  Future<void> loadBusinesses() async {
    try {
      await getIt<PermissionRepository>().requestLocationPermission();
      devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
      await BusinessAPIS.getBusinesses(devicePosition?.latitude, devicePosition?.longitude);
    } catch (e) {
      log('GET BUSES FUNCTION ERROR: $e');
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await controller.setMapStyle(
      '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]',
    );

    final userController = context.read<UserController>();
    userController.setMapController(controller);

    await getIt<PermissionRepository>().requestLocationPermission();
    final devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
    final offersFilter = userController.offersFilter.copyWith(
      latitude: devicePosition.latitude,
      longitude: devicePosition.longitude,
    );

    userController.setOffersFilter(offersFilter);
    userController.moveMap(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(devicePosition.latitude, devicePosition.longitude), zoom: 13.4746),
      ),
    );

    return loadBusinesses();
  }
}
