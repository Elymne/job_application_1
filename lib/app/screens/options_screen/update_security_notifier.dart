import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

part 'update_security_notifier.freezed.dart';

@freezed
abstract class UpdateSecurityState with _$UpdateSecurityState {
  const factory UpdateSecurityState({
    @Default("") String password,
    @Default("") String newPassword,
    @Default("") String newPasswordConfirm,

    @Default(0) int success,
    @Default([]) List<String> errorStack,
  }) = _UpdateSecurityState;
}

class UpdateProfileNotifier extends AsyncNotifier<UpdateSecurityState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<UpdateSecurityState> build() async {
    return const UpdateSecurityState();
  }

  void updatePassword(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(password: value));
  }

  void updateNewPassword(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(newPassword: value));
  }

  void updateNewPasswordConfirm(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(newPasswordConfirm: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.password.isEmpty || current.newPassword.isEmpty || current.newPasswordConfirm.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Certains champs sont vides…']));
      return;
    }

    try {
      if (!await _profileRepository.checkPassword(current.password)) {
        state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Mauvais mot de passe…']));
        return;
      }

      state = AsyncData(current.copyWith(success: current.success + 1));
    } on FirebaseAuthException catch (_) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Nom de compte ou mot de passe erroné…']));
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Erreur interne…']));
    }
  }
}

final updateSecurityNotifierProvider = AsyncNotifierProvider<UpdateProfileNotifier, UpdateSecurityState>(
  () => UpdateProfileNotifier(),
);
