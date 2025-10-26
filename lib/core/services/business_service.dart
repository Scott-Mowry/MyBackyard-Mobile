import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/helper/business_helper.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/features/home/widget/model/filter_model.dart';
import 'package:backyard/legacy/Component/custom_toast.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Controller/user_controller.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';

abstract class BusinessService {
  Future<void> getCategories();
  Future<void> getBusinesses(FilterModel filter);
}

@Injectable(as: BusinessService)
class BusinessServiceImpl implements BusinessService {
  final ApiClient _apiClient;

  const BusinessServiceImpl(@Named(kMyBackyardApiClient) this._apiClient);

  Future<void> getCategories() async {
    try {
      await EasyLoading.show();
      final res = await _apiClient.get(API.CATEGORIES_ENDPOINT);
      final respModel = ResponseModel.fromJson(res.data);
      final categoriesRaw = respModel.data is List ? respModel.data as List : [];
      final categories = categoriesRaw.map((el) => CategoryModel.fromJson(el as Map<String, dynamic>)).toList();

      final homeController = getIt<HomeController>();
      homeController.setCategories(categories);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> getBusinesses(FilterModel filter) async {
    try {
      await EasyLoading.show();

      final apiClient = getIt<ApiClient>(instanceName: kMyBackyardApiClient);
      final queryParams = {'lat': filter.latitude, 'long': filter.longitude, 'radius': filter.radiusInMiles};

      final res = await apiClient.get(API.GET_BUSINESSES_ENDPOINT, queryParameters: queryParams);
      final respModel = ResponseModel.fromJson(res.data);

      if (!respModel.status) return CustomToast().showToast(message: respModel.message ?? '');

      final businessesRaw = respModel.data?['businesses'] ?? [];
      final allBusinesses =
          businessesRaw is List
              ? businessesRaw.map((el) => UserProfileModel.fromJson(el)).toList()
              : <UserProfileModel>[];

      final filteredBusinesses = await filterAndSortBusinesses(allBusinesses, filter);
      final userController = getIt<UserController>();
      userController.clearMarkers();
      userController.setBusinessesList(filteredBusinesses);

      await Future.wait(filteredBusinesses.map(userController.addMarker));
      await userController.zoomOutFitBusinesses();
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
