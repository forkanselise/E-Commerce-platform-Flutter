import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/nexus_theme.dart';
import '../widgets/glass_container.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (ctx, anim, secAnim) => const MainNavigationScreen(),
            transitionsBuilder: (ctx, anim, secAnim, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
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
          gradient: NexusTheme.heroGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (ctx, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                    color: NexusTheme.bgCocoaDark.withOpacity(0.95),
                    border: Border.all(color: NexusTheme.rosePrimary.withOpacity(0.5), width: 1.5),
                    borderRadius: 28,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/buttercup_logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: NexusTheme.roseGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.cake, color: Colors.white, size: 56),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'BUTTERCUP',
                          style: TextStyle(
                            color: NexusTheme.primaryGold,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'BAKE • MAKE • LEARN',
                          style: TextStyle(
                            color: NexusTheme.roseLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(NexusTheme.rosePrimary),
                              backgroundColor: Colors.white10,
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
