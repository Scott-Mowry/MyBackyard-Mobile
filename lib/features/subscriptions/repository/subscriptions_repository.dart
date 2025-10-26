import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/features/subscriptions/model/subscription_plan_model.dart';
import 'package:backyard/features/subscriptions/service/subscriptions_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'subscriptions_repository.g.dart';

@singleton
class SubscriptionsRepository = _SubscriptionsRepository with _$SubscriptionsRepository;

abstract class _SubscriptionsRepository with Store {
  final SubscriptionsService _subscriptionsService;

  _SubscriptionsRepository(this._subscriptionsService);

  final subscriptionPlans = <SubscriptionPlanModel>[].asObservable();

  @action
  Future<void> loadActiveSubscriptions() async {
    try {
      final plansRaw = await _subscriptionsService.getSubscriptions();
      final activePlans = plansRaw.where((el) => el.status == 'Active' && el.isDepreciated == 'No').toList();
      subscriptionPlans.clear();
      subscriptionPlans.addAll(activePlans.reversed);
    } catch (error, stacktrace) {
      throw AppInternalError(code: kLoadSubscriptionsErrorKey, error: error, stack: stacktrace);
    }
  }
}
