import 'dart:developer';

import 'package:backyard/legacy/Service/api.dart';
import 'package:backyard/legacy/Service/app_network.dart';
import 'package:backyard/Utils/enum.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/places_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/main.dart';
import 'package:provider/provider.dart';

class GeneralAPIS {
  static Future<String?> getContent(String type) async {
    try {
      final res = await AppNetwork.networkRequest(
        requestTypes.POST.name,
        API.CONTENT_ENDPOINT,
        parameters: {'type': type},
      );
      if (res != null) {
        final model = responseModelFromJson(res.body);
        if (model.status == 1) {
          return model.data.toString();
        }
      }
    } catch (e) {
      log('CONTENT ENDPOINT: ${e.toString()}');
    }
    return null;
  }

  static Future<void> getCategories() async {
    try {
      final controller = navigatorKey.currentContext?.read<HomeController>();
      final res = await AppNetwork.networkRequest(requestTypes.GET.name, API.CATEGORIES_ENDPOINT);
      if (res != null) {
        final model = responseModelFromJson(res.body);
        // CustomToast().showToast(message: model.message ?? "");
        if (model.status == 1) {
          controller?.setCategories(List<CategoryModel>.from((model.data ?? {}).map((x) => CategoryModel.fromJson(x))));
        }
      }
    } catch (e) {
      log('CATEGORY ENDPOINT: ${e.toString()}');
    }
  }

  static Future<void> getPlaces() async {
    try {
      final controller = navigatorKey.currentContext?.read<HomeController>();
      final res = await AppNetwork.networkRequest(requestTypes.GET.name, API.PLACES_ENDPOINT);
      if (res != null) {
        final model = responseModelFromJson(res.body);
        // CustomToast().showToast(message: model.message ?? "");
        if (model.status == 1) {
          controller?.setPlaces(List<PlacesModel>.from((model.data ?? {}).map((x) => PlacesModel.fromJson(x))));
        }
      }
    } catch (e) {
      log('PLACES ENDPOINT: ${e.toString()}');
    }
  }
}
