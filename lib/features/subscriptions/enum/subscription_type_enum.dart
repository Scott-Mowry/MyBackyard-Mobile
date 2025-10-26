import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum SubscriptionTypeEnum {
  user_sub(1),
  bus_sub_monthly(2),
  bus_sub_annually(3),
  bus_basic(4);

  const SubscriptionTypeEnum(this.subId);

  final int subId;
}

extension SubscriptionTypeEnumExtension on SubscriptionTypeEnum {
  bool get isUserSub => this == SubscriptionTypeEnum.user_sub;

  bool get isBusinessSubMonthly => this == SubscriptionTypeEnum.bus_sub_monthly;

  bool get isBusinessSubYearly => this == SubscriptionTypeEnum.bus_sub_annually;

  bool get isBusinessSubBasic => this == SubscriptionTypeEnum.bus_basic;

  String getPrice(String price) => switch (this) {
    SubscriptionTypeEnum.user_sub || SubscriptionTypeEnum.bus_sub_annually => '$price Annually',
    SubscriptionTypeEnum.bus_sub_monthly => '$price Monthy',
    SubscriptionTypeEnum.bus_basic => '$price Monthly',
  };

  String get duration => switch (this) {
    SubscriptionTypeEnum.user_sub || SubscriptionTypeEnum.bus_sub_annually => ' /year',
    SubscriptionTypeEnum.bus_sub_monthly || SubscriptionTypeEnum.bus_basic => ' /month',
  };

  List<String> get textTopics {
    switch (this) {
      case SubscriptionTypeEnum.user_sub:
        return [
          'Enjoy exclusive offers through My Backyard and the family owned businesses in your area. #Shoplocal',
          'Unlock hidden gems in your community with 16 different categories.',
          'The User Package is good for 12 months and yearly auto renews thereafter.',
        ];

      case SubscriptionTypeEnum.bus_sub_monthly:
        return [
          'Business Subscribers can enjoy access of the following:',
          'As a local family owned business, reach tens of thousands of households while promoting your product and/or service for better brand awareness and attracting new customers.',
          'Promote exclusive offers to the My Backyard users at any time of a day, week or month, unlimited.',
          'This is a month to month subscription which auto renews every month thereafter the initial month.',
          'Comes with a user/consumer subscription.',
          'Ideal for the company looking to gain new customers through the exclusive creation of offers.',
        ];
      case SubscriptionTypeEnum.bus_sub_annually:
        return [
          'The Annual Subscription for business is ideal for companies in the community that are service providers such as but not limited to: Reality, Family Owned Physicians, Dental Practices, Insurance Companies and more.',
          "Stay ahead of the curve with the annual subscription and it's updates as needed.",
          'The Annual Subscription for businesses will auto renew after the 12th month.'
              'Get featured on My Backyard Website',
          'access to the My Backyard preferred vendors.',
          'Comes with a user/consumer subscription.'
              'Ideal for the company that has or will have multiple locations and or looking for further reach.',
          'Photo of your Business featured in app.',
        ];
      case SubscriptionTypeEnum.bus_basic:
        return [
          'Business Subscribers can enjoy access of the following:',
          'As a local family owned business, reach tens of thousands of households on the map in consumer.',
          'This is a month to month subscription which auto renews every month thereafter the initial month.',
          'Ideal for the company that simply wants your business to be seen.',
        ];
    }
  }
}

SubscriptionTypeEnum? getSubscriptionTypeFromSubId(int? subId) {
  if (subId == null) return null;
  return SubscriptionTypeEnum.values.firstWhereOrNull((el) => el.subId == subId);
}

SubscriptionTypeEnum? getSubscriptionTypeFromProductId(String? productId) {
  if (productId == null || productId.isEmpty) return null;
  return SubscriptionTypeEnum.values.firstWhereOrNull((el) => el.name == productId);
}

// Default subscriptions
final defaultUserSubscriptionPlans = <ProductDetails>[
  ProductDetails(
    id: SubscriptionTypeEnum.user_sub.name,
    title: 'All Access User Subscription',
    description: 'Enjoy exclusive offers and unlock hidden gems in your community',
    price: '\$1.99',
    rawPrice: 1.99,
    currencyCode: 'USD',
  ),
];

final defaultBusinessSubscriptionPlans = <ProductDetails>[
  ProductDetails(
    id: SubscriptionTypeEnum.bus_sub_monthly.name,
    title: 'Business Monthly Subscription',
    description: 'Month-to-month business access with unlimited offers',
    price: '\$100.00',
    rawPrice: 100.00,
    currencyCode: 'USD',
  ),
  ProductDetails(
    id: SubscriptionTypeEnum.bus_sub_annually.name,
    title: 'Business Annual Subscription',
    description: 'Annual business subscription with premium features',
    price: '\$1000.00',
    rawPrice: 1000.00,
    currencyCode: 'USD',
  ),
  ProductDetails(
    id: SubscriptionTypeEnum.bus_basic.name,
    title: 'Business Basic Subscription',
    description: 'Basic business visibility on the map',
    price: '\$70.00',
    rawPrice: 70.00,
    currencyCode: 'USD',
  ),
];
