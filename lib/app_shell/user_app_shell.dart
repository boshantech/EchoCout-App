import 'package:flutter/material.dart';
import '../features/main/presentation/pages/main_page_mock.dart';

/// USER-ONLY app shell with user-specific bottom navigation and screens
/// 
/// This is the ROOT widget for USER role only.
/// DO NOT add driver screens here.
/// DO NOT share state with driver app.
class UserAppShell extends StatefulWidget {
  const UserAppShell({Key? key}) : super(key: key);

  @override
  State<UserAppShell> createState() => _UserAppShellState();
}

class _UserAppShellState extends State<UserAppShell> {
  @override
  Widget build(BuildContext context) {
    return const MainPageMock();
  }
}
