import 'package:flutter/material.dart';
import 'config/routes/app_routes.dart';
import 'config/routes/route_paths.dart';
import 'config/theme/app_theme.dart';

class EchoApp extends StatelessWidget {
  const EchoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: RoutePaths.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
