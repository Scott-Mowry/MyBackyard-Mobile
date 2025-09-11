import 'package:backyard/core/constants/app_constants.dart';
import 'package:backyard/legacy/Model/category_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_model.g.dart';

@CopyWith()
@JsonSerializable()
class FilterModel extends Equatable {
  final int radiusInMiles;
  final double latitude;
  final double longitude;
  final CategoryModel? category;
  final String? query;

  const FilterModel({
    this.radiusInMiles = kDefaultMapRadiusInMiles,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.category,
    this.query,
  });

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [radiusInMiles, latitude, longitude, category, query];
}
