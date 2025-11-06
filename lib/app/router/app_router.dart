import 'package:auto_route/auto_route.dart';
import 'package:naxan_test/app/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    /// *
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/create-profile', page: CreateProfileRoute.page),
    AutoRoute(path: '/create-user', page: CreateUserRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
