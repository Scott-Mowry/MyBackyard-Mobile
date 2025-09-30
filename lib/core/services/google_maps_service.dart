import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/core/model/address_suggestion_model.dart';
import 'package:backyard/core/model/place_details_model.dart';
import 'package:backyard/legacy/Utils/app_strings.dart';
import 'package:injectable/injectable.dart';

abstract class GoogleMapsService {
  Future<List<AddressSuggestionModel>> getAddressesByQuery(String query);
  Future<PlaceDetailsModel?> getPlaceDetails(String placeId);
}

@Injectable(as: GoogleMapsService)
class GoogleMapsServiceImpl implements GoogleMapsService {
  final ApiClient _apiClient;

  const GoogleMapsServiceImpl(@Named(kGoogleMapsApiClient) this._apiClient);

  @override
  Future<List<AddressSuggestionModel>> getAddressesByQuery(String query) async {
    if (query.length < 3) return [];

    final queryParams = {'input': query, 'key': AppStrings.GOOGLE_API_KEY, 'types': 'address'};
    final resp = await _apiClient.post('/place/autocomplete/json', queryParameters: queryParams);
    final respData = resp.data?['predictions'] as List? ?? [];
    final places = respData.map((el) => AddressSuggestionModel.fromJson(el as Map<String, dynamic>)).toList();

    return places;
  }

  @override
  Future<PlaceDetailsModel?> getPlaceDetails(String placeId) async {
    final queryParams = {
      'place_id': placeId,
      'key': AppStrings.GOOGLE_API_KEY,
      'fields': 'place_id,formatted_address,geometry,address_components',
    };
    final resp = await _apiClient.post('/place/details/json', queryParameters: queryParams);
    final respData = resp.data?['result'] as Map<String, dynamic>?;
    if (respData == null) return null;

    return PlaceDetailsModel.fromJson(respData);
  }
}
