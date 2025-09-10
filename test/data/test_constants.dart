// Geolocator
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const deviceLatLng = LatLng(35.739592, -78.778945);
final mockPosition = Position(
  latitude: 35.739592,
  longitude: -78.778945,
  timestamp: DateTime.fromMillisecondsSinceEpoch(500, isUtc: true),
  altitude: 3000.0,
  accuracy: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
  altitudeAccuracy: 10.0,
  headingAccuracy: 10.0,
);
