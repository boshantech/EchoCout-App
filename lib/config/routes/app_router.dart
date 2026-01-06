import 'package:flutter/material.dart';
import 'route_paths.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.login:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.register:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.onboarding:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.home:
        return _buildRoute(settings, const SizedBox());
      default:
        return _buildRoute(settings, const SizedBox());
    }
  }

  static Route<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => page,
    );
  }

  static String getInitialRoute(bool isLoggedIn, bool hasSeenOnboarding) {
    if (isLoggedIn) {
      return RoutePaths.home;
    } else if (hasSeenOnboarding) {
      return RoutePaths.login;
    } else {
      return RoutePaths.splash;
    }
  }
}
