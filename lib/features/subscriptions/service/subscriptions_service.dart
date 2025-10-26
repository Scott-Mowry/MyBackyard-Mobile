import 'package:backyard/core/api_client/api_client.dart';
import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/features/subscriptions/model/subscription_plan_model.dart';
import 'package:backyard/legacy/Model/response_model.dart';
import 'package:backyard/legacy/Service/api.dart';
import 'package:injectable/injectable.dart';

// ignore: one_member_abstracts
abstract class SubscriptionsService {
  Future<List<SubscriptionPlanModel>> getSubscriptions();
}

@Injectable(as: SubscriptionsService)
class SubscriptionsServiceImpl implements SubscriptionsService {
  final ApiClient _apiClient;

  const SubscriptionsServiceImpl(@Named(kMyBackyardApiClient) this._apiClient);

  Future<List<SubscriptionPlanModel>> getSubscriptions() async {
    final res = await _apiClient.get(API.GET_SUBSCRIPTIONS);
    final respModel = ResponseModel.fromJson(res.data);

    final subscriptionsRaw = respModel.data as List;
    final subscriptions =
        subscriptionsRaw.map((el) => SubscriptionPlanModel.fromJson(el as Map<String, dynamic>)).toList();

    return subscriptions;
  }
}
