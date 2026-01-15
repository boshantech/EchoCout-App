import 'package:flutter/material.dart';
import '../config/theme/app_colors.dart';
import '../core/managers/driver_state_manager.dart';
import '../features/driver_home/presentation/pages/driver_home_screen.dart';

/// DRIVER-ONLY app shell with driver-specific bottom navigation and screens
/// 
/// This is the ROOT widget for DRIVER role only.
/// DO NOT add user screens here.
/// DO NOT share state with user app.
/// 
/// Driver tabs:
/// 0 - Home (requests)
/// 1 - Echo
/// 2 - Scanner
/// 3 - Rank
/// 4 - Profile
class DriverAppShell extends StatefulWidget {
  final DriverStateManager driverStateManager;

  const DriverAppShell({
    required this.driverStateManager,
    super.key,
  });

  @override
  State<DriverAppShell> createState() => _DriverAppShellState();
}

class _DriverAppShellState extends State<DriverAppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        // Driver Home - Shows requests
        return DriverHomeScreen(
          driverStateManager: widget.driverStateManager,
        );
      case 1:
        // Echo tab (driver version - placeholder)
        return _buildEchoTab();
      case 2:
        // Scanner tab (driver version - placeholder)
        return _buildScannerTab();
      case 3:
        // Rank tab (driver version - placeholder)
        return _buildRankTab();
      case 4:
        // Profile tab (driver version - placeholder)
        return _buildProfileTab();
      default:
        return DriverHomeScreen(
          driverStateManager: widget.driverStateManager,
        );
    }
  }

  /// Driver Echo Tab - Separate from user echo
  Widget _buildEchoTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco,
            size: 80,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Driver Echo',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  /// Driver Scanner Tab - Separate from user scanner
  Widget _buildScannerTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Driver Scanner',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  /// Driver Rank Tab - Separate from user rank
  Widget _buildRankTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 80,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Driver Rank',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  /// Driver Profile Tab - Separate from user profile
  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 80,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Driver Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              widget.driverStateManager.logout();
              Navigator.pushReplacementNamed(context, '/driver-login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Driver-only bottom navigation bar
  /// NEVER share this with user bottom nav
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      backgroundColor: AppColors.background,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.eco),
          label: 'Echo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Rank',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
