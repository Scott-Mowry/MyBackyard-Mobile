// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer';

import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/enum/enum.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/places_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GeneralAPIS {
  static Future<String?> getContent(String type) async {
    try {
      await EasyLoading.show();
      final res = await getIt<AppNetwork>().networkRequest(
        RequestTypeEnum.POST.name,
        API.CONTENT_ENDPOINT,
        parameters: {'type': type},
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status) {
          return model.data.toString();
        }
      }
    } catch (e) {
      log('CONTENT ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }

    return null;
  }

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

  static Future<void> getPlaces() async {
    try {
      await EasyLoading.show();
      final controller = getIt<HomeController>();
      final res = await getIt<AppNetwork>().networkRequest(RequestTypeEnum.GET.name, API.PLACES_ENDPOINT);
      if (res != null) {
        final model = responseModelFromJson(res.body);
        // CustomToast().showToast(message: model.message ?? "");
        if (model.status) {
          controller.setPlaces(List<PlacesModel>.from((model.data ?? {}).map((x) => PlacesModel.fromJson(x))));
        }
      }
    } catch (e) {
      log('PLACES ENDPOINT: ${e.toString()}');
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
