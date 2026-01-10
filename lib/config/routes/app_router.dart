import 'package:flutter/material.dart';
import 'route_paths.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.onboarding:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.phoneAuth:
        return _buildRoute(settings, const SizedBox());
      case RoutePaths.main:
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
      return RoutePaths.main;
    } else if (hasSeenOnboarding) {
      return RoutePaths.phoneAuth;
    } else {
      return RoutePaths.splash;
    }
  }
}
