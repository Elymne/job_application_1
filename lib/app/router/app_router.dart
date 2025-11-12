import 'package:auto_route/auto_route.dart';
import 'package:naxan_test/app/router/app_router.gr.dart';
import 'package:naxan_test/domain/repositories/profile_repository.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final ProfileRepository _profileRepo;

  AppRouter(this._profileRepo);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // * Entry point: Un splashscreen classique.
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),

    // * Login/profile creation…
    AutoRoute(path: '/login', page: LoginRoute.page, guards: [_LoginGuard(_profileRepo)]),
    AutoRoute(path: '/create-account', page: CreateAccountRoute.page),
    AutoRoute(path: '/create-profile', page: CreateProfileRoute.page, guards: [_CreateProfileGuard(_profileRepo)]),

    // * Main App screens.
    AutoRoute(path: '/home', page: HomeRoute.page, guards: [_AuthGuard(_profileRepo)]),
    AutoRoute(path: '/create-post', page: CreatePostRoute.page, guards: [_AuthGuard(_profileRepo)]),
    AutoRoute(path: '/options', page: OptionsRoute.page, guards: [_AuthGuard(_profileRepo)]),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}

class _LoginGuard extends AutoRouteGuard {
  final ProfileRepository _profileRepository;
  _LoginGuard(this._profileRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasProfile = await _profileRepository.getCurrent() != null;
    if (hasProfile) {
      router.replacePath('/home');
      return;
    }

    final isConnected = await _profileRepository.isConnected();
    if (isConnected) {
      router.replacePath('/create-profile');
      return;
    }

    resolver.next(true);
  }
}

class _CreateProfileGuard extends AutoRouteGuard {
  final ProfileRepository _profileRepository;
  _CreateProfileGuard(this._profileRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isConnected = await _profileRepository.isConnected();
    if (!isConnected) {
      router.replacePath('/login');
      return;
    }

    resolver.next(true);
  }
}

class _AuthGuard extends AutoRouteGuard {
  final ProfileRepository _profileRepository;
  _AuthGuard(this._profileRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isConnected = await _profileRepository.isConnected();
    if (!isConnected) {
      router.replacePath('/login');
      return;
    }

    final hasProfile = await _profileRepository.getCurrent() != null;
    if (!hasProfile) {
      router.replacePath('/create-profile');
      return;
    }

    resolver.next(true);
  }
}
