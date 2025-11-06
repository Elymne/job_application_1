import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, LoginState>(
  () => LoginNotifier(),
);

class LoginNotifier extends AsyncNotifier<LoginState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  // * Form values.
  String email = "";
  String password = "";

  @override
  FutureOr<LoginState> build() {
    return LoginState();
  }

  void updateEmail(String value) => email = value;

  void updatePwd(String value) => password = value;

  Future<void> submit() async {
    if (state.value == null) {
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      state = AsyncData(
        LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Il faut remplir les deux champs',
        ),
      );
      return;
    }

    if (email.contains('@')) {
      state = AsyncData(
        LoginState(
          status: LoginStatus.failure,
          errorMessage: "Format de l'adresse email invalide",
        ),
      );
      return;
    }

    try {
      state = const AsyncLoading();
      await _profileRepository.login(email, password);
      state = AsyncData(LoginState(status: LoginStatus.success));
    } on FirebaseAuthException catch (_) {
      state = AsyncData(
        LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Nom de compte ou mot de passe erroné',
        ),
      );
    } catch (e) {
      state = AsyncData(
        LoginState(status: LoginStatus.failure, errorMessage: 'Erreur interne'),
      );
    }
  }
}

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  LoginState({this.status = LoginStatus.none, this.errorMessage});
}

enum LoginStatus { none, success, failure }
