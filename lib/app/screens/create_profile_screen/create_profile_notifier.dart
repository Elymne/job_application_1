import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

part 'create_profile_notifier.freezed.dart';

@freezed
abstract class CreateProfileState with _$CreateProfileState {
  const factory CreateProfileState({
    @Default("") String surname,
    @Default("") String firstname,
    @Default("") String filepath,
    @Default(false) bool isCreated,
    @Default([]) List<String> errorStack,
  }) = _CreateProfileState;
}

class CreateProfileNotifier extends AsyncNotifier<CreateProfileState> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<CreateProfileState> build() => const CreateProfileState();

  void updateSurname(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(surname: value));
  }

  void updateFirstname(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(firstname: value));
  }

  void updateFilepath(String value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(filepath: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.surname.isEmpty || current.firstname.isEmpty || current.filepath.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Certains champs sont vides…']));
      return;
    }

    if (current.surname.contains(' ') || current.firstname.contains(' ') || current.filepath.contains(' ')) {
      state = AsyncData(
        current.copyWith(
          errorStack: [...current.errorStack, 'Les valeurs des champs ne doivent contenir aucun espace…'],
        ),
      );
      return;
    }

    try {
      await _profileRepository.createProfile(current.surname, current.firstname, File(current.filepath));
      state = AsyncData(current.copyWith(isCreated: true));
    } on DioException catch (_) {
      state = AsyncData(
        current.copyWith(
          errorStack: [...current.errorStack, "Une erreur s'est produite lors avec l'enregistrement de l'image…"],
        ),
      );
    } on FirebaseAuthException catch (_) {
      state = AsyncData(
        current.copyWith(errorStack: [...current.errorStack, "Il y a un problème avec l'authentification…"]),
      );
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Oups… erreur lors de la sauvegarde…']));
    }
  }
}

final createProfileNotifierProvider = AsyncNotifierProvider<CreateProfileNotifier, CreateProfileState>(
  () => CreateProfileNotifier(),
);
