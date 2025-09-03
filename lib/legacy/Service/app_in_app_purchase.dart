import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AppInAppPurchase {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  // Initialize a singleton instance
  static final AppInAppPurchase _instance = AppInAppPurchase._internal();
  factory AppInAppPurchase() => _instance;
  AppInAppPurchase._internal();

  // Connect to the store
  Future<void> initialize() async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      // Handle store not available scenario
      debugPrint('The store is not available');
      return;
    }
    // Load or refresh subscriptions here if needed
  }

  // Fetch products
  Future<void> fetchSubscriptions(List<String> ids) async {
    getIt<UserController>().setLoading(true);
    getIt<UserController>().setProductDetails([]);

    final response = await _inAppPurchase.queryProductDetails(ids.toSet());
    getIt<UserController>().setLoading(false);
    if (response.error != null) {
      // Handle errors here
      CustomToast().showToast(message: 'Failed to fetch subscriptions: ${response.error!.message}');
      debugPrint('Failed to fetch subscriptions: ${response.error!.message}');
      return;
    }

    if (response.productDetails.isEmpty) {
      CustomToast().showToast(message: 'No products found.');
    } else {
      final temp = response.productDetails;
      // Now you can safely access product details
      for (var product in response.productDetails) {
        if (product.id.isEmpty) {
          temp.remove(product);
        }
      }
      getIt<UserController>().setProductDetails(temp);
    }
  }

  // Buy a subscription
  Future<void> buySubscription(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: getIt<UserController>().user?.id?.toString() ?? '',
    );
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    final list = await purchaseStream.last;
    for (var val in list) {
      if (val.status == PurchaseStatus.purchased || val.status == PurchaseStatus.canceled) {
        completePurchase(val);
      }
    }
  }

  // Check if a subscription is active
  Future<bool> isSubscriptionActive(String productId) async {
    // Listen to the purchase stream to get the latest purchase details
    final purchaseDetailsList = await purchaseStream.first.timeout(
      const Duration(milliseconds: 500),
    ); // Get the first update (latest status)

    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == productId && purchaseDetails.status == PurchaseStatus.purchased) {
        // Subscription for this product is active
        return true;
      }
    }
    // No active subscription found for the given product ID
    return false;
  }

  // Complete a purchase
  void completePurchase(PurchaseDetails purchaseDetails) => _inAppPurchase.completePurchase(purchaseDetails);

  void listenToPurchaseUpdates() => purchaseStream.listen(handlePurchaseUpdates);

  Future<void> restorePurchase() => _inAppPurchase.restorePurchases();

  // Handle purchase updates
  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.canceled) {
        completePurchase(purchaseDetails);
        // TODO: Unlock features or content here
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase Error: ${purchaseDetails.error}');
      }
    }
    getIt<UserController>().setPurchaseLoading(false);
  }
}
