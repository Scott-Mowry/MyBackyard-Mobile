import 'package:auto_route/auto_route.dart';
import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:flutter/cupertino.dart';

@visibleForTesting
const tabsRouterInstanceName = 'tabsRouter';

void registerGlobalTabsRouter(TabsRouter tabsRouter) {
  if (getIt.isRegistered<TabsRouter>(instanceName: tabsRouterInstanceName)) return;
  getIt.registerSingleton<TabsRouter>(tabsRouter, instanceName: tabsRouterInstanceName);
}

TabsRouter get globalTabsRouter => getIt<TabsRouter>(instanceName: tabsRouterInstanceName);
