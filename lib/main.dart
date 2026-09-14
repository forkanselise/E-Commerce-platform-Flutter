import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/nexus_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NexusBakeryTechApp(),
    ),
  );
}

class NexusBakeryTechApp extends StatelessWidget {
  const NexusBakeryTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buttercup',
      debugShowCheckedModeBanner: false,
      theme: NexusTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
