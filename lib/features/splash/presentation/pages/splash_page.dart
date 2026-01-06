import 'package:flutter/material.dart';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7EDCE0),
              Color(0xFFA8E6EC),
            ],
          ),
        ),
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

            // Main logo and text - centered
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
                    // Hills background
                    Positioned(
                      bottom: 0,
                      left: -50,
                      right: -50,
                      child: Container(
                        height: 240,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF6BC949),
                              const Color(0xFF5AB032).withOpacity(0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              MediaQuery.of(context).size.width,
                            ),
                            topRight: Radius.circular(
                              MediaQuery.of(context).size.width,
                            ),
                          ),
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
        color: Colors.white.withOpacity(0.95),
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
            color: const Color(0xFF5FB84A),
            shape: BoxShape.circle,
          ),
        ),
        // Tree trunk
        Container(
          width: trunkWidth,
          height: height * 0.45,
          color: const Color(0xFF4A7C3C),
        ),
      ],
    );
  }
}
