import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashPrimary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.splashPrimary,
        child: Stack(
          children: [
            // Clouds at top
            Positioned(
              top: 80,
              right: 40,
              child: _buildCloud(size: 70),
            ),
            Positioned(
              top: 120,
              left: 30,
              child: _buildCloud(size: 50),
            ),

            // Main logo text - centered
            Center(
              child: Text(
                'wice',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 56,
                      letterSpacing: 1.2,
                    ),
              ),
            ),

            // Landscape at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    // Nature ground (solid color)
                    Positioned(
                      bottom: 0,
                      left: -50,
                      right: -50,
                      child: Container(
                        height: 240,
                        color: AppColors.splashNatureGreen,
                        child: CustomPaint(
                          painter: HillPainter(),
                          size: Size(double.infinity, 240),
                        ),
                      ),
                    ),

                    // Trees
                    Positioned(
                      bottom: 130,
                      left: 25,
                      child: _buildTree(height: 90, trunkWidth: 8),
                    ),
                    Positioned(
                      bottom: 110,
                      left: 80,
                      child: _buildTree(height: 110, trunkWidth: 10),
                    ),
                    Positioned(
                      bottom: 85,
                      left: 150,
                      child: _buildTree(height: 135, trunkWidth: 12),
                    ),
                    Positioned(
                      bottom: 100,
                      right: 40,
                      child: _buildTree(height: 120, trunkWidth: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud({double size = 70}) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: AppColors.splashCloudLight,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }

  Widget _buildTree({required double height, required double trunkWidth}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tree foliage (circle)
        Container(
          width: height * 0.7,
          height: height * 0.7,
          decoration: BoxDecoration(
            color: AppColors.splashNatureGreen.withOpacity(0.85),
            shape: BoxShape.circle,
          ),
        ),
        // Tree trunk
        Container(
          width: trunkWidth,
          height: height * 0.45,
          color: AppColors.splashNatureGreen.withOpacity(0.6),
        ),
      ],
    );
  }
}

class HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.splashNatureGreen;
    
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.3,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
