import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/eco_components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back! 🌍',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Keep Making a Difference',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestGreen,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.forestGreen,
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('See you soon! Keep protecting nature 🌱'),
                    backgroundColor: AppColors.forestGreen,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('My Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            icon: const Icon(Icons.person_outline),
            iconColor: AppColors.forestGreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌱 GREEN POINTS CARD - Celebratory impact showcase
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.forestGreen,
                      AppColors.leafGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forestGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Green Points',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '3,400 🌿',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Keep it growing!',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🌍 IMPACT SUMMARY - Show environmental achievements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EcoSectionHeader(
                title: 'Your Impact',
                subtitle: 'This month',
                icon: Icons.trending_up,
                iconColor: AppColors.leafGreen,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ImpactCard(
                    label: 'WASTE COLLECTED',
                    value: '45.5 kg',
                    icon: Icons.delete_outline,
                    accentColor: AppColors.forestGreen,
                    subtitle: '12 items recycled',
                  ),
                  const SizedBox(height: 12),
                  ImpactCard(
                    label: 'TREES SAVED',
                    value: '3.2',
                    icon: Icons.park,
                    accentColor: AppColors.treeGreen,
                    subtitle: 'Equivalent to 34 trees',
                  ),
                  const SizedBox(height: 12),
                  ImpactCard(
                    label: 'CO₂ REDUCED',
                    value: '12.8 kg',
                    icon: Icons.cloud_off,
                    accentColor: AppColors.oceanBlue,
                    subtitle: 'Carbon footprint decreased',
                  ),
                ],
              ),
            ),

            // 🌿 QUICK ACTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EcoSectionHeader(
                title: 'Quick Actions',
                icon: Icons.bolt,
                iconColor: AppColors.accentYellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: EcoActionButton(
                      label: 'Scan Waste',
                      icon: Icons.qr_code_2,
                      onPressed: () {
                        // TODO: Navigate to scanner
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: EcoActionButton(
                      label: 'Schedule Pickup',
                      icon: Icons.local_shipping,
                      backgroundColor: AppColors.leafGreen,
                      onPressed: () {
                        // TODO: Schedule pickup
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 💚 FEATURED PRODUCTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EcoSectionHeader(
                title: 'Redeem Your Points',
                subtitle: 'Eco-friendly rewards',
                icon: Icons.card_giftcard,
                iconColor: AppColors.accentYellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final products = [
                      ('Bamboo Bottle', '500 Points', Icons.local_drink),
                      ('Plant a Tree', '1200 Points', Icons.park),
                      ('Organic Soap Pack', '2500 Points', Icons.soap),
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _ProductCard(
                        title: products[index].$1,
                        price: products[index].$2,
                        icon: products[index].$3,
                        onTap: () {
                          // TODO: Navigate to product details
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // 📰 ECO NEWS & STORIES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EcoSectionHeader(
                title: 'Eco News',
                subtitle: 'Learn & Be Inspired',
                icon: Icons.lightbulb,
                iconColor: AppColors.accentYellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NewsCard(
                      title: index == 0
                          ? '🌍 How Your Recycling Saves Oceans'
                          : '🌱 5 Easy Ways to Reduce Plastic',
                      subtitle: index == 0 ? '2 hours ago' : '5 hours ago',
                      onTap: () {
                        // TODO: Navigate to news detail
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final IconData icon;
  final VoidCallback onTap;

  const _ProductCard({
    required this.title,
    required this.price,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: EcoCard(
        backgroundColor: AppColors.leafGreen.withOpacity(0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.leafGreen.withOpacity(0.1),
                      AppColors.accentYellow.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.forestGreen,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.leafGreen,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NewsCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: EcoCard(
        backgroundColor: AppColors.accentYellow.withOpacity(0.06),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.forestGreen.withOpacity(0.15),
                    AppColors.leafGreen.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.eco,
                color: AppColors.forestGreen,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
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
    );
  }
}
