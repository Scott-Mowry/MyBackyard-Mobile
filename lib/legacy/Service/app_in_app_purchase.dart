import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/repositories/crash_report_repository.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  }

  Future<void> fetchSubscriptions(List<String> ids) async {
    final response = await _inAppPurchase.queryProductDetails(ids.toSet());
    if (response.error != null) {
      final crashlyticsRepository = getIt<CrashReportRepository>();
      await crashlyticsRepository.recordError(response.error, null);
      if (kDebugMode) debugPrint('Failed to fetch subscriptions: ${response.error}');

      return;
    }

    if (response.productDetails.isEmpty) return;

    final temp = response.productDetails;
    for (var product in response.productDetails) {
      if (product.id.isEmpty) temp.remove(product);
    }

    getIt<UserController>().setProductDetails(temp);
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    try {
      await EasyLoading.show();
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
    } catch (error, stackTrace) {
      throw AppInternalError(code: kBuySubscriptionErrorKey, error: error, stack: stackTrace);
    } finally {
      await EasyLoading.dismiss();
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
  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.canceled) {
        completePurchase(purchaseDetails);
        // TODO: Unlock features or content here
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        final crashlyticsRepository = getIt<CrashReportRepository>();
        await crashlyticsRepository.recordError(purchaseDetails.error, null);
        if (kDebugMode) debugPrint('Purchase Error: ${purchaseDetails.error}');
      }
    }
  }
}
