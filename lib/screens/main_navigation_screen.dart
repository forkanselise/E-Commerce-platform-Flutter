import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../widgets/nexus_navbar.dart';
import 'home_screen.dart';
import 'store_catalog_screen.dart';
import 'mobile_phones_screen.dart';
import 'masterclass_screen.dart';
import 'ai_concierge_screen.dart';
import 'user_profile_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    StoreCatalogScreen(),
    MobilePhonesScreen(),
    MasterclassScreen(),
    AiConciergeScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      appBar: const NexusNavbar(),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex > 4 ? 4 : currentIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.phone_iphone_outlined), activeIcon: Icon(Icons.phone_iphone), label: 'Tech Gear'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: 'Mr. Butter AI'),
        ],
      ),
    );
  }
}

