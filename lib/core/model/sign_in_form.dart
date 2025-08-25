import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_form.g.dart';

@CopyWith()
@JsonSerializable()
class SignInForm extends Equatable {
  final String? email;
  final String? password;

  const SignInForm({this.email, this.password});

  Map<String, dynamic> toJson() => _$SignInFormToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<Object?> get props => [email, password];
}
