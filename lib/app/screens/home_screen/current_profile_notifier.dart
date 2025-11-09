import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/domain/models/profile_model.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';
import 'dart:async';

class CurrentProfileNotifier extends AsyncNotifier<ProfileModel?> {
  late final _profileRepository = ref.read(profileRepoProvider);

  @override
  FutureOr<ProfileModel?> build() => null;

  Future<void> load() async {
    state = const AsyncLoading();
    try {
      final currentProfile = await _profileRepository.getCurrent();
      state = AsyncData(currentProfile);
    } catch (e, stack) {
      state = AsyncError("Une erreur s'est produite durant la récupération des données", stack);
    }
  }
}

final currentProfileNotifierProvider = AsyncNotifierProvider<CurrentProfileNotifier, ProfileModel?>(
  () => CurrentProfileNotifier(),
);
