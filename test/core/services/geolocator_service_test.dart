import 'package:backyard/core/services/geolocator_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

import '../../data/mocks/mock_geolocator_platform.dart';
import '../../data/test_constants.dart';

// Reference: https://github.com/Baseflow/flutter-geolocator/blob/main/geolocator/test/geolocator_test.dart
void main() {
  group('GeolocatorService', () {
    setUpAll(() async {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    tearDown(() {
      reset(GeolocatorPlatform.instance);
    });

    test('getPositionStream streams one position', () async {
      Stream<Position> getPositionStream() => GeolocatorPlatform.instance.getPositionStream();
      when(getPositionStream()).thenAnswer((_) => Stream.value(mockPosition));

      final position = GeolocatorServiceImpl().getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emitsDone]));
      verify(getPositionStream());
    });

    test('getPositionStream streams three positions', () async {
      Stream<Position> getPositionStream() => GeolocatorPlatform.instance.getPositionStream();
      when(getPositionStream()).thenAnswer((_) async* {
        for (var i = 0; i < 3; i++) {
          yield mockPosition;
        }
      });

      final position = GeolocatorServiceImpl().getPositionStream();

      expect(position, emitsInOrder([emits(mockPosition), emits(mockPosition), emits(mockPosition), emitsDone]));
      verify(getPositionStream());
      verifyNoMoreInteractions(GeolocatorPlatform.instance);
    });

    test('getCurrentPosition returns device current position', () async {
      final position = await GeolocatorServiceImpl().getCurrentPosition();
      expect(position, mockPosition);
    });

    test('getLasKnownPosition returns device last knwon position', () async {
      final position = await GeolocatorServiceImpl().getLasKnownPosition();
      expect(position, mockPosition);
    });
  });
}
