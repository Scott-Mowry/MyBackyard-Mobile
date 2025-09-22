import 'dart:ui' as ui;

import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/legacy/Model/card_model.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

@singleton
class HomeController extends ChangeNotifier {
  int currentIndex = 0;
  LatLng currentLocation = const LatLng(40.76317565846268, -73.99172240955043);

  String adminID = '';

  List<UserProfileModel> _customers = [];

  List<UserProfileModel> get customers => _customers;

  void setCustomers(List<UserProfileModel> val) {
    _customers = val;
    notifyListeners();
  }

  List<Offer>? _offers;
  List<Offer>? searchOffers = [];

  List<Offer>? get offers => _offers;

  void setOffers(List<Offer>? val) {
    _offers = val;
    notifyListeners();
  }

  void availOffer(String id) {
    final ind = _offers?.indexWhere((element) => element.id.toString() == id);
    if (ind != -1) {
      _offers![ind ?? 0] = _offers![ind ?? 0].copyWith(isAvailed: 1);
    }
    notifyListeners();
  }

  void searchOffer(String val) {
    searchOffers =
        _offers?.where((element) => ((element.title ?? '').toLowerCase()).contains(val.toLowerCase())).toList();
    notifyListeners();
  }

  void addOffers(Offer val) {
    final newOffer = val.copyWith(category: _categories?.where((element) => element.id == val.categoryId).firstOrNull);
    _offers?.add(newOffer);
    notifyListeners();
  }

  void editOffers(Offer val) {
    final ind = _offers?.indexWhere((element) => element.id == val.id);
    if (ind != -1) {
      _offers![ind ?? 0] = val.copyWith(
        category: _categories?.where((element) => element.id == val.categoryId).firstOrNull,
      );
    }
    notifyListeners();
  }

  void deleteOffers(String id) {
    final ind = _offers?.indexWhere((element) => element.id.toString() == id);
    if (ind != -1) {
      _offers?.removeAt(ind ?? 0);
    }
    notifyListeners();
  }

  List<CategoryModel>? _categories;

  List<CategoryModel>? get categories => _categories;

  void setCategories(List<CategoryModel>? model) {
    _categories = model;
    notifyListeners();
  }

  //Customer Offers
  List<Offer> _customerOffers = [];

  List<Offer> get customerOffers => _customerOffers;

  void setCustomerOffers(List<Offer> model) {
    _customerOffers = model;
    notifyListeners();
  }

  //Customers
  List<UserProfileModel> _customersList = [];

  List<UserProfileModel> get customersList => _customersList;

  void setCustomersList(List<UserProfileModel> model) {
    _customersList = model;
    notifyListeners();
  }

  ///Card
  List<CardModel>? cards;

  PersistentTabController homeBottom = PersistentTabController(initialIndex: 0);

  void setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }

  void jumpTo({required int i}) {
    currentIndex = i;
    homeBottom.jumpToTab(i);

    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  /// Chats end
}
