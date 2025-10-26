import 'dart:async';

import 'package:backyard/core/model/user_profile_model.dart';
import 'package:backyard/core/repositories/user_auth_repository.dart';
import 'package:backyard/core/view_model/base_view_model.dart';
import 'package:backyard/features/subscriptions/model/subscription_plan_model.dart';
import 'package:backyard/features/subscriptions/repository/subscriptions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'external_subscriptions_view_model.g.dart';

@injectable
class ExternalSubscriptionsViewModel = _ExternalSubscriptionsViewModel with _$ExternalSubscriptionsViewModel;

abstract class _ExternalSubscriptionsViewModel extends BaseViewModel with Store {
  final SubscriptionsRepository _subscriptionsRepository;
  final UserAuthRepository _userAuthRepository;

  _ExternalSubscriptionsViewModel(this._subscriptionsRepository, this._userAuthRepository);

  @computed
  List<SubscriptionPlanModel> get subscriptionPlans => _subscriptionsRepository.subscriptionPlans;

  @computed
  UserProfileModel? get currentUser => _userAuthRepository.currentUser;

  @override
  Future<void> init() async {
    try {
      loading = true;
      await _subscriptionsRepository.loadActiveSubscriptions();
    } finally {
      loading = false;
    }
  }
}
