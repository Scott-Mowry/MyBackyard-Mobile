import 'package:backyard/core/repositories/geolocator_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import '../../data/mocks/mocks_generator.mocks.dart';
import '../../data/test_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OpenStreetMapRepository', () {
    final mockGeolocatorService = MockGeolocatorService();

    tearDown(() {
      reset(mockGeolocatorService);
    });

    test('startPositionStream does nothing if already streaming', () async {
      final repository = GeolocatorRepository(mockGeolocatorService);
      repository.positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: repository.locationSettings,
      ).listen((_) {});

      await repository.startPositionStream();

      expect(repository.positionStreamSubscription, isNotNull);
      expect(repository.deviceLatLng, null);
      verifyZeroInteractions(mockGeolocatorService);
    });

    test('startPositionStream start streaming and set first position', () async {
      final repository = GeolocatorRepository(mockGeolocatorService);
      final expectedDeviceLatLng = LatLng(mockPosition.latitude, mockPosition.longitude);

      Future<Position?> getLastKnownPosition() => mockGeolocatorService.getLasKnownPosition();
      Future<Position> getCurrentPosition() => mockGeolocatorService.getCurrentPosition();
      Stream<Position> getPositionStream() {
        return mockGeolocatorService.getPositionStream(locationSettings: repository.locationSettings);
      }

      when(getLastKnownPosition()).thenAnswer((_) async => null);
      when(getCurrentPosition()).thenAnswer((_) async => mockPosition);
      when(getPositionStream()).thenAnswer((_) async* {});

      await repository.startPositionStream();

      expect(repository.positionStreamSubscription, isNotNull);
      expect(repository.deviceLatLng, expectedDeviceLatLng);
      verify(getPositionStream());
      verify(getLastKnownPosition());
      verify(getCurrentPosition());
      verifyNoMoreInteractions(mockGeolocatorService);
    });

    test('cancelPositionStream cancels stream', () async {
      final repository = GeolocatorRepository(mockGeolocatorService);
      repository.positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: repository.locationSettings,
      ).listen((_) {});

      await repository.cancelPositionStream();

      expect(repository.positionStreamSubscription, null);
      verifyZeroInteractions(mockGeolocatorService);
    });

    test('positionStreamListener does nothing when null position', () async {
      const latLng = LatLng(0.0, 0.0);
      final repository = GeolocatorRepository(mockGeolocatorService);
      repository.deviceLatLng = latLng;
      repository.positionStreamListener(null);

      expect(repository.deviceLatLng, latLng);
      verifyZeroInteractions(mockGeolocatorService);
    });

    test('positionStreamListener changes currentDeviceLatLng when position no null', () async {
      final repository = GeolocatorRepository(mockGeolocatorService);
      repository.deviceLatLng = const LatLng(2.0, 2.0);
      repository.positionStreamListener(mockPosition);

      expect(repository.deviceLatLng, deviceLatLng);
      verifyZeroInteractions(mockGeolocatorService);
    });

    test('distanceBetween should return the correct distance', () {
      final repository = GeolocatorRepository(mockGeolocatorService);
      const startLatLng = LatLng(37.7749, -122.4194);
      const endLatLng = LatLng(34.0522, -118.2437);
      const distance = 559.2;

      when(
        mockGeolocatorService.distanceBetween(
          startLatLng.latitude,
          startLatLng.longitude,
          endLatLng.latitude,
          endLatLng.longitude,
        ),
      ).thenReturn(distance);

      final result = repository.distanceBetween(startLatLng, endLatLng);

      expect(result, distance);
      verify(
        mockGeolocatorService.distanceBetween(
          startLatLng.latitude,
          startLatLng.longitude,
          endLatLng.latitude,
          endLatLng.longitude,
        ),
      );
    });
  });
}
