import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_details_model.g.dart';

@CopyWith()
@JsonSerializable()
class PlaceDetailsModel extends Equatable {
  final String? placeId;
  final String? formattedAddress;
  final GeometryModel? geometry;
  final List<AddressComponentModel>? addressComponents;

  const PlaceDetailsModel({this.placeId, this.formattedAddress, this.geometry, this.addressComponents});

  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json) => _$PlaceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDetailsModelToJson(this);

  String? get postalCode {
    return addressComponents
        ?.firstWhere(
          (component) => component.types?.contains('postal_code') ?? false,
          orElse: () => const AddressComponentModel(),
        )
        .longName;
  }

  @override
  List<Object?> get props => [placeId, formattedAddress, geometry, addressComponents];
}

@CopyWith()
@JsonSerializable()
class GeometryModel extends Equatable {
  final LocationModel? location;

  const GeometryModel({this.location});

  factory GeometryModel.fromJson(Map<String, dynamic> json) => _$GeometryModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryModelToJson(this);

  @override
  List<Object?> get props => [location];
}

@CopyWith()
@JsonSerializable()
class LocationModel extends Equatable {
  final double? lat;
  final double? lng;

  const LocationModel({this.lat, this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  List<Object?> get props => [lat, lng];
}

@CopyWith()
@JsonSerializable()
class AddressComponentModel extends Equatable {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  const AddressComponentModel({this.longName, this.shortName, this.types});

  factory AddressComponentModel.fromJson(Map<String, dynamic> json) => _$AddressComponentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentModelToJson(this);

  @override
  List<Object?> get props => [longName, shortName, types];
}
