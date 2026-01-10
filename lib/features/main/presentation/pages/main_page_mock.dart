import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/managers/pickups_manager.dart';
import '../../../../core/models/pickup_model.dart';
import '../../../../core/utils/otp_generator.dart';

class MainPageMock extends StatefulWidget {
  const MainPageMock({Key? key}) : super(key: key);

  @override
  State<MainPageMock> createState() => _MainPageMockState();
}

class _MainPageMockState extends State<MainPageMock> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  final _imagePicker = ImagePicker();
  late PickupsManager _pickupsManager;

  @override
  void initState() {
    super.initState();
    _pickupsManager = PickupsManager();
  }

  @override
  void dispose() {
    _pickupsManager.dispose();
    super.dispose();
  }

  /// Switch to a specific tab (safe method for use from dialogs/child widgets)
  void switchToTab(int tabIndex) {
    if (mounted) {
      setState(() => _currentIndex = tabIndex);
    }
  }

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
        return HomeScreenMock(
          selectedCategory: _selectedCategory,
          onCategoryChange: (category) {
            setState(() => _selectedCategory = category);
          },
        );
      case 1:
        return EchoScreenMock(
          pickupsManager: _pickupsManager,
        );
      case 2:
        return ScannerScreenMock(
          imagePicker: _imagePicker,
        );
      case 3:
        return const RankScreenMock();
      case 4:
        return ProfileScreenMock(
          onLogout: () {
            Navigator.pushReplacementNamed(context, '/auth/phone');
          },
        );
      default:
        return HomeScreenMock(
          selectedCategory: _selectedCategory,
          onCategoryChange: (category) {
            setState(() => _selectedCategory = category);
          },
        );
    }
  }

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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Echo'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Rank'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// HOME SCREEN
class HomeScreenMock extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChange;

  const HomeScreenMock({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChange,
  }) : super(key: key);

  @override
  State<HomeScreenMock> createState() => _HomeScreenMockState();
}

class _HomeScreenMockState extends State<HomeScreenMock> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final user = MockData.mockUser;
    final filteredItems = _selectedCategory == 'All'
        ? MockData.wasteItems
        : MockData.wasteItems
            .where((item) => item['category'] == _selectedCategory)
            .toList();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with Profile Image and User Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user['profileImage'] ?? ''),
                  backgroundColor: Colors.grey[300],
                  child: user['profileImage'] == null
                      ? Icon(Icons.person, color: Colors.grey[600], size: 40)
                      : null,
                ),
                const SizedBox(width: 16),
                // User Name and Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? 'User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Member since ${user['memberSince'] ?? 'Recently'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rating and Saved Carbon Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Rating Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rating',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            const SizedBox(width: 6),
                            Text(
                              '${user['rating'] ?? 4.8}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    height: 60,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  // Saved Carbon Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Carbon',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.eco_rounded, color: Colors.green, size: 24),
                            const SizedBox(width: 6),
                            Text(
                              '${(user['itemsSold'] * 8).toStringAsFixed(0)} kg',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All'),
                      _buildCategoryChip('Plastic'),
                      _buildCategoryChip('Glass'),
                      _buildCategoryChip('Paper'),
                      _buildCategoryChip('E-Waste'),
                      _buildCategoryChip('Metal'),
                      _buildCategoryChip('Textile'),
                      _buildCategoryChip('Organic'),
                      _buildCategoryChip('Wood'),
                      _buildCategoryChip('Rubber'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Waste Items List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Items',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/waste-item-detail',
                          arguments: item,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'] ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey[400]),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? 'Item',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['category'] ?? 'Category',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${item['price']} per kg',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.teal[400],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? Colors.teal[400]! : Colors.grey[300]!,
        ),
      ),
    );
  }
}

// ECHO SCREEN
class EchoScreenMock extends StatefulWidget {
  final PickupsManager? pickupsManager;

  const EchoScreenMock({
    Key? key,
    this.pickupsManager,
  }) : super(key: key);

  @override
  State<EchoScreenMock> createState() => _EchoScreenMockState();
}

class _EchoScreenMockState extends State<EchoScreenMock> {
  bool _isLoading = false;
  late Map<String, bool> _expandedSections;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _expandedSections = {
      'summary': true,
      'pickups': true,
      'history': true,
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !(_expandedSections[section] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Echo Summary')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => _isLoading = false);
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Summary Section Header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverHeaderDelegate(
                      minHeight: 56,
                      maxHeight: 56,
                      child: Container(
                        color: AppColors.background,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _toggleSection('summary'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Summary Statistics',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  AnimatedRotation(
                                    turns: (_expandedSections['summary'] ?? true) ? 0 : 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(Icons.expand_more, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Summary Content (Expandable)
                  if (_expandedSections['summary'] ?? true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            _buildSummaryCard('Total Waste Sold', '${MockData.echoSummary['totalWasteSold']}', 'items'),
                            _buildSummaryCard('Total Earnings', '₹${MockData.echoSummary['totalEarnings']}', ''),
                            _buildSummaryCard('Pending Pickups', '${widget.pickupsManager?.upcomingPickups.length ?? 0}', 'pending'),
                          ],
                        ),
                      ),
                    ),

                  // Upcoming Pickups Header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverHeaderDelegate(
                      minHeight: 56,
                      maxHeight: 56,
                      child: Container(
                        color: AppColors.background,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _toggleSection('pickups'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Upcoming Pickups',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  AnimatedRotation(
                                    turns: (_expandedSections['pickups'] ?? true) ? 0 : 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(Icons.expand_more, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pickups Content (Expandable)
                  if (_expandedSections['pickups'] ?? true)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Use mock data since pickupsManager is still empty/not populated
                            final pickupsList = MockData.pickups;
                            
                            if (pickupsList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No upcoming pickups',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildPickupCard(pickupsList[index]),
                            );
                          },
                          childCount: MockData.pickups.length,
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Tap to expand',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    ),

                  // History Section Header (ALWAYS VISIBLE)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverHeaderDelegate(
                      minHeight: 56,
                      maxHeight: 56,
                      child: Container(
                        color: AppColors.background,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _toggleSection('history'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'History',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  AnimatedRotation(
                                    turns: (_expandedSections['history'] ?? true) ? 0 : 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(Icons.expand_more, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // History Content (Expandable)
                  if (_expandedSections['history'] ?? true)
                    SliverToBoxAdapter(
                      child: _buildHistoryContent(),
                    ),

                  // Bottom spacing
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String unit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(unit, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupCard(Map<String, dynamic> pickup) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collector Info Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickup['collectorName'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${pickup['scheduledDate']} at ${pickup['scheduledTime']}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${pickup['amount']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // OTP Section - ABOVE PRICE
            if (pickup['otp'] != null && (pickup['otp'] as String).isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(color: Colors.amber[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup OTP',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pickup['otp'] as String,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.content_copy, color: Colors.amber[800]),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: pickup['otp'] as String));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('OTP copied to clipboard'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.grey[800],
                          ),
                        );
                      },
                      tooltip: 'Copy OTP',
                    ),
                  ],
                ),
              ),
            
            // Driver Details Row
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Driver Phone',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    pickup['collectorPhone'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Truck Number',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    pickup['truckNumber'] ?? 'N/A',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Waste Items Preview
            if (pickup['wasteItems'] != null && (pickup['wasteItems'] as List).isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waste Items',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (pickup['wasteItems'] as List).length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Build pickup card for PickupModel (with OTP support)
  Widget _buildHistoryContent() {
    // Check if there are any completed pickups (mock data for demonstration)
    final hasHistory = MockData.pickups.isEmpty; // If empty, show empty state

    if (hasHistory) {
      // Empty state UI - ALWAYS shown when no history exists
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No history yet',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your completed pickups will appear here',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // History list (when data is available)
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          children: [
            // In future, replace with actual history items
            // For now, show message that history will be populated
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[600], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'History items will be listed here',
                      style: TextStyle(fontSize: 13, color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

// SCANNER SCREEN - Complete 5-Step Flow
class ScannerScreenMock extends StatefulWidget {
  final ImagePicker imagePicker;

  const ScannerScreenMock({
    Key? key,
    required this.imagePicker,
  }) : super(key: key);

  @override
  State<ScannerScreenMock> createState() => _ScannerScreenMockState();
}

class _ScannerScreenMockState extends State<ScannerScreenMock> {
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    // If no image selected, show photo picker
    if (_selectedImage == null) {
      return _buildPhotoPicker();
    }

    // Image selected, show preview and confirmation
    return _buildPhotoPreview(context);
  }

  Widget _buildPhotoPicker() {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Waste')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Capture Waste Photo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Take a clear photo of the waste you want to sell',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Choose from Gallery'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Photo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedImage = null),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        _selectedImage!.path,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_selectedImage!.path),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Does this photo look good?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToCategorySelection(context),
                  child: const Text('Yes, Use This Photo'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() => _selectedImage = null),
                  child: const Text('Take Another Photo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final file = await widget.imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (file != null) {
        setState(() => _selectedImage = file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _navigateToCategorySelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WasteCategorySelectionScreen(
          imagePath: _selectedImage!.path,
        ),
      ),
    );
  }
}

// STEP 2: Category Selection Screen
class WasteCategorySelectionScreen extends StatefulWidget {
  final String imagePath;

  const WasteCategorySelectionScreen({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<WasteCategorySelectionScreen> createState() => _WasteCategorySelectionScreenState();
}

class _WasteCategorySelectionScreenState extends State<WasteCategorySelectionScreen> {
  String? _selectedCategory;

  static const _categories = [
    ('Plastic', Icons.shopping_bag, '#6EC6C2'),
    ('Paper', Icons.newspaper, '#7CBF9E'),
    ('Metal', Icons.build, '#5B9AA0'),
    ('Glass', Icons.liquor, '#4A90A4'),
    ('E-Waste', Icons.devices_other, '#3D7CA3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Waste Category')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What type of waste are you selling?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final (name, icon, color) = _categories[index];
                  final isSelected = _selectedCategory == name;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = name),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(int.parse('0xFF${color.replaceFirst('#', '')}')).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: Color(int.parse('0xFF${color.replaceFirst('#', '')}')),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Select to continue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedCategory != null
                    ? () => _navigateToTypeSelection(context)
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTypeSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WasteTypeSelectionScreen(
          category: _selectedCategory!,
          imagePath: widget.imagePath,
        ),
      ),
    );
  }
}

// STEP 3: Type Selection & Invoice Screen
class WasteTypeSelectionScreen extends StatefulWidget {
  final String category;
  final String imagePath;

  const WasteTypeSelectionScreen({
    Key? key,
    required this.category,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<WasteTypeSelectionScreen> createState() => _WasteTypeSelectionScreenState();
}

class _WasteTypeSelectionScreenState extends State<WasteTypeSelectionScreen> {
  late String? _selectedType;

  // Mock data: category -> types with pricing
  static const _categoryTypes = {
    'Plastic': [
      ('PET Bottles', 2.50),
      ('Hard Plastic', 2.00),
      ('Plastic Bags', 1.00),
    ],
    'Paper': [
      ('Newspaper', 0.50),
      ('Cardboard', 1.20),
      ('Mixed Paper', 0.75),
    ],
    'Metal': [
      ('Aluminum Cans', 5.00),
      ('Scrap Iron', 3.50),
      ('Copper Wire', 15.00),
    ],
    'Glass': [
      ('Glass Bottles', 5.00),
      ('Jars', 4.50),
      ('Broken Glass', 3.00),
    ],
    'E-Waste': [
      ('Mobile Phones', 50.00),
      ('Copper Wire', 15.00),
      ('Circuit Boards', 25.00),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedType = null;
  }

  List<(String, double)> get _types => _categoryTypes[widget.category] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Waste Type')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What type of ${widget.category.toLowerCase()} are you selling?',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _types.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final (name, price) = _types[index];
                  final isSelected = _selectedType == name;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = name),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${price.toStringAsFixed(2)} per unit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedType != null
                    ? () => _navigateToInvoice(context)
                    : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToInvoice(BuildContext context) {
    final selectedTypeData = _types.firstWhere(
      (item) => item.$1 == _selectedType,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WasteReviewScreen(
          category: widget.category,
          type: _selectedType!,
          pricePerKg: selectedTypeData.$2,
          imagePath: widget.imagePath,
        ),
      ),
    );
  }
}

// STEP 4-5: KG Selection + Estimated Invoice (Combined Review Screen)
class WasteReviewScreen extends StatefulWidget {
  final String category;
  final String type;
  final double pricePerKg;
  final String imagePath;

  const WasteReviewScreen({
    Key? key,
    required this.category,
    required this.type,
    required this.pricePerKg,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<WasteReviewScreen> createState() => _WasteReviewScreenState();
}

class _WasteReviewScreenState extends State<WasteReviewScreen> {
  double _selectedKg = 3.0; // Default minimum 3 KG

  double get _estimatedTotal => _selectedKg * widget.pricePerKg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Waste')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        widget.imagePath,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.imagePath),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 32),

              // Category & Type Info
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Category', widget.category),
                    const SizedBox(height: 12),
                    _buildInfoRow('Type', widget.type),
                    const SizedBox(height: 12),
                    _buildInfoRow('Price per KG', '₹${widget.pricePerKg.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KG Selection Section
              const Text(
                'Select Quantity (kg)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Quantity Display
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Minus Button
                    GestureDetector(
                      onTap: _selectedKg > 3.0
                          ? () => setState(() => _selectedKg = (_selectedKg - 0.5).clamp(3.0, 500.0))
                          : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedKg > 3.0 ? AppColors.primary : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: _selectedKg > 3.0 ? Colors.white : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Quantity Display
                    Column(
                      children: [
                        Text(
                          '${_selectedKg.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Max: 500 KG',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),

                    // Plus Button
                    GestureDetector(
                      onTap: _selectedKg < 500.0
                          ? () => setState(() => _selectedKg = (_selectedKg + 0.5).clamp(3.0, 500.0))
                          : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedKg < 500.0 ? AppColors.primary : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: _selectedKg < 500.0 ? Colors.white : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Slider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Slider(
                  value: _selectedKg,
                  min: 3.0,
                  max: 500.0,
                  divisions: 994, // 500 - 3 = 497, * 2 for 0.5 steps = 994
                  label: '${_selectedKg.toStringAsFixed(1)} kg',
                  onChanged: (value) => setState(() => _selectedKg = (value * 2).roundToDouble() / 2),
                ),
              ),
              const SizedBox(height: 24),

              // Estimated Invoice Card
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Invoice',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Breakdown
                    _buildInvoiceRow('Selected KG', '${_selectedKg.toStringAsFixed(1)} kg'),
                    const SizedBox(height: 8),
                    _buildInvoiceRow(
                      'Price per KG',
                      '₹${widget.pricePerKg.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 8),

                    // Total Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${_estimatedTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Warning Label
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.amber[600], size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: const Text(
                              'Estimated Price - Final price may vary after pickup',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Sell Waste Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _selectedKg >= 3.0 ? () => _showSuccessPopup(context) : null,
                  child: const Text('Sell Waste'),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WasteSubmissionSuccessDialog(
        totalPrice: _estimatedTotal,
        category: widget.category,
        type: widget.type,
        kg: _selectedKg,
        onDismiss: () {
          // Step 1: Close the dialog
          Navigator.of(dialogContext).pop();
          
          // Step 2: Generate OTP (4-6 digit numeric)
          final otp = OtpGenerator.generate4DigitOtp();
          
          // Step 3: Create new pickup with OTP
          final newPickup = PickupModel(
            id: 'PKP-${DateTime.now().millisecondsSinceEpoch}',
            wasteSummary: '${widget.category}, ${widget.type}',
            estimatedAmount: _estimatedTotal,
            pickupDate: 'Today',
            pickupTime: 'Scheduled Soon',
            status: PickupStatus.upcoming,
            pickupOtp: otp,
            otpGeneratedAt: DateTime.now(),
            totalKg: _selectedKg,
            category: widget.category,
            type: widget.type,
          );
          
          // Step 4: Add pickup to state
          final mainPageState = context.findAncestorStateOfType<_MainPageMockState>();
          if (mainPageState != null) {
            mainPageState._pickupsManager.addPickup(newPickup);
          }
          
          // Step 5: Navigate to Pending Pickups page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PendingPickupsPage(
                pickupsManager: mainPageState?._pickupsManager,
              ),
            ),
          );
        },
      ),
    );
  }
}

// STEP 4: Estimated Invoice Screen
// STEP 6: Success Popup
class WasteSubmissionSuccessDialog extends StatefulWidget {
  final double totalPrice;
  final String category;
  final String type;
  final double kg;
  final VoidCallback onDismiss;

  const WasteSubmissionSuccessDialog({
    Key? key,
    required this.totalPrice,
    required this.category,
    required this.type,
    required this.kg,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<WasteSubmissionSuccessDialog> createState() => _WasteSubmissionSuccessDialogState();
}

class _WasteSubmissionSuccessDialogState extends State<WasteSubmissionSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isNavigating = false; // Prevent double-tap navigation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    // Prevent multiple navigation triggers from double-tap
    if (_isNavigating) return;
    _isNavigating = true;
    
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Waste Submitted\nSuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pickup will be scheduled soon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Submission Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Category', widget.category),
                    const SizedBox(height: 8),
                    _buildDetailRow('Type', widget.type),
                    const SizedBox(height: 8),
                    _buildDetailRow('Quantity', '${widget.kg.toStringAsFixed(1)} kg'),
                    const SizedBox(height: 8),
                    Container(
                      height: 1,
                      color: Colors.grey[300],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    const SizedBox(height: 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${widget.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Status Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.green[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Status: Pending Pickup',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleDismiss,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}

// RANK SCREEN - Complete Leaderboard with Auto-Scrolling Top 10
class RankScreenMock extends StatefulWidget {
  const RankScreenMock({Key? key}) : super(key: key);

  @override
  State<RankScreenMock> createState() => _RankScreenMockState();
}

class _RankScreenMockState extends State<RankScreenMock> {
  late PageController _bannerController;
  late Timer _autoScrollTimer;
  int _currentBannerPage = 0;
  bool _isAutoScrolling = true;

  // Mock Top 10 Winners
  static const List<Map<String, dynamic>> _top10Winners = [
    {
      'rank': 1,
      'name': 'Rajesh Kumar',
      'points': 8950,
      'wasteSold': 450,
      'prize': '₹5000 Gift Card',
      'email': 'rajesh@example.com',
    },
    {
      'rank': 2,
      'name': 'Priya Sharma',
      'points': 8420,
      'wasteSold': 420,
      'prize': 'Smartwatch',
      'email': 'priya@example.com',
    },
    {
      'rank': 3,
      'name': 'Amit Patel',
      'points': 7890,
      'wasteSold': 395,
      'prize': '₹3000 Gift Card',
      'email': 'amit@example.com',
    },
    {
      'rank': 4,
      'name': 'Sneha Desai',
      'points': 7340,
      'wasteSold': 368,
      'prize': 'Wireless Speaker',
      'email': 'sneha@example.com',
    },
    {
      'rank': 5,
      'name': 'Vikram Singh',
      'points': 6890,
      'wasteSold': 345,
      'prize': '₹2000 Gift Card',
      'email': 'vikram@example.com',
    },
    {
      'rank': 6,
      'name': 'Ananya Gupta',
      'points': 6450,
      'wasteSold': 323,
      'prize': 'Phone Stand Bundle',
      'email': 'ananya@example.com',
    },
    {
      'rank': 7,
      'name': 'Rohan Verma',
      'points': 5980,
      'wasteSold': 299,
      'prize': '₹1500 Gift Card',
      'email': 'rohan@example.com',
    },
    {
      'rank': 8,
      'name': 'Divya Iyer',
      'points': 5620,
      'wasteSold': 281,
      'prize': 'Eco-friendly Kit',
      'email': 'divya@example.com',
    },
    {
      'rank': 9,
      'name': 'Arjun Reddy',
      'points': 5340,
      'wasteSold': 267,
      'prize': 'Water Bottle Set',
      'email': 'arjun@example.com',
    },
    {
      'rank': 10,
      'name': 'Zara Khan',
      'points': 5020,
      'wasteSold': 251,
      'prize': '₹1000 Gift Card',
      'email': 'zara@example.com',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isAutoScrolling && mounted) {
        _currentBannerPage = (_currentBannerPage + 1) % _top10Winners.length;
        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = MockData.mockUser;
    final currentRank = 27; // Mock rank for current user
    final currentPoints = 4250;
    final currentWasteSold = 212;

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Your Current Rank Card (Sticky)
          Container(
            color: AppColors.primary.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRankDetailsScreen(
                      rank: currentRank,
                      points: currentPoints,
                      wasteSold: currentWasteSold,
                      userName: currentUser['name'] ?? 'User',
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Current Rank',
                            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#$currentRank',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$currentPoints points',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.scale, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            '$currentWasteSold kg waste sold',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          label: const Text('View My History'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyRankDetailsScreen(
                                  rank: currentRank,
                                  points: currentPoints,
                                  wasteSold: currentWasteSold,
                                  userName: currentUser['name'] ?? 'User',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top 10 Prize Banner (Auto-Scrolling)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎁 Reach TOP 10 & Win Exciting Prizes!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _isAutoScrolling = false),
                    onTapUp: (_) => setState(() => _isAutoScrolling = true),
                    child: PageView.builder(
                      controller: _bannerController,
                      onPageChanged: (index) {
                        setState(() => _currentBannerPage = index);
                      },
                      itemCount: _top10Winners.length,
                      itemBuilder: (context, index) {
                        final winner = _top10Winners[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Rank #${winner['rank']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  winner['prize'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _top10Winners.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBannerPage == index
                            ? AppColors.primary
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Top 10 Winners List (Horizontal Scrolling)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top 10 Winners',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _top10Winners.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final winner = _top10Winners[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WinnerDetailScreen(winner: winner),
                            ),
                          );
                        },
                        child: _buildWinnerCard(winner),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // How to Reach Top 10 Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to reach TOP 10?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    '📦',
                    'Sell maximum waste consistently',
                    'The more you sell, the more points you earn.',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    '📸',
                    'Maintain high-quality uploads',
                    'Clear photos help us process waste faster.',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    '♻️',
                    'Reduce plastic & e-waste',
                    'Earn bonus points for eco-friendly waste.',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    '✅',
                    'Complete all scheduled pickups',
                    'Reliability increases your ranking.',
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    '⭐',
                    'Earn bonus points from campaigns',
                    'Participate in seasonal drives for extra points.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWinnerCard(Map<String, dynamic> winner) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankBadgeColor(winner['rank'] as int),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${winner['rank']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 32, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          // Name
          Text(
            (winner['name'] as String).split(' ')[0],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Points
          Text(
            '${winner['points']} pts',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          // Prize
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                (winner['prize'] as String).split(' ')[0],
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getRankBadgeColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }
}

// My Rank Details Screen
class MyRankDetailsScreen extends StatelessWidget {
  final int rank;
  final int points;
  final int wasteSold;
  final String userName;

  const MyRankDetailsScreen({
    Key? key,
    required this.rank,
    required this.points,
    required this.wasteSold,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Rank Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Rank #$rank',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Points', '$points', Icons.star),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Waste Sold', '${wasteSold}kg', Icons.scale),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Prize History
          const Text(
            'Prize History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPrizeItem('Monthly Champion - January 2026', '₹2000 Gift Card', 'Completed'),
          const SizedBox(height: 8),
          _buildPrizeItem('Weekly Top 5 - Week 2', 'Eco Kit', 'Completed'),
          const SizedBox(height: 24),

          // Tips to Reach Top 10
          const Text(
            'Tips to Reach TOP 10',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '⭐ You need 5,020 more points to reach TOP 10. Keep selling waste consistently to reach your goal!',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeItem(String title, String prize, String status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  prize,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Winner Detail Screen
class WinnerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> winner;

  const WinnerDetailScreen({Key? key, required this.winner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Winner Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Winner Profile
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Rank Badge
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getRankColor(winner['rank'] as int),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#${winner['rank']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    winner['name'] as String,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    winner['email'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Prize Details
          const Text(
            'Prize Won',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  winner['prize'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${winner['points']} points earned | ${winner['wasteSold']} kg sold',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Photo Gallery
          const Text(
            'Verified Photos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 32, color: Colors.grey[600]),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildDetailStat('Points', '${winner['points']}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailStat('Waste Sold', '${winner['wasteSold']} kg'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }
}

// PROFILE SCREEN
class ProfileScreenMock extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreenMock({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Text(MockData.mockUser['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(MockData.mockUser['phoneNumber'], style: const TextStyle(color: AppColors.textSecondary)),
                Text('Joined ${MockData.mockUser['joinedDate']}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats
          _buildStatRow('Total Points', '${MockData.mockUser['totalPoints']}'),
          _buildStatRow('Total Earnings', '₹${MockData.mockUser['totalEarnings']}'),
          _buildStatRow('Items Sold', '${MockData.mockUser['itemsSold']}'),

          const SizedBox(height: 32),

          // Logout Button
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}

/// Fixed SliverPersistentHeaderDelegate with proper geometry handling
/// - FIXED height (minExtent <= maxExtent always valid)
/// - NEVER depends on animated height
/// - Resolves: SliverGeometry is not valid: layoutExtent exceeds paintExtent
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  }) : assert(
    minHeight <= maxHeight,
    'minHeight must be <= maxHeight. Got minHeight: $minHeight, maxHeight: $maxHeight',
  );

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

// PENDING PICKUPS PAGE - Show all pending pickups after waste submission
class PendingPickupsPage extends StatelessWidget {
  final PickupsManager? pickupsManager;

  const PendingPickupsPage({
    Key? key,
    this.pickupsManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get upcoming pickups from manager or show empty
    final upcomingPickups = pickupsManager?.upcomingPickups ?? [];
    final totalKg = upcomingPickups.fold<double>(
      0,
      (sum, pickup) => sum + pickup.totalKg,
    );
    final totalAmount = upcomingPickups.fold<double>(
      0,
      (sum, pickup) => sum + pickup.estimatedAmount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Pickups'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to Scanner tab first screen
            Navigator.of(context).pop();
            
            // Access MainPageMock and set to Scanner tab
            final mainPageState = context.findAncestorStateOfType<_MainPageMockState>();
            if (mainPageState != null) {
              mainPageState.switchToTab(2); // Scanner tab (index 2)
            }
          },
        ),
      ),
      body: upcomingPickups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No Pending Pickups',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Submit Waste'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      final mainPageState = context.findAncestorStateOfType<_MainPageMockState>();
                      if (mainPageState != null) {
                        mainPageState.switchToTab(2); // Scanner tab
                      }
                    },
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Total Summary Card
                Card(
                  color: AppColors.primary.withOpacity(0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pending Pickups',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${upcomingPickups.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.scale, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              '${totalKg.toStringAsFixed(1)} kg Total Waste Scheduled',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.currency_rupee, size: 20, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              '₹${totalAmount.toStringAsFixed(2)} Expected Earnings',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pending Pickups List
                const Text(
                  'Scheduled Pickups',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingPickups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final pickup = upcomingPickups[index];
                    return _buildPickupCard(pickup, ctx);
                  },
                ),
                const SizedBox(height: 24),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Go to Scanner'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      final mainPageState = context.findAncestorStateOfType<_MainPageMockState>();
                      if (mainPageState != null) {
                        mainPageState.switchToTab(2); // Scanner tab
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildPickupCard(PickupModel pickup, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pickup.id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pickup.status.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category and Quantity
          Row(
            children: [
              Icon(Icons.shopping_bag, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '${pickup.category} • ${pickup.totalKg.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date and Time
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${pickup.pickupDate}, ${pickup.pickupTime}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Amount
          Row(
            children: [
              Icon(Icons.currency_rupee, size: 18, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                '₹${pickup.estimatedAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          // OTP Section (Only for upcoming pickups)
          if (pickup.status.isUpcoming && pickup.pickupOtp != null) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pickup OTP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.amber[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          pickup.pickupOtp!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontFamily: 'monospace',
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          // Show snackbar when OTP is copied
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('OTP copied: ${pickup.pickupOtp}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

