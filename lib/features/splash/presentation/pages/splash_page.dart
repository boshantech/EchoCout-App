import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Modern 2025 splash screen with continuous zoom-in animation.
/// Logo smoothly grows and exits screen, then transitions to next screen.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Single continuous zoom animation: 0.9 → 6.0 (2000ms)
    // Logo grows from normal size and completely exits screen
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale tween: 0.9 → 6.0 (logo grows and exits)
    _zoomAnimation = Tween<double>(begin: 0.9, end: 6.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeInCubic, // Accelerating curve for cinematic feel
      ),
    );

    // Listen to animation completion for navigation
    _zoomController.addStatusListener(_onAnimationStatusChange);

    // Start zoom animation immediately
    _zoomController.forward();
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Navigate after zoom animation completes
      if (mounted) {
        _navigateToOnboarding();
      }
    }
  }

  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/onboarding',
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _zoomController.removeStatusListener(_onAnimationStatusChange);
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _zoomAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _zoomAnimation.value,
              child: child,
            );
          },
          child: SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.asset(
              'assets/images/splash_logo.svg',
              fit: BoxFit.contain,
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
