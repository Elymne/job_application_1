import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naxan_test/infra/firebase_post_repository.dart';
import 'dart:async';
import 'dart:io';

part 'create_post_notifier.freezed.dart';

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    @Default("") String filepath,
    @Default("") String description,
    @Default(false) bool isCreated,
    @Default([]) List<String> errorStack,
  }) = _CreatePostState;
}

class CreatePostNotifier extends AsyncNotifier<CreatePostState> {
  late final _createPostRepository = ref.read(postRepoProvider);

  @override
  FutureOr<CreatePostState> build() => const CreatePostState();

  void updateFilePath(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(filepath: value));
  }

  void updateDescription(String value) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(description: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null) return;

    if (current.description.isEmpty || current.filepath.isEmpty) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'Il faut remplir tous les champs…']));
      return;
    }

    try {
      await _createPostRepository.create(current.description, File(current.filepath));
      state = AsyncData(current.copyWith(isCreated: true));
    } on FirebaseAuthException catch (_) {
      state = AsyncData(
        current.copyWith(errorStack: [...current.errorStack, "Une erreur s'est produite avec le serveur…"]),
      );
    } catch (e) {
      state = AsyncData(current.copyWith(errorStack: [...current.errorStack, 'erreur interne']));
    }
  }
}

final createPostNotifierProvider = AsyncNotifierProvider<CreatePostNotifier, CreatePostState>(
  () => CreatePostNotifier(),
);
