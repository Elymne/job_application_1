import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String email,
    required String firstname,
    required String surname,
    required String profileImagePath,

    // Devrais-être stocké sur le tel, et pas sur la db en remote mais tant pis.
    required String isNotifActivated,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}
