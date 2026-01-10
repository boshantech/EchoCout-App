/// Mock delays for simulating network calls
class MockDelays {
  static const Duration authDelay = Duration(seconds: 2);
  static const Duration dataFetchDelay = Duration(milliseconds: 800);
  static const Duration uploadDelay = Duration(seconds: 3);
  static const Duration imageProcessDelay = Duration(seconds: 1);
  
  // Random failure simulation (10% chance)
  static bool shouldFail() => DateTime.now().millisecond % 10 == 0;
}
