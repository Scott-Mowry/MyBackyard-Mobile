import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:flutter/material.dart';

const errorHandlerContextInstanceName = 'errorHandlerContext';

void registerGlobalErrorHandlerContext(BuildContext context) {
  final isRegistered = getIt.isRegistered<BuildContext>(instanceName: errorHandlerContextInstanceName);
  if (isRegistered) getIt.unregister<BuildContext>(instanceName: errorHandlerContextInstanceName);
  getIt.registerSingleton<BuildContext>(context, instanceName: errorHandlerContextInstanceName);
}

BuildContext getGlobalErrorHandlerContext() {
  return getIt<BuildContext>(instanceName: errorHandlerContextInstanceName);
}
