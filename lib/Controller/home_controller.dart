import 'package:backyard/Model/category_model.dart';
import 'package:backyard/Model/offer_model.dart';
import 'package:backyard/Model/places_model.dart';
import 'package:backyard/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:backyard/Model/card_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class HomeController extends ChangeNotifier {
  HomeController({required this.context});
  BuildContext context;
  GlobalKey<ScaffoldState>? drawerKey;

  void setGlobalKey(GlobalKey<ScaffoldState>? key) {
    drawerKey = key;
  }

  int currentIndex = 0;
  LatLng currentLocation = const LatLng(40.76317565846268, -73.99172240955043);

  String adminID = '';

  bool loading = true;

  List<User> _customers = [];
  List<User> get customers => _customers;

  void setCustomers(List<User> val) {
    _customers = val;
    notifyListeners();
  }

  void setLoading(bool val) {
    loading = val;
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
      _offers![ind ?? 0].isAvailed = 1;
    }
    notifyListeners();
  }

  void searchOffer(String val) {
    searchOffers = _offers
        ?.where((element) =>
            ((element.title ?? "").toLowerCase()).contains(val.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void addOffers(Offer val) {
    val.category = _categories
        ?.where((element) => element.id == val.categoryId)
        .firstOrNull;
    _offers?.add(val);
    notifyListeners();
  }

  void editOffers(Offer val) {
    final ind = _offers?.indexWhere((element) => element.id == val.id);
    if (ind != -1) {
      _offers![ind ?? 0] = val;
      _offers![ind ?? 0].category = _categories
          ?.where((element) => element.id == val.categoryId)
          .firstOrNull;
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

  List<PlacesModel>? _places;
  List<PlacesModel>? get places => _places;

  void setPlaces(List<PlacesModel>? model) {
    _places = model;
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
  List<User> _customersList = [];
  List<User> get customersList => _customersList;

  void setCustomersList(List<User> model) {
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

  jumpTo({required int i}) {
    currentIndex = i;
    homeBottom.jumpToTab(i);

    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /// Chats end
}
