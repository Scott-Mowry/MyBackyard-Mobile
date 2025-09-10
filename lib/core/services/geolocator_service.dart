import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

// When a package only provides a singleton or only static methods for us to work on
// we have to wrap it in a service so whe can perform some mockings during unit tests
abstract class GeolocatorService {
  Stream<Position> getPositionStream({LocationSettings? locationSettings});
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  });

  Future<Position?> getLasKnownPosition({bool forceAndroidLocationManager = false});
  double distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude);
}

@Injectable(as: GeolocatorService)
class GeolocatorServiceImpl implements GeolocatorService {
  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit = const Duration(seconds: 5),
  }) {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: desiredAccuracy,
      forceAndroidLocationManager: forceAndroidLocationManager,
      timeLimit: timeLimit,
    );
  }

  @override
  Future<Position?> getLasKnownPosition({bool forceAndroidLocationManager = false}) {
    return Geolocator.getLastKnownPosition(forceAndroidLocationManager: forceAndroidLocationManager);
  }

  @override
  double distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
