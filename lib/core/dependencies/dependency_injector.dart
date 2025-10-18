import 'dart:async';

import 'package:backyard/core/dependencies/dependency_injector.config.dart';
import 'package:backyard/core/repositories/analytics_repository.dart';
import 'package:backyard/core/repositories/connectivity_repository.dart';
import 'package:backyard/core/repositories/crash_report_repository.dart';
import 'package:backyard/core/repositories/local_storage_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: true)
void injectDependencies() => getIt.init();

Future<void> initDependencies() async {
  await getIt<LocalStorageRepository>().init();
  await getIt<ConnectivityRepository>().init();

  await analyticsRepository.setAnalyticsCollectionEnabled(true);
  await crashReportRepository.setCrashlyticsCollectionEnabled(true);
}

AnalyticsRepository get analyticsRepository {
  return getIt.isRegistered<AnalyticsRepository>()
      ? getIt<AnalyticsRepository>()
      : AnalyticsRepository(FirebaseAnalytics.instance);
}

CrashReportRepository get crashReportRepository {
  return getIt.isRegistered<CrashReportRepository>()
      ? getIt<CrashReportRepository>()
      : CrashReportRepository(FirebaseCrashlytics.instance);
}
