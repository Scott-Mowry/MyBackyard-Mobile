import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_spacer.dart';
import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:backyard/core/repositories/permission_repository.dart';
import 'package:backyard/features/home/widget/model/filter_model.dart';
import 'package:backyard/features/home/widget/widget/business_card_widget.dart';
import 'package:backyard/features/home/widget/widget/filter_bottom_sheet.dart';
import 'package:backyard/legacy/Component/custom_empty_data.dart';
import 'package:backyard/legacy/Component/custom_text.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:backyard/legacy/Service/general_apis.dart';
import 'package:backyard/legacy/Utils/image_path.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  final _draggableScrollableController = DraggableScrollableController();
  double _sheetSize = 0.4;

  @override
  void initState() {
    super.initState();
    _draggableScrollableController.addListener(_onSheetSizeChanged);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          height: MediaQuery.sizeOf(context).height * (1 - _sheetSize),
          child: Consumer<UserController>(
            builder: (context, userController, _) {
              final user = userController.user;
              return GoogleMap(
                padding: Utils.isTablet ? EdgeInsets.only(top: 11.h, right: 2.w) : EdgeInsets.zero,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(user?.latitude ?? 0, user?.longitude ?? 0),
                  zoom: 14.4746,
                ),
                myLocationButtonEnabled: Utils.isTablet == false,
                circles: userController.circles,
                myLocationEnabled: true,
                onMapCreated: onMapCreated,
                markers: context.watch<UserController>().markers,
              );
            },
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: _sheetSize,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          controller: _draggableScrollableController,
          builder: (context, scrollController) {
            return Consumer2<UserController, HomeController>(
              builder: (context, userController, homeController, _) {
                final businessesList = userController.businessesList;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, -5), blurRadius: 10)],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: CustomSpacer.horizontal.md + CustomSpacer.top.md,
                    physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(title: 'Nearby Business', size: 16, fontWeight: FontWeight.w600),
                            InkWell(onTap: onFilterTap, child: Image.asset(ImagePath.filterIcon, scale: 2)),
                          ],
                        ),
                        if (businessesList.isEmpty) ...[
                          Center(child: CustomEmptyData(title: 'No businesses found', hasLoader: false)),
                        ] else
                          ...businessesList.map(
                            (business) => Padding(
                              padding: CustomSpacer.top.md,
                              child: BusinessCardWidget(
                                business: business,
                                category: homeController.categories?.firstWhereOrNull(
                                  (el) => el.id == business.categoryId,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _onSheetSizeChanged() {
    if (_draggableScrollableController.size == _sheetSize) return;
    setState(() => _sheetSize = _draggableScrollableController.size);
  }

  Future<void> onFilterTap() async {
    final homeController = context.read<HomeController>();
    if (homeController.categories == null || homeController.categories!.isEmpty) await GeneralAPIS.getCategories();
    final categories = homeController.categories ?? [];

    final userController = context.read<UserController>();
    final currentFilter = userController.filter;
    final filterResult = await showFilterBottomSheet(context: context, filter: currentFilter, categories: categories);

    if (filterResult == null || filterResult == userController.filter) return;
    userController.setOffersFilter(filterResult);

    return loadBusinesses();
  }

  Future<void> loadBusinesses() async {
    try {
      final userController = context.read<UserController>();
      final devicePosition = await getIt<GeolocatorRepository>().loadCurrentPosition();
      final offersFilter = userController.filter.copyWith(
        latitude: devicePosition.latitude,
        longitude: devicePosition.longitude,
      );

      userController.setOffersFilter(offersFilter);
      await BusinessAPIS.getBusinesses(offersFilter);
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
    final filter = userController.filter.copyWith(
      latitude: devicePosition.latitude,
      longitude: devicePosition.longitude,
    );

    userController.setOffersFilter(filter);
    userController.moveMap(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(devicePosition.latitude, devicePosition.longitude), zoom: 13.4746),
      ),
    );

    await GeneralAPIS.getCategories();
    await loadBusinesses();
  }

  @override
  void dispose() {
    _draggableScrollableController.removeListener(_onSheetSizeChanged);
    super.dispose();
  }
}
