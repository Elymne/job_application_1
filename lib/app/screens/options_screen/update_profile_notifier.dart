import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

part 'update_profile_notifier.freezed.dart';

@freezed
abstract class UpdateProfileState with _$UpdateProfileState {
  const factory UpdateProfileState({
    @Default("") String firstname,
    @Default("") String surname,
    @Default(0) int success,
    @Default([]) List<String> errorStack,
  }) = _UpdateProfileState;
}

class UpdateProfileNotifier extends AsyncNotifier<UpdateProfileState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<UpdateProfileState> build() async {
    return const UpdateProfileState();
  }

  void updateFirstname(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(firstname: value));
  }

  void updateSurname(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(surname: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.firstname.isEmpty || current.surname.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Certains champs sont vides…']));
      return;
    }

    try {
      final updatedProfile = (await _profileRepository.getCurrent())?.copyWith(
        firstname: current.firstname,
        surname: current.surname,
      );

      await _profileRepository.updateProfile(profileModel: updatedProfile);
      state = AsyncData(current.copyWith(success: current.success + 1));
    } on FirebaseAuthException catch (_) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Nom de compte ou mot de passe erroné…']));
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Erreur interne…']));
    }
  }
}

final updateProfileNotifierProvider = AsyncNotifierProvider<UpdateProfileNotifier, UpdateProfileState>(
  () => UpdateProfileNotifier(),
);
