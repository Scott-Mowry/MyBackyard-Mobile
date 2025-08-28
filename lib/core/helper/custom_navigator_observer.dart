import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/repositories/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomNavigatorObserver extends AutoRouterObserver {
  final AnalyticsRepository _analyticsRepository;

  CustomNavigatorObserver(this._analyticsRepository);

  @override
  void didPush(Route route, Route? previousRoute) {
    _analyticsRepository.logScreenViewEvent(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _analyticsRepository.logScreenViewEvent(previousRoute!.settings.name);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _analyticsRepository.logScreenViewEvent(previousRoute?.settings.name);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _analyticsRepository.logScreenViewEvent(newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _analyticsRepository.logScreenViewEvent(route.settings.name);
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _analyticsRepository.logScreenViewEvent(route.name);
    super.didInitTabRoute(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _analyticsRepository.logScreenViewEvent(route.name);
    super.didChangeTabRoute(route, previousRoute);
  }
}
