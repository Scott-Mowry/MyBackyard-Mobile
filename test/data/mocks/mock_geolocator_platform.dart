import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../test_constants.dart';

// ignore: prefer_mixin
class MockGeolocatorPlatform extends Mock with MockPlatformInterfaceMixin implements GeolocatorPlatform {
  @override
  Future<Position?> getLastKnownPosition({bool forceLocationManager = false}) => Future.value(mockPosition);

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) => Future.value(mockPosition);

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    return super.noSuchMethod(
      Invocation.method(#getPositionStream, null, <Symbol, Object?>{
        #desiredAccuracy: locationSettings?.accuracy ?? LocationAccuracy.best,
        #distanceFilter: locationSettings?.distanceFilter ?? 0,
        #timeLimit: locationSettings?.timeLimit ?? 0,
      }),
      returnValue: Stream.value(mockPosition),
    );
  }
}
