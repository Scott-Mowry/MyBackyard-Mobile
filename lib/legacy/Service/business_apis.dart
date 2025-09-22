// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer';
import 'dart:io';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/core/helper/business_helper.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/features/home/widget/model/filter_model.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/offer_model.dart';
import 'package:backyard/legacy/Model/reiview_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class BusinessAPIS {
  static Future<void> getCategories() async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final res = await getIt<AppNetwork>().networkRequest(RequestTypeEnum.GET.name, API.CATEGORIES_ENDPOINT);
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          controller.setCategories(List<CategoryModel>.from((model.data ?? {}).map((x) => CategoryModel.fromJson(x))));
        }
      }
    } catch (e) {
      log('CATEGORY ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getBusinesses(FilterModel filter) async {
    try {
      await EasyLoading.show();
      final userController = getIt<UserController>();
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_BUSINESSES_ENDPOINT}?lat=${filter.latitude}&long=${filter.longitude}&radius=${filter.radiusInMiles}',
      );

      if (res == null) return;
      final model = responseModelFromJson(res.body);

      if (!model.status) return CustomToast().showToast(message: model.message ?? '');

      final businessesRaw = model.data?['businesses'] ?? [];
      final allBusinesses =
          businessesRaw is List
              ? businessesRaw.map((el) => UserProfileModel.fromJson(el)).toList()
              : <UserProfileModel>[];

      final filteredBusinesses = await filterAndSortBusinesses(allBusinesses, filter);
      userController.clearMarkers();
      userController.setBusinessesList(filteredBusinesses);

      await Future.wait(filteredBusinesses.map(userController.addMarker));
      await userController.zoomOutFitBusinesses();
    } catch (e) {
      log('GET BUSES ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<bool> availOffer({String? offerId}) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final attachments = <MultipartFile>[];
      final parameters = <String, String>{};
      parameters.addAll({'offer_id': offerId ?? ''});
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.AVAIL_OFFER_ENDPOINT,

        parameters: parameters,
        attachments: attachments,
      );

      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          controller.availOffer(offerId ?? '');
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } finally {
      await EasyLoading.dismiss();
    }

    return false;
  }

  static Future<bool> submiteReview({String? busId, String? rate, String? feedback}) async {
    try {
      await EasyLoading.show();
      final controller = getIt<UserController>();
      final parameters = <String, String>{};
      parameters.addAll({'bus_id': busId ?? '', 'rate': rate ?? '', 'feedback': feedback ?? ''});
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.POST_REVIEW_ENDPOINT,

        parameters: parameters,
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          controller.addReview(Review.fromJson(model.data?['review']));
          CustomToast().showToast(message: 'Thank you for your review!');
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('AVAIL OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
    return false;
  }

  static Future<bool> claimOffer({String? offerId, String? userId}) async {
    try {
      await EasyLoading.show();
      final attachments = <MultipartFile>[];
      final parameters = <String, String>{};
      parameters.addAll({'offer_id': offerId ?? '', 'user_id': userId ?? ''});
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.CLAIM_OFFER_ENDPOINT,
        parameters: parameters,
        attachments: attachments,
      );

      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } finally {
      await EasyLoading.dismiss();
    }

    return false;
  }

  static Future<bool> addOffer({
    String? title,
    String? categoryId,
    String? actualPrice,
    String? discountPrice,
    String? rewardPoints,
    String? shortDetail,
    String? desc,
    File? image,
  }) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final attachments = <MultipartFile>[];
      final parameters = <String, String>{
        'title': title ?? '',
        'category_id': categoryId ?? '',
        'actual_price': actualPrice ?? '',
        'discount_price': discountPrice ?? '',
        'reward_points': rewardPoints ?? '',
        'short_detail': shortDetail ?? '',
        'desc': desc ?? '',
      };
      attachments.add(await http.MultipartFile.fromPath('image', image?.path ?? ''));
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.ADD_OFFER_ENDPOINT,

        parameters: parameters,
        attachments: attachments,
      );

      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          final offer = Offer.fromJson(model.data?['offer']);
          controller.addOffers(offer);
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('ADD OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }

    return false;
  }

  static Future<bool> editOffer({
    String? title,
    String? offerId,
    String? categoryId,
    String? actualPrice,
    String? discountPrice,
    String? rewardPoints,
    String? shortDetail,
    String? desc,
    File? image,
  }) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final attachments = <MultipartFile>[];
      final parameters = <String, String>{};
      parameters.addAll({'offer_id': offerId ?? ''});
      if (title != null) {
        parameters.addAll({'title': title});
      }
      if (categoryId != null) {
        parameters.addAll({'category_id': categoryId});
      }
      if (actualPrice != null) {
        parameters.addAll({'actual_price': actualPrice});
      }
      if (discountPrice != null) {
        parameters.addAll({'discount_price': discountPrice});
      }
      if (rewardPoints != null) {
        parameters.addAll({'reward_points': rewardPoints});
      }
      if (shortDetail != null) {
        parameters.addAll({'short_detail': shortDetail});
      }
      if (desc != null) {
        parameters.addAll({'desc': desc});
      }
      if ((image?.path ?? '').isNotEmpty) {
        attachments.add(await http.MultipartFile.fromPath('image', image?.path ?? ''));
      }

      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.EDIT_OFFER_ENDPOINT,

        parameters: parameters,
        attachments: attachments,
      );

      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          final offer = Offer.fromJson(model.data?['offer']);
          controller.editOffers(offer);
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('EDIT OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }

    return false;
  }

  static Future<bool> deleteOffer({String? offerId}) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final attachments = <MultipartFile>[];
      final parameters = <String, String>{};
      parameters.addAll({'offer_id': offerId ?? ''});

      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.DELETE_OFFER_ENDPOINT,

        parameters: parameters,
        attachments: attachments,
      );

      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.deleteOffers(offerId ?? '');
          return true;
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('DELETE OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }

    return false;
  }

  static Future<void> getOffersByBusinessId(String businessId) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setOffers([]);
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_OFFERS_ENDPOINT}?bus_id=$businessId&page=500',
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.setOffers(List<Offer>.from((model.data?['offers'] ?? {}).map((x) => Offer.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getTrendingOffers(String categoryId) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setOffers([]);
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_OFFERS_ENDPOINT}?type=trending&category_id=$categoryId',
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.setOffers(List<Offer>.from((model.data?['offers'] ?? {}).map((x) => Offer.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<List<Offer>> getSavedOrOwnedOffers({bool? isSwitch}) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setOffers([]);

      var endpoint = API.GET_OFFERS_ENDPOINT;
      if (isSwitch ?? false) endpoint += '?switch=User';

      final res = await getIt<AppNetwork>().networkRequest(RequestTypeEnum.GET.name, endpoint);
      if (res == null) return [];

      final model = responseModelFromJson(res.body);
      if (!model.status) {
        CustomToast().showToast(message: model.message ?? '');
        return [];
      }

      final savedOffers = List<Offer>.from((model.data?['offers'] ?? {}).map((x) => Offer.fromJson(x)));
      return savedOffers;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getFavOffer() async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setOffers([]);
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_OFFERS_ENDPOINT}?type=fav',
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.setOffers(List<Offer>.from((model.data?['offers'] ?? {}).map((x) => Offer.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getCustomerOffers(String userId) async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setCustomerOffers([]);
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_OFFERS_ENDPOINT}?switch_user_id=$userId',
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          controller.setCustomerOffers(List<Offer>.from((model.data?['offers'] ?? {}).map((x) => Offer.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET CUSTOMER OFFERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getCustomers() async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      controller.setCustomersList([]);
      final res = await getIt<AppNetwork>().networkRequest(RequestTypeEnum.GET.name, API.GET_CUSTOMERS_ENDPOINT);
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.setCustomersList(
            List<UserProfileModel>.from((model.data ?? {}).map((x) => UserProfileModel.fromJson(x))),
          );
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET CUSTOMERS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  static Future<void> getReview(String busId) async {
    try {
      await EasyLoading.show();
      final controller = getIt<UserController>();
      controller.setReviews([]);
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.GET.name,
        '${API.GET_REVIEWS_ENDPOINT}?bus_id=$busId',
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);

        if (model.status) {
          controller.setRating(double.parse(model.data?['ratings']?.toString() ?? '0'));
          controller.setReviews(List<Review>.from((model.data?['reviews'] ?? {}).map((x) => Review.fromJson(x))));
        } else {
          CustomToast().showToast(message: model.message ?? '');
        }
      }
    } catch (e) {
      log('GET REVIEWS ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
