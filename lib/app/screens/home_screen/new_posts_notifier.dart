import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/domain/models/post_model.dart';
import 'package:naxan_test/domain/models/profile_model.dart';
import 'package:naxan_test/infra/firebase_post_repository.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

// TODO: Changer mon PostModel mais flemme.
class PostBundle {
  final PostModel postModel;
  final ProfileModel profileModel;
  PostBundle({required this.postModel, required this.profileModel});
}

class NewPostNotifier extends AsyncNotifier<List<PostBundle>> {
  late final _postRepository = ref.read(postRepoProvider);
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<List<PostBundle>> build() => [];

  Future<void> load() async {
    state = const AsyncLoading();
    try {
      final List<PostBundle> bundles = [];
      final posts = await _postRepository.findNewest();
      for (final post in posts) {
        final profile = await _profileRepository.findProfile(post.profileId);
        if (profile == null) continue;
        bundles.add(PostBundle(postModel: post, profileModel: profile));
      }
      state = AsyncData(bundles);
    } catch (e, stack) {
      state = AsyncError("Une erreur s'est produite durant la récupération des données", stack);
    }
  }

  Future<void> deleteById(String id) async {
    try {
      await _postRepository.delete(id);
      await load();
    } catch (e, stack) {
      state = AsyncError("Une erreur s'est produite durant la récupération des données", stack);
    }
  }

  Future<void> reportById(String id) async {
    try {
      await _postRepository.report(id);
    } catch (e, stack) {
      state = AsyncError("Une erreur s'est produite durant la récupération des données", stack);
    }
  }
}

final newPostNotifierProvider = AsyncNotifierProvider<NewPostNotifier, List<PostBundle>>(() => NewPostNotifier());
