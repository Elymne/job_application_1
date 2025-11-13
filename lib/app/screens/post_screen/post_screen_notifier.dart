import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/notifiers/new_posts_notifier.dart';
import 'package:naxan_test/infra/firebase_post_repository.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

class PostScreenNotifier extends AsyncNotifier<PostBundle?> {
  late final _postRepository = ref.read(postRepoProvider);
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<PostBundle?> build() => null;

  Future<void> load(String id) async {
    state = const AsyncLoading();
    try {
      final post = await _postRepository.findUnique(id);
      if (post == null) {
        state = const AsyncData(null);
        return;
      }

      final profile = await _profileRepository.findProfile(post.profileId);
      if (profile == null) {
        state = const AsyncData(null);
        return;
      }

      state = AsyncData(PostBundle(postModel: post, profileModel: profile));
    } catch (e, stack) {
      state = AsyncError("Une erreur s'est produite durant la récupération des données", stack);
    }
  }
}

final postScreenNotifierProvider = AsyncNotifierProvider<PostScreenNotifier, PostBundle?>(() => PostScreenNotifier());
