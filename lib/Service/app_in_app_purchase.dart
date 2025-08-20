import 'dart:developer';

import 'package:backyard/Component/custom_toast.dart';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/main.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AppInAppPurchase {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  // Initialize a singleton instance
  static final AppInAppPurchase _instance = AppInAppPurchase._internal();
  factory AppInAppPurchase() => _instance;
  AppInAppPurchase._internal();

  // Connect to the store
  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      // Handle store not available scenario
      debugPrint('The store is not available');
      return;
    }
    // Load or refresh subscriptions here if needed
  }

  // Fetch products
  Future<void> fetchSubscriptions(List<String> ids) async {
    navigatorKey.currentContext?.read<UserController>().setLoading(true);
    navigatorKey.currentContext?.read<UserController>().setProductDetails([]);
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(ids.toSet());
    navigatorKey.currentContext?.read<UserController>().setLoading(false);
    if (response.error != null) {
      // Handle errors here
      CustomToast().showToast(
          message: 'Failed to fetch subscriptions: ${response.error!.message}');
      debugPrint('Failed to fetch subscriptions: ${response.error!.message}');
      return;
    }

    if (response.productDetails.isEmpty) {
      CustomToast().showToast(message: "No products found.");
    } else {
      List<ProductDetails> temp = response.productDetails;
      // Now you can safely access product details
      for (ProductDetails product in response.productDetails) {
        if (product.id.isEmpty) {
          temp.remove(product);
        }
      }
      navigatorKey.currentContext
          ?.read<UserController>()
          .setProductDetails(temp);
    }
    // Use response.productDetails according to your UI/logic needs
    // CustomToast().showToast(
    //     message: "Subscriptions Fetched: ${response.productDetails.length}");
  }

  // Buy a subscription
  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: navigatorKey.currentContext
                ?.read<UserController>()
                .user
                ?.id
                ?.toString() ??
            "");
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    final list = await purchaseStream.last;
    for (var val in list) {
      if (val.status == PurchaseStatus.purchased ||
          val.status == PurchaseStatus.canceled) {
        completePurchase(val);
      }
    }
  }

  // Check if a subscription is active
  Future<bool> isSubscriptionActive(String productId) async {
    // Listen to the purchase stream to get the latest purchase details
    final List<PurchaseDetails> purchaseDetailsList = await purchaseStream.first
        .timeout(const Duration(
            milliseconds: 500)); // Get the first update (latest status)

    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == productId &&
          purchaseDetails.status == PurchaseStatus.purchased) {
        // Subscription for this product is active
        return true;
      }
    }
    // No active subscription found for the given product ID
    return false;
  }

  // Complete a purchase
  void completePurchase(PurchaseDetails purchaseDetails) {
    // if (purchaseDetails.status == PurchaseStatus.purchased) {
    _inAppPurchase.completePurchase(purchaseDetails);
    // }
  }

  void listenToPurchaseUpdates() {
    purchaseStream.listen((purchaseDetailsList) {
      handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  Future<void> restorePurchase() async {
    _inAppPurchase.restorePurchases();
  }

  // Handle purchase updates
  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.canceled) {
        completePurchase(purchaseDetails);
        // TODO: Unlock features or content here
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase Error: ${purchaseDetails.error}');
      }
    }
    navigatorKey.currentContext
        ?.read<UserController>()
        .setPurchaseLoading(false);
  }
}
