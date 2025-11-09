import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

part 'create_account_notifier.freezed.dart';

@freezed
abstract class CreateAccountState with _$CreateAccountState {
  const factory CreateAccountState({
    @Default("") String email,
    @Default("") String password,
    @Default("") String passwordConfirm,
    @Default(false) bool isCreated,
    @Default([]) List<String> errorStack,
  }) = _CreateAccountState;
}

class CreateAccountNotifier extends AsyncNotifier<CreateAccountState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<CreateAccountState> build() => const CreateAccountState();

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

  void updateConfirmPwd(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(passwordConfirm: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.email.isEmpty || current.password.isEmpty || current.passwordConfirm.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Il faut remplir tous les champs…']));
      return;
    }

    if (current.email.contains(' ') || current.password.contains(' ') || current.passwordConfirm.contains(' ')) {
      state = AsyncData(
        current.copyWith(
          errorStack: [...current.errorStack, 'Les valeurs des champs ne doivent contenir aucun espace…'],
        ),
      );
      return;
    }

    if (!current.email.contains('@')) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, "Format de l'adresse email invalide…"]));
      return;
    }

    if (current.password.length < 6) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, "Le mot de passe n'est pas assez long…"]));
      return;
    }

    if (current.password != current.passwordConfirm) {
      state = AsyncData(
        current.copyWith(errorStack: [...current.errorStack, "Les deux mots de passe rentrés ne sont pas identiques"]),
      );
      return;
    }

    try {
      await _profileRepository.addNewAccount(current.email, current.password);
      state = AsyncData(current.copyWith(isCreated: true));
    } on FirebaseAuthException catch (_) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Email surement déjà utilisé…']));
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'erreur interne']));
    }
  }
}

final createAccountNotifierProvider = AsyncNotifierProvider<CreateAccountNotifier, CreateAccountState>(
  () => CreateAccountNotifier(),
);
