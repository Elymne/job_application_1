import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/core/themes/custom_color.dart';
import 'package:naxan_test/domain/repositories/profile_repository.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> {
  late final ProfileRepository _profileRepository = ref.read(profileRepoProvider);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await _profileRepository.isConnected()) {
        if (!mounted) return;
        AutoRouter.of(context).replacePath('/login');
        return;
      }

      final profile = await _profileRepository.getCurrent();
      if (profile == null) {
        if (!mounted) return;
        AutoRouter.of(context).replacePath('/create-profile');
        return;
      }

      // if (!mounted) return;
      // AutoRouter.of(context).replacePath('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator(color: customBlue, strokeWidth: 6)),
        ),
      ),
    );
  }
}
