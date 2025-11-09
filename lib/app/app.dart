import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/router/app_router.dart';
import 'package:naxan_test/core/themes/my_theme.dart';
import 'package:naxan_test/infra/firebase_profile_repository.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: appTheme,
      routerConfig: AppRouter(ref.read(profileRepoProvider)).config(),
    );
  }
}
