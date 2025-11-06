import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset.freezed.dart';

@freezed
abstract class Reset with _$Reset {
  const factory Reset({
    @Default('') String email,
    @Default(ResetState.none) ResetState state,
    String? error,
  }) = _Reset;
}

enum ResetState { none, success, failure }
