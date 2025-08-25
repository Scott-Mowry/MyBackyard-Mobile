import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'app_internal_error.g.dart';

@CopyWith()
class AppInternalError extends Equatable implements Exception {
  const AppInternalError({required this.code, this.error, this.stack, this.isCritical = false});

  final String code;
  final Object? error;
  final StackTrace? stack;
  final bool isCritical;

  @override
  List<Object?> get props => [code, error, stack, isCritical];
}
