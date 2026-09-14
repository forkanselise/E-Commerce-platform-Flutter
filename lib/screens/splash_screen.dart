import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/nexus_theme.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (ctx, anim, secAnim) => const MainNavigationScreen(),
            transitionsBuilder: (ctx, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, 0.0),
            radius: 1.2,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAF6F0),
              Color(0xFF3D2314),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft Rose Radial Glow Ring
            Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    NexusTheme.rosePrimary.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Centered Floating Logo Card
            AnimatedBuilder(
              animation: _controller,
              builder: (ctx, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 28),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D2314).withOpacity(0.14),
                            blurRadius: 50,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: NexusTheme.rosePrimary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF3D2314).withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Official Buttercup Logo Image
                          Image.asset(
                            'assets/images/buttercup_logo.png',
                            height: 110,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => Image.asset(
                              'assets/images/Picture2.png',
                              height: 110,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  gradient: NexusTheme.roseGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.cake, color: Colors.white, size: 64),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Dual Tone Progress Indicator
                          Container(
                            width: 160,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D2314).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            alignment: Alignment.centerLeft,
                            child: LayoutBuilder(
                              builder: (ctx, constraints) {
                                return Container(
                                  width: constraints.maxWidth * _progressAnimation.value,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [NexusTheme.rosePrimary, NexusTheme.bgCocoaDark],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tagline matching web platform
                          const Text(
                            'BAKE • MAKE • LEARN',
                            style: TextStyle(
                              color: NexusTheme.rosePrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

