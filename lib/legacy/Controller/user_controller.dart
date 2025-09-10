import 'dart:async';
import 'dart:io';

import 'package:backyard/core/app_router/app_router.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Model/reiview_model.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:backyard/my-backyard-app.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as in_app;
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@singleton
class UserController extends ChangeNotifier {
  UserController() {
    Platform.isAndroid ? Permission.location.request() : Permission.locationAlways.request();

    locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen((event) async {
      if ((geo ?? false) && (_user?.bearerToken != null)) {
        if (onTap && mapController != null) {
          if (user?.role == UserRoleEnum.User) {
            _user = user!.copyWith(latitude: event.latitude, longitude: event.longitude);
          } else {
            lat = event.latitude;
            lng = event.longitude;
          }
          final placemarks = await placemarkFromCoordinates(event.latitude, event.longitude);
          if (user?.role == UserRoleEnum.User) {
            _user = user!.copyWith(address: placemarks[0].locality ?? '');
          } else {
            address = placemarks[0].locality ?? '';
          }
          if (mapController != null && _user?.bearerToken != null && _user!.bearerToken!.isNotEmpty) {
            await mapController?.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(event.latitude, event.longitude), zoom: 13.4746),
              ),
            );
            circles.clear();
            circles.add(
              Circle(
                circleId: const CircleId('myLocation'),
                radius: mile * 1609.344,
                strokeWidth: 1,
                zIndex: 0,
                center: LatLng(event.latitude, event.longitude),
                fillColor: CustomColors.primaryGreenColor.withValues(alpha: .15),
                strokeColor: CustomColors.primaryGreenColor,
              ),
            );
            notifyListeners();
            onTap = false;
            Timer(const Duration(minutes: 10), () {
              onTap = true;
            });
          }
        }
      }
    });
  }

  bool isSwitch = false;
  late StreamSubscription<Position>? locationStream;
  bool onTap = true;
  GoogleMapController? mapController;
  UserProfileModel? _user;

  UserProfileModel? get user => _user;
  bool? geo = true;
  Set<Circle> circles = {};
  Set<Marker> markers = {};
  List<Review> reviews = [];
  double rating = 0;
  List<in_app.ProductDetails> productDetails = [];
  List<UserProfileModel> businessesList = [];
  double lat = 0;
  double lng = 0;
  String address = '';
  int mile =
      50 //25
      ;

  void setMile(int val) {
    mile = val;
    final temp = circles.where((element) => element.circleId == const CircleId('myLocation')).firstOrNull;
    if (temp != null) {
      circles.clear();
      circles.add(
        Circle(
          circleId: const CircleId('myLocation'),
          radius: mile * 1609.344,
          strokeWidth: 1,
          zIndex: 0,
          center: temp.center,
          fillColor: CustomColors.primaryGreenColor.withValues(alpha: .15),
          strokeColor: CustomColors.primaryGreenColor,
        ),
      );
    }
    notifyListeners();
  }

  void setSwitch(bool val) {
    isSwitch = !isSwitch;
    notifyListeners();
  }

  void setRating(double? val) {
    rating = val ?? 0;
    notifyListeners();
  }

  void setReviews(List<Review> val) {
    reviews = val;
    notifyListeners();
  }

  void addReview(Review val) {
    reviews.insert(0, val);
    notifyListeners();
  }

  void setBusList(List<UserProfileModel> val) {
    businessesList = val;
    notifyListeners();
  }

  void setProductDetails(List<in_app.ProductDetails> val) {
    productDetails = val;
    productDetails.sort((a, b) => a.price.length.compareTo(b.price.length));
    notifyListeners();
  }

  void setMapController(GoogleMapController? controller) {
    mapController = controller;
    notifyListeners();
  }

  void addCircles(Circle val) {
    circles.clear();
    circles.add(val);
    notifyListeners();
  }

  void moveMap(CameraUpdate cameraUpdate) {
    mapController?.moveCamera(cameraUpdate);
    notifyListeners();
  }

  void animateMap(CameraUpdate cameraUpdate) {
    mapController?.animateCamera(cameraUpdate);
    notifyListeners();
  }

  Future<void> zoomOutFitBusinesses() async {
    if (businessesList.isEmpty || mapController == null) return;
    final coordinates =
        businessesList
            .where((business) => business.latitude != null && business.longitude != null)
            .map((business) => LatLng(business.latitude!, business.longitude!))
            .toList();

    if (coordinates.isEmpty) return;
    var minLat = coordinates.first.latitude;
    var maxLat = coordinates.first.latitude;
    var minLng = coordinates.first.longitude;
    var maxLng = coordinates.first.longitude;

    for (final coord in coordinates) {
      minLat = coord.latitude < minLat ? coord.latitude : minLat;
      maxLat = coord.latitude > maxLat ? coord.latitude : maxLat;
      minLng = coord.longitude < minLng ? coord.longitude : minLng;
      maxLng = coord.longitude > maxLng ? coord.longitude : maxLng;
    }

    final bounds = LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
    await mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 25.0));
  }

  Future<void> addMarker(UserProfileModel user) async {
    try {
      final markerId = MarkerId(user.id?.toString() ?? '');
      final marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(
          title: user.name,
          snippet:
              (user.subId != 4)
                  ? user.description
                  : '${user.description}\n\nPhone Number:${user.phone}\n${user.address}',
          anchor: const Offset(0, 1),
          onTap:
              () =>
                  (user.subId != 4)
                      ? MyBackyardApp.appRouter.push(
                        UserProfileRoute(isBusinessProfile: true, isMe: false, isUser: false, user: user),
                      )
                      : {},
        ),
        icon: await Utils.createBitmapDescriptorWithText(
          (user.name ?? '').toUpperCase().characters.firstOrNull ?? '',
          smaller: user.subId == 4,
        ),
        position: LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0),
      );

      markers.add(marker);
      notifyListeners();
    } catch (_) {}
  }

  void clearMarkers() {
    markers.clear();
  }

  void setGeo(bool val) {
    geo = val;
    notifyListeners();
  }

  void setCategory(int? id) {
    _user = _user?.copyWith(categoryId: id);
    notifyListeners();
  }

  void setUser(UserProfileModel user) {
    final bearerToken = user.bearerToken == null || user.bearerToken!.isEmpty ? _user?.bearerToken : user.bearerToken;
    _user = user.copyWith(bearerToken: bearerToken);
    notifyListeners();
  }

  void setSubId(UserProfileModel user) {
    _user = _user?.copyWith(subId: user.subId);
    notifyListeners();
  }

  void updateDays(List<BusinessSchedulingModel> days) {
    _user = _user?.copyWith(days: days);
    notifyListeners();
  }

  void setRole(UserRoleEnum val) {
    _user = _user == null ? UserProfileModel(role: val) : _user!.copyWith(role: val);
    notifyListeners();
  }

  Future<void> clear() async {
    final localStorageRepository = getIt<LocalStorageRepository>();
    await localStorageRepository.deleteAll();
    _user = null;
    isSwitch = false;
  }
}
