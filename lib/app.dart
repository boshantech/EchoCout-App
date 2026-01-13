import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_routes.dart';
import 'config/routes/route_paths.dart';
import 'config/theme/app_theme.dart';
import 'config/injector/service_locator.dart';
import 'core/enums/app_role.dart';
import 'features/auth/presentation/bloc/auth_bloc_complete.dart';
import 'features/home/presentation/bloc/home_bloc_complete.dart';
import 'features/echo/presentation/bloc/echo_bloc_complete.dart';
import 'features/scanner/presentation/bloc/scanner_bloc_complete.dart';
import 'features/rank/presentation/bloc/rank_bloc_complete.dart';
import 'features/profile/presentation/bloc/profile_bloc_complete.dart';
import 'features/driver_auth/presentation/bloc/driver_auth_bloc.dart';

class EchoApp extends StatefulWidget {
  const EchoApp({Key? key}) : super(key: key);

  @override
  State<EchoApp> createState() => _EchoAppState();
}

class _EchoAppState extends State<EchoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DriverAuthBloc>(
          create: (_) => getIt<DriverAuthBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(),
        ),
        BlocProvider<EchoBloc>(
          create: (_) => EchoBloc(),
        ),
        BlocProvider<ScannerBloc>(
          create: (_) => ScannerBloc(),
        ),
        BlocProvider<RankBloc>(
          create: (_) => RankBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'EchoCout',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: RoutePaths.splash,
        debugShowCheckedModeBanner: false,
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // CRITICAL: Route based on ROLE
              if (state.role == AppRole.driver) {
                // Driver authenticated - show driver app only
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/driver-home',
                  (route) => false,
                );
              } else {
                // User authenticated - show user app only
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutePaths.main,
                  (route) => false,
                );
              }
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

}