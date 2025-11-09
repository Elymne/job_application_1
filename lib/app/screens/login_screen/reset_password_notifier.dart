import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

part 'reset_password_notifier.freezed.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default("") String email,
    @Default(0) int success,
    @Default([]) List<String> errorStack,
  }) = _ResetPasswordState;
}

class ResetPasswordNotifier extends AsyncNotifier<ResetPasswordState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<ResetPasswordState> build() => const ResetPasswordState();

  void updateEmail(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(email: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.email.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Il faut un email…']));
      return;
    }

    if (!current.email.contains('@')) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, "Format de l'adresse email invalide…"]));
      return;
    }

    try {
      await _profileRepository.resetPassword(current.email);
      state = AsyncData(current.copyWith(success: current.success + 1, email: ''));
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, "Erreur interne"]));
    }
  }
}

final resetPasswordNotifierProvider = AsyncNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  () => ResetPasswordNotifier(),
);
