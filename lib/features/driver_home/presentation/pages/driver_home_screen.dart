import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/managers/driver_state_manager.dart';
import '../widgets/request_card.dart';

class DriverHomeScreen extends StatefulWidget {
  final DriverStateManager driverStateManager;

  const DriverHomeScreen({
    Key? key,
    required this.driverStateManager,
  }) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.driverStateManager.initialize();
  }

  void _switchToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.forestGreen,
        title: const Text('Driver Home', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing driver profile...')),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Help'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  widget.driverStateManager.logout();
                  Navigator.of(context).pushReplacementNamed('/driver-login');
                },
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.driverStateManager,
        builder: (context, _) {
          if (_currentTabIndex == 0) {
            return _buildHomeContent();
          } else if (_currentTabIndex == 1) {
            return _buildEchoTab();
          } else if (_currentTabIndex == 2) {
            return _buildScannerTab();
          } else if (_currentTabIndex == 3) {
            return _buildRankTab();
          } else {
            return _buildProfileTab();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.forestGreen,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Echo'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up_outlined), activeIcon: Icon(Icons.trending_up), label: 'Rank'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _switchToTab,
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header card with driver stats
          Container(
            color: AppColors.forestGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver profile section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        widget.driverStateManager.currentDriver?.profileImage ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.driverStateManager.currentDriver?.name ?? 'Driver',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.driverStateManager.currentDriver?.area ?? 'Service Area',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Points',
                        value: '${widget.driverStateManager.currentDriver?.pointsEarned.toStringAsFixed(0) ?? '0'}',
                        icon: Icons.star,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Nature Saved',
                        value: '${widget.driverStateManager.currentDriver?.natureSavedPercentage.toStringAsFixed(1) ?? '0'}%',
                        icon: Icons.eco,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total requests section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.leafGreen.withOpacity(0.1),
                border: Border.all(color: AppColors.leafGreen.withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Requests in Your Area',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.driverStateManager.totalRequestsInArea} requests',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.leafGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.forestGreen,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Available requests header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Requests',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestGreen,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withOpacity(0.2),
                    border: Border.all(color: AppColors.accentYellow, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.driverStateManager.availableRequests.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentYellow,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Requests list
          if (widget.driverStateManager.availableRequests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 56, color: AppColors.textTertiary),
                    const SizedBox(height: 16),
                    Text(
                      'No available requests',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'New requests will appear here soon',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.driverStateManager.availableRequests.length,
                itemBuilder: (context, index) {
                  final request = widget.driverStateManager.availableRequests[index];
                  return RequestCard(
                    request: request,
                    onTap: () {
                      // Navigate to request detail screen
                      Navigator.pushNamed(
                        context,
                        '/driver-request-detail',
                        arguments: {
                          'request': request,
                          'driverStateManager': widget.driverStateManager,
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEchoTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Echo Tab - Coming Soon',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Scanner Tab - Coming Soon',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildRankTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Rank Tab - Coming Soon',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Profile Tab - Coming Soon',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
