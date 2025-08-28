import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:flutter/cupertino.dart';

@visibleForTesting
const stackRouterInstanceName = 'stackRouter';

@visibleForTesting
const tabsRouterInstanceName = 'tabsRouter';

void registerGlobalStackRouter(StackRouter appRouter) {
  if (getIt.isRegistered<StackRouter>(instanceName: stackRouterInstanceName)) return;
  getIt.registerSingleton<StackRouter>(appRouter, instanceName: stackRouterInstanceName);
}

void registerGlobalTabsRouter(TabsRouter tabsRouter) {
  if (getIt.isRegistered<TabsRouter>(instanceName: tabsRouterInstanceName)) return;
  getIt.registerSingleton<TabsRouter>(tabsRouter, instanceName: tabsRouterInstanceName);
}

StackRouter get globalStackRouter => getIt<StackRouter>(instanceName: stackRouterInstanceName);

TabsRouter get globalTabsRouter => getIt<TabsRouter>(instanceName: tabsRouterInstanceName);
