import 'dart:async';
import 'dart:io';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:backyard/legacy/Arguments/profile_screen_arguments.dart';
import 'package:backyard/legacy/Model/reiview_model.dart';
import 'package:backyard/legacy/Model/user_model.dart';
import 'package:backyard/legacy/Service/navigation_service.dart';
import 'package:backyard/legacy/Utils/app_router_name.dart';
import 'package:backyard/legacy/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as in_app;
import 'package:permission_handler/permission_handler.dart';

class UserController extends ChangeNotifier {
  UserController({required this.context}) {
    Platform.isAndroid ? Permission.location.request() : Permission.locationAlways.request();

    locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen((event) async {
      if ((geo ?? false) && (_user?.token != null)) {
        if (onTap && mapController != null) {
          if (user?.role == UserRoleEnum.User) {
            _user?.latitude = event.latitude;
            _user?.longitude = event.longitude;
          } else {
            lat = event.latitude;
            lng = event.longitude;
          }
          final placemarks = await placemarkFromCoordinates(event.latitude, event.longitude);
          if (user?.role == UserRoleEnum.User) {
            _user?.address = placemarks[0].locality ?? '';
          } else {
            address = placemarks[0].locality ?? '';
          }
          if (mapController != null && _user?.token != null && _user!.token!.isNotEmpty) {
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
  BuildContext context;
  User? _user;

  User? get user => _user;
  bool? geo = true;
  Set<Circle> circles = {};
  Set<Marker> markers = {};
  List<Review> reviews = [];
  double rating = 0;
  List<in_app.ProductDetails> productDetails = [];
  bool loading = false;
  bool purchaseLoading = false;
  List<User> busList = [];
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

  void setBusList(List<User> val) {
    busList = val;
    notifyListeners();
  }

  void setPurchaseLoading(bool val) {
    purchaseLoading = val;
    notifyListeners();
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setProductDetails(List<in_app.ProductDetails> val) {
    productDetails = val;
    productDetails.sort((a, b) => a.price.length.compareTo(b.price.length));
    notifyListeners();
  }

  void setController(GoogleMapController? controller) {
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

  Future<void> addMarker(User user) async {
    final markerId = MarkerId(user.id?.toString() ?? '');
    final marker = Marker(
      // onTap: () => AppNavigation.navigateTo(AppRouteName.USER_PROFILE_ROUTE,
      //     arguments: ProfileScreenArguments(
      //         isBusinessProfile: true, isMe: false, isUser: false, user: user)),
      markerId: markerId,
      infoWindow: InfoWindow(
        title: user.name,
        snippet:
            (user.subId != 4) ? user.description : '${user.description}\n\nPhone Number:${user.phone}\n${user.address}',
        anchor: const Offset(0, 1),
        onTap:
            () =>
                (user.subId != 4)
                    ? AppNavigation.navigateTo(
                      AppRouteName.USER_PROFILE_ROUTE,
                      arguments: ProfileScreenArguments(
                        isBusinessProfile: true,
                        isMe: false,
                        isUser: false,
                        user: user,
                      ),
                    )
                    : {},
      ),
      icon: await Utils.createBitmapDescriptorWithText(
        (user.name ?? '').toUpperCase().characters.firstOrNull ?? '',
        smaller: user.subId == 4,
      ),
      // Utils.getNetworkImageMarker2(
      //     API.public_url + (user.profileImage ?? ""))
      position: LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0),
    );
    markers.add(marker);
    // markers.refresh();
    notifyListeners();
  }

  void clearMarkers() {
    markers.clear();
  }

  void setGeo(bool val) {
    geo = val;
    notifyListeners();
  }

  void setCategory(int? id) {
    _user?.categoryId = id;
    notifyListeners();
  }

  void setUser(User user, {bool isNotToken = false}) {
    String? token;
    if (isNotToken) {
      token = _user?.token;
      _user = user;
      _user?.token = token;
    } else {
      _user = user;
    }

    notifyListeners();
  }

  void setSubId(User user) {
    _user?.subId = user.subId;
    notifyListeners();
  }

  void updateDays(List<BussinessScheduling> days) {
    _user?.days = days;
    notifyListeners();
  }

  void setRole(UserRoleEnum val) {
    if (_user == null) {
      _user = User(role: val);
    } else {
      _user?.setRole = val;
    }
    notifyListeners();
  }

  Future<void> clear() async {
    final localStorageRepository = getIt<LocalStorageRepository>();
    await localStorageRepository.deleteAll();
    _user = null;
    isSwitch = false;
  }
}
