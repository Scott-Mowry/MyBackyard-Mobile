import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/model/address_suggestion_model.dart';
import 'package:backyard/core/model/place_details_model.dart';
import 'package:backyard/core/services/google_maps_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'google_maps_repository.g.dart';

@singleton
class GoogleMapsRepository = _GoogleMapsRepository with _$GoogleMapsRepository;

abstract class _GoogleMapsRepository with Store {
  final GoogleMapsService _googleMapsService;

  _GoogleMapsRepository(this._googleMapsService);

  @action
  Future<List<AddressSuggestionModel>> getAddressesByQuery(String query) async {
    try {
      await EasyLoading.show();
      final addresses = await _googleMapsService.getAddressesByQuery(query);

      return addresses;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kGetAddressesByQueryErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @action
  Future<PlaceDetailsModel?> getPlaceDetails(String placeId) async {
    try {
      await EasyLoading.show();
      final placeDetails = await _googleMapsService.getPlaceDetails(placeId);

      return placeDetails;
    } catch (error, stacktrace) {
      throw AppInternalError(code: kGetPlaceDetailsErrorKey, error: error, stack: stacktrace);
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
