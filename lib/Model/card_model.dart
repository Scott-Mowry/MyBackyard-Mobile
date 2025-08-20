
class CardModel {
  String id='';
  String? object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String? brand;
  String? country;
  String? customer;
  String? cvcCheck;
  dynamic dynamicLast4;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  String? last4;
  dynamic name;
  dynamic tokenizationMethod;
  dynamic wallet;

  CardModel({
    this.id='',
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.customer,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    this.name,
    this.tokenizationMethod,
    this.wallet,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    object = json['object'] as String?;
    addressCity = json['address_city'];
    addressCountry = json['address_country'];
    addressLine1 = json['address_line1'];
    addressLine1Check = json['address_line1_check'];
    addressLine2 = json['address_line2'];
    addressState = json['address_state'];
    addressZip = json['address_zip'];
    addressZipCheck = json['address_zip_check'];
    brand = json['brand'] as String?;
    country = json['country'] as String?;
    customer = json['customer'] as String?;
    cvcCheck = json['cvc_check'] as String?;
    dynamicLast4 = json['dynamic_last4'];
    expMonth = json['exp_month'] as int?;
    expYear = json['exp_year'] as int?;
    fingerprint = json['fingerprint'] as String?;
    funding = json['funding'] as String?;
    last4 = json['last4'] as String?;
    name = json['name'];
    tokenizationMethod = json['tokenization_method'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['object'] = object;
    json['address_city'] = addressCity;
    json['address_country'] = addressCountry;
    json['address_line1'] = addressLine1;
    json['address_line1_check'] = addressLine1Check;
    json['address_line2'] = addressLine2;
    json['address_state'] = addressState;
    json['address_zip'] = addressZip;
    json['address_zip_check'] = addressZipCheck;
    json['brand'] = brand;
    json['country'] = country;
    json['customer'] = customer;
    json['cvc_check'] = cvcCheck;
    json['dynamic_last4'] = dynamicLast4;
    json['exp_month'] = expMonth;
    json['exp_year'] = expYear;
    json['fingerprint'] = fingerprint;
    json['funding'] = funding;
    json['last4'] = last4;
    json['name'] = name;
    json['tokenization_method'] = tokenizationMethod;
    json['wallet'] = wallet;
    return json;
  }
}

// class CardModel {
//   String id='';
//   String userId='';
//   int cardNumber=0;
//   String stripeToken='';
//   int isActive=0;
//   int isBlocked=0;
//   String createdAt='';
//   String updatedAt='';
//   int v=0;
//
//   CardModel({
//     this.id='',
//     this.userId='',
//     this.cardNumber=0,
//     this.stripeToken='',
//     this.isActive=0,
//     this.isBlocked=0,
//     this.createdAt='',
//     this.updatedAt='',
//     this.v=0,
//   });
//
//   CardModel.fromJson(Map<String, dynamic> json) {
//     id = json['_id']??'';
//     userId = json['userId']??'';
//     cardNumber = json['card_number']??0;
//     stripeToken = json['stripe_token']??'';
//     isActive = json['is_active']??0;
//     isBlocked = json['is_blocked']??0;
//     createdAt = json['createdAt']??'';
//     updatedAt = json['updatedAt']??'';
//     v = json['__v']??0;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['_id'] = id;
//     json['userId'] = userId;
//     json['card_number'] = cardNumber;
//     json['stripe_token'] = stripeToken;
//     json['is_active'] = isActive;
//     json['is_blocked'] = isBlocked;
//     json['createdAt'] = createdAt;
//     json['updatedAt'] = updatedAt;
//     json['__v'] = v;
//     return json;
//   }
// }
