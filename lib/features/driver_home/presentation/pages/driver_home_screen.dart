import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/managers/driver_state_manager.dart';
import '../../../../core/models/driver_models.dart';
import '../widgets/compact_request_card.dart';
import '../widgets/hidden_request_card.dart';
import '../widgets/transferred_request_card.dart';
import '../widgets/transferred_to_me_card.dart';
import '../widgets/transfer_summary_strip.dart';
import '../widgets/request_filter_tabs.dart';
import '../widgets/request_empty_state.dart';
import '../widgets/driver_bottom_navigation.dart';
import '../widgets/filter_bottom_sheet.dart';

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
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    widget.driverStateManager.initialize();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.forestGreen,
          title: const Text(
            'Driver Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, size: 20),
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
      ),
      body: ListenableBuilder(
        listenable: widget.driverStateManager,
        builder: (context, _) {
          if (_currentTabIndex == 0) {
            return _buildHomeContent();
          } else if (_currentTabIndex == 1) {
            return _buildEchoTab();
          } else if (_currentTabIndex == 2) {
            return _buildRankTab();
          } else {
            return _buildProfileTab();
          }
        },
      ),
      bottomNavigationBar: DriverBottomNavigation(
        currentIndex: _currentTabIndex,
        onTap: _switchToTab,
      ),
    );
  }

  Widget _buildHomeContent() {
    return ListenableBuilder(
      listenable: widget.driverStateManager,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // COMPACT HEADER
              _buildCompactHeader(),

              // SEARCH AND FILTER BAR
              _buildSearchAndFilterBar(),

              // REQUEST FILTER TABS
              RequestFilterTabs(
                currentFilter: widget.driverStateManager.currentFilter,
                activeCount: widget.driverStateManager.activeCount,
                hiddenCount: widget.driverStateManager.hiddenCount,
                transferredCount: widget.driverStateManager.transferredCount,
                transferredToMeCount: widget.driverStateManager.transferredToMeCount,
                onFilterChanged: (filter) {
                  widget.driverStateManager.setFilter(filter);
                },
              ),

              // REQUEST CARDS LIST (with animation)
              _buildRequestsList(),
            ],
          ),
        );
      },
    );
  }

  /// Compact header with driver info and stats
  Widget _buildCompactHeader() {
    final driver = widget.driverStateManager.currentDriver;
    
    return Container(
      color: AppColors.forestGreen,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DRIVER PROFILE ROW (Compact)
          Row(
            children: [
              // Avatar (smaller)
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  driver?.profileImage ?? '',
                ),
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(width: 12),
              
              // Name & Area (no extra spacing)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver?.name ?? 'Driver',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      driver?.area ?? 'Service Area',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),

          // STATS ROW (Compact cards, side-by-side)
          Row(
            children: [
              // Points Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Points',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${driver?.pointsEarned.toStringAsFixed(0) ?? '0'}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 10),

              // Nature Saved Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saved',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${driver?.natureSavedPercentage.toStringAsFixed(1) ?? '0'}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Search and Filter bar for requests
  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Search Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.leafGreen.withOpacity(0.08),
                border: Border.all(
                  color: AppColors.leafGreen.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search requests...',
                  hintStyle: TextStyle(
                    color: AppColors.textTertiary.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.forestGreen.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
                onChanged: (value) {
                  // Handle search
                  widget.driverStateManager.setSearchQuery(value);
                },
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Filter Button
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => FilterBottomSheet(
        driverStateManager: widget.driverStateManager,
      ),
    );
  }

  /// Requests list with filter handling
  Widget _buildRequestsList() {
    final filteredRequests = widget.driverStateManager.filteredRequests;
    final filter = widget.driverStateManager.currentFilter;

    // Show empty state if no requests for current filter
    if (filteredRequests.isEmpty) {
      return RequestEmptyState(filter: filter);
    }

    // For transferredToMe filter, show summary strip at the top
    List<Widget> children = [];
    
    if (filter == RequestFilter.transferredToMe) {
      children.add(
        TransferSummaryStrip(
          acceptedCount: widget.driverStateManager.acceptedTransfersCount,
          rejectedCount: widget.driverStateManager.rejectedTransfersCount,
        ),
      );
    }

    children.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: ListView.separated(
            key: ValueKey(filter),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRequests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final request = filteredRequests[index];

              // Render appropriate card based on filter
              if (filter == RequestFilter.hidden) {
                return HiddenRequestCard(
                  request: request,
                  onUnhide: () {
                    widget.driverStateManager.unhideRequest(request);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request restored to Active'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onTransfer: () {
                    // TODO: Open transfer dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transfer feature coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              } else if (filter == RequestFilter.transferred) {
                return TransferredRequestCard(request: request);
              } else if (filter == RequestFilter.transferredToMe) {
                return TransferredToMeCard(
                  request: request,
                  transferredByDriverName: request.transferredByDriverName ?? 'Unknown Driver',
                  onAccept: () {
                    widget.driverStateManager.acceptTransferedRequest(request);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request from ${request.userName} accepted!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.leafGreen,
                      ),
                    );
                  },
                  onReject: () {
                    widget.driverStateManager.rejectTransferedRequest(request);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request rejected'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              } else {
                // Active requests
                return CompactRequestCard(
                  request: request,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/driver-request-detail',
                      arguments: {
                        'request': request,
                        'driverStateManager': widget.driverStateManager,
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );

    return Column(children: children);
  }

  Widget _buildEchoTab() {
    return ListenableBuilder(
      listenable: widget.driverStateManager,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Earnings & Stats Section (Collapsible)
              _buildEarningsSection(),

              const SizedBox(height: 12),

              // Pending Pickups Section
              _buildPendingPickupsSection(),

              const SizedBox(height: 12),

              // History Section
              _buildHistorySection(),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// Collapsible Earnings & Stats Section
  Widget _buildEarningsSection() {
    final driver = widget.driverStateManager.currentDriver;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: StatefulBuilder(
        builder: (context, setState) {
          return _EarningsCard(driver: driver);
        },
      ),
    );
  }

  /// Pending Pickups Section (Accepted but not picked up)
  Widget _buildPendingPickupsSection() {
    final acceptedRequests = widget.driverStateManager.acceptedRequests;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StatefulBuilder(
        builder: (context, setState) {
          return _CollapsiblePendingPickupsCard(
            requests: acceptedRequests,
          );
        },
      ),
    );
  }

  /// History Section (Completed & Cancelled Pickups)
  Widget _buildHistorySection() {
    final completedRequests = widget.driverStateManager.completedRequests;
    final cancelledRequests = widget.driverStateManager.rejectedTransfersRequests;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StatefulBuilder(
        builder: (context, setState) {
          return _HistoryCard(
            completedRequests: completedRequests,
            cancelledRequests: cancelledRequests,
          );
        },
      ),
    );
  }

  Widget _buildScannerTab() {
    return const Center(child: Text('Scanner Tab'));
  }

  Widget _buildRankTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // ═══════════════════════════════════════════════════════════
          // CURRENT RANK SECTION
          // ═══════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.forestGreen.withOpacity(0.9),
                    AppColors.leafGreen.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Current Rank',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#27',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '4250 points',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.scale_outlined,
                        size: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '214 kg waste sold',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _switchToTab(1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: AppColors.forestGreen,
                      ),
                      label: Text(
                        'View My History',
                        style: TextStyle(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ═══════════════════════════════════════════════════════════
          // TOP 10 PRIZES SECTION
          // ═══════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      color: AppColors.accentYellow,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reach TOP 10 & Win Prizes!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final prizes = [
                        {'rank': '#1', 'prize': 'Premium Blender'},
                        {'rank': '#2', 'prize': 'Smart Speaker'},
                        {'rank': '#3', 'prize': 'Smart Watch'},
                        {'rank': '#4', 'prize': 'Wireless Speaker'},
                        {'rank': '#5', 'prize': 'Power Bank'},
                      ];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == 4 ? 0 : 10,
                        ),
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.forestGreen,
                                AppColors.leafGreen,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                prizes[index]['rank']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                prizes[index]['prize']! as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ═══════════════════════════════════════════════════════════
          // TOP 10 WINNERS SECTION
          // ═══════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top 10 Winners',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final topDrivers = [
                        {'rank': 1, 'name': 'Rajesh', 'points': '9367 pts'},
                        {'rank': 2, 'name': 'Priya', 'points': '8126 pts'},
                        {'rank': 3, 'name': 'Amit', 'points': '7845 pts'},
                        {'rank': 4, 'name': 'Neha', 'points': '7432 pts'},
                        {'rank': 5, 'name': 'Rohan', 'points': '7125 pts'},
                        {'rank': 6, 'name': 'Sneha', 'points': '6876 pts'},
                        {'rank': 7, 'name': 'Vikram', 'points': '6543 pts'},
                        {'rank': 8, 'name': 'Shreya', 'points': '6234 pts'},
                        {'rank': 9, 'name': 'Arjun', 'points': '5987 pts'},
                        {'rank': 10, 'name': 'Divya', 'points': '5654 pts'},
                      ];

                      final driver = topDrivers[index];
                      final isTopThree = index < 3;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == 9 ? 0 : 10,
                        ),
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.divider,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: isTopThree
                                      ? AppColors.accentYellow.withOpacity(0.2)
                                      : AppColors.textTertiary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${driver['rank']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isTopThree
                                          ? AppColors.accentYellow
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.forestGreen.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  size: 18,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                driver['name']! as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                driver['points']! as String,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ═══════════════════════════════════════════════════════════
          // HOW TO REACH TOP 10 SECTION
          // ═══════════════════════════════════════════════════════════
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to reach TOP 10?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTipCard(
                  icon: Icons.check_circle,
                  title: 'Sell maximum waste consistently',
                  subtitle: 'The more you collect, the more points!',
                ),
                const SizedBox(height: 8),
                _buildTipCard(
                  icon: Icons.star,
                  title: 'Maintain high-quality uploads',
                  subtitle: 'Better images = better points!',
                ),
                const SizedBox(height: 8),
                _buildTipCard(
                  icon: Icons.recycling,
                  title: 'Reduce plastic & e-waste',
                  subtitle: 'Earn bonus points for eco-friendly waste!',
                ),
                const SizedBox(height: 8),
                _buildTipCard(
                  icon: Icons.emoji_events,
                  title: 'Complete all achievements',
                  subtitle: 'Unlock bonuses for consistent performance!',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withOpacity(0.05),
        border: Border.all(
          color: AppColors.forestGreen.withOpacity(0.2),
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.forestGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return ListenableBuilder(
      listenable: widget.driverStateManager,
      builder: (context, _) {
        final driver = widget.driverStateManager.currentDriver;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // PROFILE HEADER
              _buildProfileHeader(driver),

              const SizedBox(height: 24),

              // PERSONAL DETAILS SECTION
              _buildPersonalDetailsSection(driver),

              const SizedBox(height: 24),

              // VERIFICATION & KYC STATUS SECTION
              _buildVerificationSection(driver),

              const SizedBox(height: 24),

              // LOGOUT SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildLogoutButton(context),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// Profile Header with circular image, name, and mobile
  Widget _buildProfileHeader(DriverProfile? driver) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.forestGreen.withOpacity(0.85),
            AppColors.leafGreen.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // Circular Profile Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                driver?.profileImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Driver Name
          Text(
            driver?.name ?? 'Driver Name',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 8),

          // Mobile Number (Masked)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Text(
                _maskPhoneNumber(driver?.phoneNumber ?? ''),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Personal Details Section
  Widget _buildPersonalDetailsSection(DriverProfile? driver) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.leafGreen.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: AppColors.leafGreen.withOpacity(0.1),
            ),

            // Detail Rows
            _buildDetailRow('Full Name', driver?.name ?? 'N/A'),
            _buildDetailDivider(),
            _buildDetailRow('Mobile Number', _maskPhoneNumber(driver?.phoneNumber ?? '')),
            _buildDetailDivider(),
            _buildDetailRow('Age', '32 years'),
            _buildDetailDivider(),
            _buildDetailRow('Gender', 'Male'),
            _buildDetailDivider(),
            _buildDetailRow('Service Area', driver?.area ?? 'N/A'),
            _buildDetailDivider(),
            _buildDetailRow('Total Earned', '₹${driver?.totalEarned.toStringAsFixed(0) ?? '0'}'),
          ],
        ),
      ),
    );
  }

  /// Detail Row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Divider between detail rows
  Widget _buildDetailDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: AppColors.leafGreen.withOpacity(0.08),
      ),
    );
  }

  /// Verification & KYC Status Section
  Widget _buildVerificationSection(DriverProfile? driver) {
    final verificationStatus = {
      'Aadhaar Card': true,
      'PAN Card': true,
      'Mobile Number Verification': true,
      'Bank KYC Verification': false,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.leafGreen.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 20,
                    color: AppColors.forestGreen,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Verification & KYC Status',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: AppColors.leafGreen.withOpacity(0.1),
            ),

            // Verification Status Rows
            ...verificationStatus.entries.map((entry) {
              final documentName = entry.key;
              final isVerified = entry.value;
              return _buildVerificationRow(
                documentName: documentName,
                isVerified: isVerified,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Verification Status Row
  Widget _buildVerificationRow({
    required String documentName,
    required bool isVerified,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.leafGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.leafGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.leafGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () => _launchVerificationUrl(documentName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentYellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.accentYellow.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 12,
                          color: AppColors.accentYellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.accentYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            color: AppColors.leafGreen.withOpacity(0.08),
          ),
        ),
      ],
    );
  }

  /// Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          elevation: 0,
        ),
        icon: const Icon(
          Icons.logout_rounded,
          size: 20,
        ),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Show Logout Confirmation Dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout? You will need to login again to access your account.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performLogout(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Perform Logout
  void _performLogout(BuildContext context) {
    widget.driverStateManager.logout();
    Navigator.of(context).pushReplacementNamed('/driver-login');
  }

  /// Launch Verification URL
  void _launchVerificationUrl(String documentName) {
    const verificationUrl = 'https://verify.echocout.com';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening verification for $documentName...'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.forestGreen,
      ),
    );
  }

  /// Mask Phone Number
  String _maskPhoneNumber(String phone) {
    if (phone.isEmpty || phone.length < 4) return phone;
    final lastFour = phone.substring(phone.length - 4);
    return '****${lastFour}';
  }
}

/// Earnings Card - Collapsible widget for earnings and stats
class _EarningsCard extends StatefulWidget {
  final DriverProfile? driver;

  const _EarningsCard({
    Key? key,
    required this.driver,
  }) : super(key: key);

  @override
  State<_EarningsCard> createState() => __EarningsCardState();
}

class __EarningsCardState extends State<_EarningsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Always Visible)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 20,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earnings & Stats',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Tap to expand',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_less_rounded,
                      size: 24,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content (Expandable)
          SizeTransition(
            sizeFactor: _animationController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Divider(
                    color: AppColors.leafGreen.withOpacity(0.1),
                    height: 1,
                    thickness: 1,
                  ),
                  const SizedBox(height: 14),

                  // Earnings Grid
                  Row(
                    children: [
                      // Total Earned
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.trending_up_rounded,
                          label: 'Total Earned',
                          value: '₹${driver?.totalEarned.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.leafGreen,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Withdrawn
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.download_rounded,
                          label: 'Withdrawn',
                          value: '₹${driver?.amountWithdrawn.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.accentYellow,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      // Points
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.star_rounded,
                          label: 'Points',
                          value: '${driver?.pointsEarned.toStringAsFixed(0) ?? '0'}',
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Nature Saved
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.eco_rounded,
                          label: 'Nature Saved',
                          value: '${driver?.natureSavedPercentage.toStringAsFixed(1) ?? '0'}%',
                          color: AppColors.leafGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapsible Pending Pickups Card
class _CollapsiblePendingPickupsCard extends StatefulWidget {
  final List<PickupRequest> requests;

  const _CollapsiblePendingPickupsCard({
    Key? key,
    required this.requests,
  }) : super(key: key);

  @override
  State<_CollapsiblePendingPickupsCard> createState() =>
      __CollapsiblePendingPickupsCardState();
}

class __CollapsiblePendingPickupsCardState
    extends State<_CollapsiblePendingPickupsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Always Visible)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Pickups',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.requests.length} pickup${widget.requests.length != 1 ? 's' : ''} pending',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Icon
                  RotationTransition(
                    turns: _animationController,
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 24,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content (Collapsible)
          SizeTransition(
            sizeFactor: _animationController,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: AppColors.leafGreen.withOpacity(0.1),
                ),
                if (widget.requests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No pending pickups',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.requests.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 8,
                      thickness: 0,
                      color: Colors.transparent,
                    ),
                    itemBuilder: (context, index) {
                      final request = widget.requests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: _buildPendingPickupCardCompact(request),
                      );
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingPickupCardCompact(PickupRequest request) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.leafGreen.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(request.userProfileImage),
            backgroundColor: AppColors.leafGreen.withOpacity(0.1),
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${request.quantity.toStringAsFixed(1)}kg • ${request.distanceKm.toStringAsFixed(1)}km',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '₹${request.estimatedAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.accentYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// History Card - Collapsible widget with tabs for Completed and Cancelled pickups
class _HistoryCard extends StatefulWidget {
  final List<PickupRequest> completedRequests;
  final List<PickupRequest> cancelledRequests;

  const _HistoryCard({
    Key? key,
    required this.completedRequests,
    required this.cancelledRequests,
  }) : super(key: key);

  @override
  State<_HistoryCard> createState() => __HistoryCardState();
}

class __HistoryCardState extends State<_HistoryCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  int _selectedTab = 0; // 0 = Completed, 1 = Cancelled
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.completedRequests.length;
    final cancelledCount = widget.cancelledRequests.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.leafGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Always Visible)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup History',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$completedCount completed • $cancelledCount cancelled',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Icon
                  RotationTransition(
                    turns: _animationController,
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 24,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content (Collapsible)
          SizeTransition(
            sizeFactor: _animationController,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: AppColors.leafGreen.withOpacity(0.1),
                ),
                // Tab Selector
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Completed Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedTab = 0);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedTab == 0
                                  ? AppColors.leafGreen.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: _selectedTab == 0
                                  ? Border.all(
                                      color: AppColors.leafGreen.withOpacity(0.3),
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: AppColors.leafGreen,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.leafGreen,
                                        ),
                                      ),
                                      Text(
                                        completedCount.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.leafGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cancelled Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedTab = 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedTab == 1
                                  ? AppColors.accentYellow.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: _selectedTab == 1
                                  ? Border.all(
                                      color: AppColors.accentYellow.withOpacity(0.3),
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel_rounded,
                                  size: 16,
                                  color: AppColors.accentYellow,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cancelled',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.accentYellow,
                                        ),
                                      ),
                                      Text(
                                        cancelledCount.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.accentYellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab Content
                if (_selectedTab == 0)
                  _buildTabContent(
                    requests: widget.completedRequests,
                    emptyMessage: 'No completed pickups yet',
                    statusColor: AppColors.leafGreen,
                  )
                else
                  _buildTabContent(
                    requests: widget.cancelledRequests,
                    emptyMessage: 'No cancelled pickups',
                    statusColor: AppColors.accentYellow,
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({
    required List<PickupRequest> requests,
    required String emptyMessage,
    required Color statusColor,
  }) {
    if (requests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Divider(
          height: 1,
          color: AppColors.leafGreen.withOpacity(0.1),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          separatorBuilder: (_, __) => Divider(
            height: 8,
            thickness: 0,
            color: Colors.transparent,
          ),
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: _buildHistoryPickupCard(request, statusColor),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryPickupCard(PickupRequest request, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: statusColor.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(request.userProfileImage),
            backgroundColor: statusColor.withOpacity(0.1),
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.line_weight_rounded,
                      size: 10,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${request.quantity.toStringAsFixed(1)}kg',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on_rounded,
                      size: 10,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${request.distanceKm.toStringAsFixed(1)}km',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Amount & Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '₹${request.estimatedAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
