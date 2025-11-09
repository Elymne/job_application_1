import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

part 'login_notifier.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default("") String email,
    @Default("") String password,
    @Default(0) int success,
    @Default([]) List<String> errorStack,
  }) = _LoginState;
}

class LoginNotifier extends AsyncNotifier<LoginState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<LoginState> build() => const LoginState();

  void updateEmail(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(email: value));
  }

  void updatePassword(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(password: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.email.isEmpty || current.password.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Certains champs sont vides…']));
      return;
    }

    if (!current.email.contains('@')) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, "Format de l'adresse email invalide…"]));
      return;
    }

    try {
      await _profileRepository.login(current.email, current.password);
      if (!await _profileRepository.isConnected()) {
        state = AsyncData(
          current.copyWith(errorStack: [...current.errorStack, "Une erreur s'est produite malgrés la connexion…"]),
        );
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

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, LoginState>(() => LoginNotifier());
