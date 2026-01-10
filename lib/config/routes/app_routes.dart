import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/phone_input_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/main/presentation/pages/main_page_mock.dart';
import '../../features/home/presentation/pages/waste_item_detail_screen.dart';
import 'route_paths.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case RoutePaths.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
          settings: settings,
        );
      case RoutePaths.phoneAuth:
        return MaterialPageRoute(
          builder: (_) => const PhoneInputPage(),
          settings: settings,
        );
      case RoutePaths.otpVerification:
        final phone = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(phoneNumber: phone),
          settings: settings,
        );
      case RoutePaths.main:
        return MaterialPageRoute(
          builder: (_) => const MainPageMock(),
          settings: settings,
        );
      case RoutePaths.wasteItemDetail:
        final item = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => WasteItemDetailScreen(wasteItem: item),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }
}


