import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: const [
              OnboardingScreen(
                title: 'Recycle & Get Rewarded!',
                description: 'Earn points for responsible waste disposal and redeem them for many more exclusive benefits.',
                illustration: OnboardingIllustration1(),
              ),
              OnboardingScreen(
                title: 'Let AI Sort Your Waste',
                description: 'Simply scan your waste, and our AI will automatically detect and categorize it for proper disposal. No more guessing!',
                illustration: OnboardingIllustration2(),
              ),
              OnboardingScreen(
                title: 'Schedule a Pickup with Ease!',
                description: 'Schedule a pickup right from the app, and we\'ll handle the rest conveniently and eco-friendly!',
                illustration: OnboardingIllustration3(),
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: PageIndicator(
              pageCount: 3,
              currentPage: _currentPageIndex,
            ),
          ),
          if (_currentPageIndex == 2)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/auth/phone');
                      },
                      child: const Text(
                        'Get Started as User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/driver-login');
                      },
                      child: const Text(
                        'Driver Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final Widget illustration;

  const OnboardingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: illustration,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: index == currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index == currentPage
                ? const Color(0xFF7FD8E8)
                : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Illustration placeholders
class OnboardingIllustration1 extends StatelessWidget {
  const OnboardingIllustration1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Character silhouette
          Positioned(
            left: 20,
            bottom: 40,
            child: _buildCharacter(),
          ),
          // Large coin
          Positioned(
            top: 30,
            right: 60,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[400],
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber[400]!.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '€',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Floating coins
          Positioned(
            top: 120,
            right: 30,
            child: _buildFloatingCoin(size: 30),
          ),
          Positioned(
            bottom: 100,
            right: 40,
            child: _buildFloatingCoin(size: 25),
          ),
          Positioned(
            bottom: 80,
            left: 60,
            child: _buildFloatingCoin(size: 20),
          ),
          // Party popper
          Positioned(
            top: 50,
            right: 20,
            child: Transform.rotate(
              angle: 0.5,
              child: const Icon(Icons.celebration, color: Colors.amber, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter() {
    return SizedBox(
      width: 80,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Head
          Container(
            width: 30,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.orange[200],
              shape: BoxShape.circle,
            ),
          ),
          // Body with arm raised
          Positioned(
            top: 40,
            child: Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal[600],
              ),
            ),
          ),
          // Arm (raised)
          Positioned(
            top: 35,
            right: -10,
            child: Container(
              width: 20,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange[200],
              ),
            ),
          ),
          // Legs
          Positioned(
            bottom: -10,
            child: Container(
              width: 35,
              height: 40,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCoin({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber[400],
      ),
      child: Center(
        child: Text(
          '€',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OnboardingIllustration2 extends StatelessWidget {
  const OnboardingIllustration2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Character
          Positioned(
            left: 10,
            bottom: 30,
            child: _buildCharacter(),
          ),
          // Phone with waste detection
          Positioned(
            right: 20,
            top: 40,
            child: Container(
              width: 100,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!, width: 3),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // AI detection indicator
          Positioned(
            left: 50,
            top: 80,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7FD8E8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter() {
    return SizedBox(
      width: 70,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Head
          Container(
            width: 28,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange[200],
              shape: BoxShape.circle,
            ),
          ),
          // Body
          Positioned(
            top: 38,
            child: Container(
              width: 38,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.teal[600],
              ),
            ),
          ),
          // Yellow/Orange shirt part
          Positioned(
            top: 42,
            child: Container(
              width: 18,
              height: 40,
              color: Colors.orange[500],
            ),
          ),
          // Legs
          Positioned(
            bottom: -8,
            child: Container(
              width: 32,
              height: 38,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingIllustration3 extends StatelessWidget {
  const OnboardingIllustration3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Character
          Positioned(
            right: 20,
            bottom: 30,
            child: _buildCharacter(),
          ),
          // Trash bin / Waste container
          Positioned(
            left: 30,
            top: 60,
            child: Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  // Handle
                  Positioned(
                    top: 5,
                    left: 30,
                    right: 30,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  // Lid lines
                  Positioned(
                    top: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 2,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Checkmark
          Positioned(
            bottom: 50,
            right: 5,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[400],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter() {
    return SizedBox(
      width: 70,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Head
          Container(
            width: 28,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange[200],
              shape: BoxShape.circle,
            ),
          ),
          // Body
          Positioned(
            top: 38,
            child: Container(
              width: 38,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.teal[600],
              ),
            ),
          ),
          // Yellow shirt part
          Positioned(
            top: 42,
            child: Container(
              width: 18,
              height: 40,
              color: Colors.orange[500],
            ),
          ),
          // Leg
          Positioned(
            bottom: -8,
            child: Container(
              width: 32,
              height: 38,
              color: Colors.black87,
            ),
          ),
          // Pointing hand
          Positioned(
            top: 36,
            right: -8,
            child: Container(
              width: 12,
              height: 18,
              color: Colors.orange[200],
            ),
          ),
        ],
      ),
    );
  }
}
