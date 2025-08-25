import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:flutter/cupertino.dart';

@visibleForTesting
const stackRouterInstanceName = 'stackRouter';

void registerGlobalStackRouter(StackRouter appRouter) {
  if (getIt.isRegistered<StackRouter>(instanceName: stackRouterInstanceName)) return;
  getIt.registerSingleton<StackRouter>(appRouter, instanceName: stackRouterInstanceName);
}

StackRouter get globalStackRouter => getIt<StackRouter>(instanceName: stackRouterInstanceName);
