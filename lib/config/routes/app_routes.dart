import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/phone_input_page.dart';
import '../../features/auth/presentation/pages/driver_otp_verification_page.dart';
import '../../features/main/presentation/pages/main_page_mock.dart';
import '../../features/home/presentation/pages/waste_item_detail_screen.dart';
import '../../features/driver_auth/presentation/pages/driver_phone_login_screen.dart';
import '../../features/driver_auth/presentation/bloc/driver_auth_bloc.dart';
import '../../features/driver_home/presentation/pages/driver_home_screen.dart';
import '../../features/driver_requests/presentation/pages/driver_request_detail_screen.dart';
import '../../core/managers/driver_state_manager.dart';
import '../../config/injector/service_locator.dart';
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
      case RoutePaths.driverLogin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<DriverAuthBloc>(
            create: (_) => getIt<DriverAuthBloc>(),
            child: const DriverPhoneLoginScreen(),
          ),
          settings: settings,
        );
      case RoutePaths.driverHome:
        final driverStateManager = settings.arguments as DriverStateManager?
            ?? DriverStateManager();
        return MaterialPageRoute(
          builder: (_) => DriverHomeScreen(driverStateManager: driverStateManager),
          settings: settings,
        );
      case RoutePaths.driverRequestDetail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final request = args['request'];
        final driverStateManager = args['driverStateManager'] as DriverStateManager?
            ?? DriverStateManager();
        return MaterialPageRoute(
          builder: (_) => DriverRequestDetailScreen(
            request: request,
            driverStateManager: driverStateManager,
          ),
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


