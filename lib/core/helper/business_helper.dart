import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:backyard/features/home/widget/model/filter_model.dart';
import 'package:backyard/legacy/Controller/home_controller.dart';
import 'package:backyard/legacy/Service/business_apis.dart';
import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<UserProfileModel>> filterAndSortBusinesses(List<UserProfileModel> businesses, FilterModel filter) async {
  final homeController = getIt<HomeController>();
  if (homeController.categories == null || homeController.categories!.isEmpty) {
    await BusinessAPIS.getCategories();
  }

  final geolocatorRepo = getIt<GeolocatorRepository>();
  final filterLatLng = LatLng(filter.latitude, filter.longitude);

  final categories = homeController.categories;
  final businessList =
      businesses.where((el) {
        final hasCategoryId = filter.category == null || el.categoryId == filter.category!.id;

        final query = filter.query?.toLowerCase().trim();
        if (query == null) return hasCategoryId;

        final businessName = el.name?.toLowerCase().trim() ?? '';
        final businessDescription = el.description?.toLowerCase().trim() ?? '';
        final categoryName = categories?.firstWhereOrNull((cat) => cat.id == el.categoryId)?.categoryName;

        final matchBusinessName = businessName.contains(query);
        final matchBusinessDescription = businessDescription.contains(query);
        final matchCategoryName = categoryName?.contains(query) ?? false;

        final matchQuery = matchBusinessName || matchBusinessDescription || matchCategoryName;

        return hasCategoryId && matchQuery;
      }).toList();

  businessList.sort((a, b) {
    final businessALatLng = LatLng(a.latitude ?? 0, a.longitude ?? 0);
    final businessBLatLng = LatLng(b.latitude ?? 0, b.longitude ?? 0);

    final distanceA = geolocatorRepo.distanceBetween(filterLatLng, businessALatLng);
    final distanceB = geolocatorRepo.distanceBetween(filterLatLng, businessBLatLng);

    return distanceA.compareTo(distanceB);
  });

  return businessList;
}
