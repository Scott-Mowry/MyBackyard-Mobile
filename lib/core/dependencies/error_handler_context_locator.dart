import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:flutter/material.dart';

const errorHandlerContextInstanceName = 'errorHandlerContext';

void registerGlobalErrorHandlerContext(BuildContext context) {
  getIt.registerSingleton<BuildContext>(context, instanceName: errorHandlerContextInstanceName);
}

BuildContext getGlobalErrorHandlerContext() {
  return getIt<BuildContext>(instanceName: errorHandlerContextInstanceName);
}
