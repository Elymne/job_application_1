import 'package:freezed_annotation/freezed_annotation.dart';

part 'options_model.freezed.dart';
part 'options_model.g.dart';

/// Stocké en interne sur l'app.
@freezed
abstract class OptionsModel with _$OptionsModel {
  const factory OptionsModel({required String isNotifActivated}) = _OptionsModel;

  factory OptionsModel.fromJson(Map<String, dynamic> json) => _$OptionsModelFromJson(json);
}
