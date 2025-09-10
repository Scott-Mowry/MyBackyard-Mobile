import 'dart:async';

import 'package:backyard/core/exception/app_exception_codes.dart';
import 'package:backyard/core/exception/app_internal_error.dart';
import 'package:backyard/core/services/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'geolocator_repository.g.dart';

// Wrapper around Geolocator static methods so we can unit test them
@singleton
class GeolocatorRepository = _GeolocatorRepository with _$GeolocatorRepository;

abstract class _GeolocatorRepository with Store {
  final GeolocatorService _geolocatorService;

  _GeolocatorRepository(this._geolocatorService);

  final locationSettings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 20);

  @observable
  LatLng? deviceLatLng;

  @visibleForTesting
  StreamSubscription<Position>? positionStreamSubscription;

  @action
  Future<Position> loadCurrentPosition() async {
    try {
      final lastKnownPosition = await _geolocatorService.getLasKnownPosition();
      final position = lastKnownPosition ?? await _geolocatorService.getCurrentPosition();
      deviceLatLng = LatLng(position.latitude, position.longitude);

      return position;
    } catch (error, stack) {
      throw AppInternalError(code: kLoadCurrentPositionErrorKey, error: error, stack: stack);
    }
  }

  Future<void> startPositionStream() async {
    if (positionStreamSubscription != null) return;

    final positionStream = _geolocatorService.getPositionStream(locationSettings: locationSettings);
    positionStreamSubscription = positionStream.listen(positionStreamListener);

    await loadCurrentPosition();
  }

  Future<void> cancelPositionStream() async {
    positionStreamSubscription?.pause();
    await positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  @visibleForTesting
  @action
  void positionStreamListener(Position? position) {
    if (position == null) return;
    deviceLatLng = LatLng(position.latitude, position.longitude);
  }

  double distanceBetween(LatLng startLatLng, LatLng endLatLng) {
    return _geolocatorService.distanceBetween(
      startLatLng.latitude,
      startLatLng.longitude,
      endLatLng.latitude,
      endLatLng.longitude,
    );
  }
}
