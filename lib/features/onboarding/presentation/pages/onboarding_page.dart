import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

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
                illustration: OnboardingIllustration3Slider(),
              ),
              OnboardingScreen(
                title: 'Schedule a Pickup with Ease!',
                description: 'Schedule a pickup right from the app, and we\'ll handle the rest conveniently and eco-friendly!',
                illustration: OnboardingIllustration2(),
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
    Key? key,
    required this.title,
    required this.description,
    required this.illustration,
  }) : super(key: key);

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
    Key? key,
    required this.pageCount,
    required this.currentPage,
  }) : super(key: key);

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
  const OnboardingIllustration1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/slider_1.svg',
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OnboardingIllustration2 extends StatelessWidget {
  const OnboardingIllustration2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/slider_2.svg',
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OnboardingIllustration3 extends StatelessWidget {
  const OnboardingIllustration3({Key? key}) : super(key: key);

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
    return Container(
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

class OnboardingIllustration3Slider extends StatelessWidget {
  const OnboardingIllustration3Slider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/slider_3.svg',
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}
