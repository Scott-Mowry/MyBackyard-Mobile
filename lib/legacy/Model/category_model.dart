import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@CopyWith()
@JsonSerializable()
class CategoryModel extends Equatable {
  final int? id;
  final String? categoryName;
  final String? categoryIcon;

  const CategoryModel({this.id, this.categoryName, this.categoryIcon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => [id, categoryName, categoryIcon];
}
