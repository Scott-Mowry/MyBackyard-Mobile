import 'package:backyard/core/constants/app_constants.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offers_filter_model.g.dart';

@CopyWith()
@JsonSerializable()
class OffersFilterModel extends Equatable {
  final int radiusInMiles;
  final double latitude;
  final double longitude;
  final String? query;

  const OffersFilterModel({
    this.radiusInMiles = kDefaultMapRadiusInMiles,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.query,
  });

  Map<String, dynamic> toJson() => _$OffersFilterModelToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [radiusInMiles, query];
}
