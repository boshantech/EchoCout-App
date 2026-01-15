/// 🌍 ECO-FRIENDLY MESSAGING CONSTANTS
/// Friendly, positive, nature-inspired copy for the app
library;

abstract class EcoStrings {
  // 🌿 GREETINGS & WELCOME
  static const String welcomeBack = 'Welcome back! 🌍';
  static const String keepMakingDifference = 'Keep Making a Difference';
  static const String welcomeHero = 'Welcome to EchoCout';
  static const String joinMovement = 'Join the waste revolution';

  // 💚 POINTS & REWARDS
  static const String greenPoints = 'Green Points';
  static const String keepItGrowing = 'Keep it growing!';
  static const String pointsPlural = 'Green Points 🌿';
  static const String pointsSingular = 'Green Point 🌿';
  static const String redeemTitle = 'Redeem Your Points';
  static const String redeemSubtitle = 'Eco-friendly rewards';

  // 🌍 IMPACT METRICS
  static const String yourImpact = 'Your Impact';
  static const String thisMonth = 'This month';
  static const String wasteCollected = 'WASTE COLLECTED';
  static const String treesSaved = 'TREES SAVED';
  static const String co2Reduced = 'CO₂ REDUCED';
  static const String itemsRecycled = 'items recycled';
  static const String equivalentToTrees = 'Equivalent to';
  static const String trees = 'trees';
  static const String carbonFootprintDecreased = 'Carbon footprint decreased';

  // ⚡ QUICK ACTIONS
  static const String quickActions = 'Quick Actions';
  static const String scanWaste = 'Scan Waste';
  static const String schedulePickup = 'Schedule Pickup';
  static const String pickupItems = 'Pickup Items';
  static const String viewRewards = 'View Rewards';

  // 📰 NEWS & EDUCATION
  static const String ecoNews = 'Eco News';
  static const String learnAndInspire = 'Learn & Be Inspired';
  static const String ecoTips = 'Eco Tips';
  static const String stories = 'Stories';

  // ✅ SUCCESS & FEEDBACK MESSAGES
  static const String thankYouPlanetary = 'Thank you for protecting nature 🌍';
  static const String helpedCleanPlanet = 'You helped clean the planet!';
  static const String orderHelpsPlanet = 'Your order helps the planet! 💚';
  static const String wasteAdded = 'Waste added to collection!';
  static const String successfulPickup = 'Pickup scheduled successfully!';
  static const String pointsEarned = 'Green Points earned! 🌿';
  static const String redeemed = 'Reward redeemed! You\'re amazing!';

  // 🌱 ENVIRONMENTAL MESSAGES
  static const String everyActionCounts = 'Every action counts';
  static const String youMatterToEarth = 'You matter to Earth';
  static const String makingDifference = 'Making a difference, one item at a time';
  static const String protectingNature = 'Protecting nature together';
  static const String sustainableFuture = 'Building a sustainable future';

  // 👋 LOGOUT & GOODBYE
  static const String logoutMessage = 'See you soon! Keep protecting nature 🌱';
  static const String logoutConfirm = 'Are you sure?';
  static const String logoutTitle = 'Logout';

  // 🏆 ACHIEVEMENTS & RANK
  static const String leaderboard = 'Leaderboard';
  static const String topEcoWarriors = 'Top Eco Warriors';
  static const String youAreRanked = 'You\'re ranked';
  static const String outOf = 'out of';
  static const String keepsGrowing = 'Your impact keeps growing!';
  static const String nextMilestone = 'Next milestone';

  // 🛍️ PRODUCTS & REWARDS
  static const String ecoProducts = 'Eco-Friendly Products';
  static const String store = 'Shop Eco-Friendly';
  static const String bambooBottle = 'Bamboo Bottle';
  static const String plantTree = 'Plant a Tree';
  static const String organicSoapPack = 'Organic Soap Pack';
  static const String buyNow = 'Get It';
  static const String addToCart = 'Add to Cart';

  // 🔔 NOTIFICATIONS
  static const String pickupReady = 'Your waste pickup is ready! 🚗';
  static const String pickupScheduled = 'Pickup scheduled for tomorrow';
  static const String pointsMilestone = 'You\'ve reached a new milestone! 🎉';
  static const String friendJoined = 'Your friend joined EchoCout! 👋';

  // 📊 STATS & DATA
  static const String thisWeek = 'This week';
  static const String allTime = 'All time';
  static const String noDataYet = 'No data yet';
  static const String startCollecting = 'Start collecting to see your impact';

  // ❌ ERRORS & WARNINGS
  static const String somethingWrong = 'Oops! Something went wrong';
  static const String tryAgain = 'Please try again';
  static const String noInternet = 'No internet connection';
  static const String checkConnection = 'Please check your connection';

  // 🎯 ONBOARDING & INTRO
  static const String onboardingTitle1 = 'Waste Less, Impact More';
  static const String onboardingDesc1 =
      'Convert your waste into valuable Green Points';
  static const String onboardingTitle2 = 'Earn & Redeem';
  static const String onboardingDesc2 =
      'Collect points and get eco-friendly rewards';
  static const String onboardingTitle3 = 'Join The Movement';
  static const String onboardingDesc3 =
      'Together we\'re protecting our planet 🌍';
  static const String getStarted = 'Get Started';
  static const String skip = 'Skip';

  // 📱 PROFILE & SETTINGS
  static const String myProfile = 'My Profile';
  static const String myStats = 'My Stats';
  static const String ecoPreferences = 'Eco Preferences';
  static const String about = 'About EchoCout';
  static const String contactUs = 'Contact Us';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';

  // 🎓 HELPFUL TEXT
  static const String scanQRForWaste = 'Scan QR codes on waste items';
  static const String easierTogether = 'Waste collection is easier together';
  static const String yourJourneyMatters = 'Your sustainability journey matters';
}

/// 🎨 ECO-FRIENDLY TEXT STYLE HELPERS
abstract class EcoTextStyles {
  /// Celebratory success message
  static String celebrateAchievement(String action) {
    return '🎉 $action - Thank you for protecting nature!';
  }

  /// Impact metric display
  static String impactMetric(String value, String unit, String description) {
    return '$value $unit\n$description';
  }

  /// Points earned message
  static String pointsMessage(int points) {
    return 'You earned $points Green Points! 🌿';
  }

  /// Environmental impact (mocked)
  static String environmentalImpact(
    double wasteKg,
    double treesSaved,
    double co2Reduced,
  ) {
    return '''
    🗑️ Waste Collected: ${wasteKg.toStringAsFixed(1)} kg
    🌳 Trees Saved: ${treesSaved.toStringAsFixed(1)}
    ☁️ CO₂ Reduced: ${co2Reduced.toStringAsFixed(1)} kg
    ''';
  }

  /// Rank/Position message
  static String rankMessage(int rank, int total) {
    if (rank == 1) {
      return '🏆 YOU\'RE #1! KEEP IT UP! 🌍';
    } else if (rank <= 10) {
      return '🥇 Top 10! Amazing work!';
    } else if (rank <= 50) {
      return '📈 Great progress! You\'re in the top 50!';
    } else {
      return 'Keep collecting - you\'re on the way up!';
    }
  }

  /// Encouragement message based on streak
  static String streakMessage(int daysInARow) {
    if (daysInARow == 1) {
      return 'Great start! Keep it going! 🔥';
    } else if (daysInARow == 7) {
      return '🔥 1 Week Streak! You\'re unstoppable!';
    } else if (daysInARow == 30) {
      return '🌟 1 Month Committed! You\'re a true eco-warrior!';
    } else {
      return '🔥 $daysInARow day streak! Amazing dedication!';
    }
  }

  /// Next milestone message
  static String nextMilestoneMessage(int pointsNeeded) {
    return 'You need $pointsNeeded more points for the next reward!';
  }
}

/// 🌍 ECO-FRIENDLY FORMATTING
extension EcoFormatting on num {
  /// Format waste weight nicely
  /// 1234.5 -> "1.23 kg"
  String toWasteFormat() {
    if (this < 1000) {
      return '${toStringAsFixed(1)} kg';
    }
    final tonnes = this / 1000;
    return '${tonnes.toStringAsFixed(2)} tonnes';
  }

  /// Format points
  /// 3400 -> "3,400"
  String toPointsFormat() {
    return toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  /// Format CO2 reduction
  /// 12.8 -> "12.8 kg CO₂"
  String toCO2Format() {
    return '${toStringAsFixed(1)} kg CO₂';
  }

  /// Format trees saved (mock calculation)
  /// 45.5 kg waste -> 3.2 trees
  double toTreesEquivalent() {
    // Rough estimate: ~15kg waste = 1 tree worth of paper
    return (this / 15).toStringAsFixed(1) as double;
  }
}

/// 🎯 ACHIEVEMENT MESSAGES
abstract class AchievementMessages {
  static const Map<String, String> achievements = {
    'first_waste': 'First Step! 🌱\nYou added your first waste item!',
    'ten_items': 'Collector! 🏆\nYou\'ve collected 10 items!',
    'hundred_points': 'Green Warrior! 💚\nYou earned 100 Green Points!',
    'one_tree': 'Tree Saver! 🌳\nYou saved the equivalent of 1 tree!',
    'week_streak': 'Committed! 🔥\nYou\'ve been collecting for a week!',
    'top_100': 'Rising Star! ⭐\nYou\'re in the top 100!',
    'invite_friend': 'Share the Love! 👫\nInvite a friend and both get bonus points!',
    'first_redemption': 'Reward Unlocked! 🎁\nYou redeemed your first reward!',
  };

  static String getMessage(String achievementId) {
    return achievements[achievementId] ?? 'Achievement Unlocked! 🎉';
  }
}
