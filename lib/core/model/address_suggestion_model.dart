import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_suggestion_model.g.dart';

@CopyWith()
@JsonSerializable()
class AddressSuggestionModel extends Equatable {
  final String? placeId;
  final String? description;
  final StructuredFormattingModel? structuredFormatting;
  final List<String>? types;

  const AddressSuggestionModel({this.placeId, this.description, this.structuredFormatting, this.types});

  factory AddressSuggestionModel.fromJson(Map<String, dynamic> json) => _$AddressSuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressSuggestionModelToJson(this);

  @override
  List<Object?> get props => [placeId, description, structuredFormatting, types];
}

@CopyWith()
@JsonSerializable()
class StructuredFormattingModel extends Equatable {
  final String? mainText;
  final String? secondaryText;

  const StructuredFormattingModel({this.mainText, this.secondaryText});

  factory StructuredFormattingModel.fromJson(Map<String, dynamic> json) => _$StructuredFormattingModelFromJson(json);

  Map<String, dynamic> toJson() => _$StructuredFormattingModelToJson(this);

  @override
  List<Object?> get props => [mainText, secondaryText];
}
