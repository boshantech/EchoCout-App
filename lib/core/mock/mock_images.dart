/// Mock images and image URLs for UI components
class MockImages {
  // User Profile Images
  static const String userProfileImage =
      'https://i.pravatar.cc/150?img=1'; // Raj Kumar
  static const String userBackgroundImage =
      'https://via.placeholder.com/1280x720?text=User+Background';

  // Waste Item Images
  static final Map<String, String> wasteItemImages = {
    'w1': 'https://via.placeholder.com/250?text=Plastic+Bottle',
    'w2': 'https://via.placeholder.com/250?text=Glass+Bottle',
    'w3': 'https://via.placeholder.com/250?text=Aluminum+Can',
    'w4': 'https://via.placeholder.com/250?text=Copper+Wire',
    'w5': 'https://via.placeholder.com/250?text=Newspapers',
    'w6': 'https://via.placeholder.com/250?text=Cardboard',
    'w7': 'https://via.placeholder.com/250?text=Old+Phone',
    'w8': 'https://via.placeholder.com/250?text=Plastic+Bags',
  };

  // Category Icons (using emoji-like descriptions for fallback)
  static final Map<String, String> categoryImages = {
    'All': 'https://via.placeholder.com/100?text=All',
    'Plastic': 'https://via.placeholder.com/100?text=Plastic',
    'Glass': 'https://via.placeholder.com/100?text=Glass',
    'Electronics': 'https://via.placeholder.com/100?text=Electronics',
    'Metal': 'https://via.placeholder.com/100?text=Metal',
    'Paper': 'https://via.placeholder.com/100?text=Paper',
    'Organic': 'https://via.placeholder.com/100?text=Organic',
  };

  // Leaderboard User Images
  static final Map<String, String> leaderboardUserImages = {
    'rank_1': 'https://i.pravatar.cc/150?img=5', // Alex Johnson
    'rank_2': 'https://i.pravatar.cc/150?img=10', // Maria Garcia
    'rank_3': 'https://i.pravatar.cc/150?img=15', // James Wilson
    'rank_4': 'https://i.pravatar.cc/150?img=1', // Raj Kumar (current user)
    'rank_5': 'https://i.pravatar.cc/150?img=20', // Sarah Lee
    'rank_6': 'https://i.pravatar.cc/150?img=25', // Mohammed Khan
    'rank_7': 'https://i.pravatar.cc/150?img=30', // Anna Martinez
    'rank_8': 'https://i.pravatar.cc/150?img=35', // David Chen
    'rank_9': 'https://i.pravatar.cc/150?img=40', // Emily Brown
    'rank_10': 'https://i.pravatar.cc/150?img=45', // Thomas Anderson
  };

  // Collector/Pickup Person Images
  static final Map<String, String> collectorImages = {
    'collector_1': 'https://i.pravatar.cc/150?img=50', // John Collector
    'collector_2': 'https://i.pravatar.cc/150?img=55', // Sarah Williams
    'collector_3': 'https://i.pravatar.cc/150?img=60', // Mike Johnson
  };

  // App Logo & Branding
  static const String appLogo =
      'https://via.placeholder.com/200x200?text=EchoCout+Logo';
  static const String splashBg =
      'https://via.placeholder.com/1080x1920?text=Splash+Background';

  // Onboarding Images
  static final Map<int, String> onboardingImages = {
    0: 'https://via.placeholder.com/400x400?text=Recycle+Rewards',
    1: 'https://via.placeholder.com/400x400?text=AI+Sorting',
    2: 'https://via.placeholder.com/400x400?text=Easy+Pickup',
  };

  // Empty States
  static const String emptyPickupsImage =
      'https://via.placeholder.com/300x300?text=No+Pickups';
  static const String emptyListImage =
      'https://via.placeholder.com/300x300?text=No+Items';

  // Scanner/Detection Related
  static const String cameraPlaceholder =
      'https://via.placeholder.com/400x400?text=Tap+to+Scan';
  static const String detectionSuccessImage =
      'https://via.placeholder.com/400x400?text=Detection+Success';

  // Achievement/Badge Images
  static final Map<String, String> badgeImages = {
    'gold_medal': 'https://via.placeholder.com/100x100?text=Gold+Medal',
    'silver_medal': 'https://via.placeholder.com/100x100?text=Silver+Medal',
    'bronze_medal': 'https://via.placeholder.com/100x100?text=Bronze+Medal',
    'eco_warrior': 'https://via.placeholder.com/100x100?text=Eco+Warrior',
    'top_seller': 'https://via.placeholder.com/100x100?text=Top+Seller',
  };

  // Background & Decoration
  static const String gradientBg1 =
      'https://via.placeholder.com/1080x1920?text=Gradient+BG+1';
  static const String gradientBg2 =
      'https://via.placeholder.com/1080x1920?text=Gradient+BG+2';
  static const String patternBg =
      'https://via.placeholder.com/1080x1920?text=Pattern+BG';

  /// Get image for waste item by ID
  static String getWasteItemImage(String wasteId) {
    return wasteItemImages[wasteId] ??
        'https://via.placeholder.com/250?text=Waste+Item';
  }

  /// Get image for category
  static String getCategoryImage(String category) {
    return categoryImages[category] ??
        'https://via.placeholder.com/100?text=Category';
  }

  /// Get image for leaderboard user by rank
  static String getLeaderboardUserImage(int rank) {
    final key = 'rank_$rank';
    return leaderboardUserImages[key] ?? 'https://i.pravatar.cc/150?img=99';
  }

  /// Get image for collector by ID
  static String getCollectorImage(String collectorId) {
    return collectorImages[collectorId] ??
        'https://i.pravatar.cc/150?img=99';
  }

  /// Get onboarding image by page index
  static String getOnboardingImage(int pageIndex) {
    return onboardingImages[pageIndex] ??
        'https://via.placeholder.com/400x400?text=Onboarding';
  }

  /// Get badge image by badge type
  static String getBadgeImage(String badgeType) {
    return badgeImages[badgeType] ??
        'https://via.placeholder.com/100x100?text=Badge';
  }
}
