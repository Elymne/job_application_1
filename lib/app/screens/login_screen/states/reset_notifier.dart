import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/screens/login_screen/states/reset.dart';
import 'package:naxan_test/domain/repositories/profile_repository.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

final resetNotifierProvider = AsyncNotifierProvider<ResetNotifier, Reset>(
  () => ResetNotifier(),
);

class ResetNotifier extends AsyncNotifier<Reset> {
  late final ProfileRepository _profileRepository = ref.read(
    profileRepoProvider,
  );

  @override
  FutureOr<Reset> build() {
    return const Reset();
  }

  void reset() {
    state = const AsyncData(Reset());
  }

  void updateEmail(String email) {
    state = AsyncData(state.value!.copyWith(email: email, error: null));
  }

  Future<void> submit() async {
    if (state.value == null) {
      return;
    }

    if (!state.value!.email.contains('@')) {
      state = AsyncData(
        state.value!.copyWith(
          error: "Format de l'email invalide",
          state: ResetState.failure,
        ),
      );
      return;
    }

    try {
      state = const AsyncLoading();
      await _profileRepository.resetPassword(state.value!.email);
      state = AsyncData(
        state.value!.copyWith(error: null, state: ResetState.success),
      );
    } catch (e) {
      state = AsyncData(
        state.value!.copyWith(
          error: 'Erreur interne',
          state: ResetState.failure,
        ),
      );
    }
  }
}
