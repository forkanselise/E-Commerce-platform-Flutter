import 'package:flutter/material.dart';
import '../widgets/nexus_navbar.dart';
import 'home_screen.dart';
import 'store_catalog_screen.dart';
import 'mobile_phones_screen.dart';
import 'masterclass_screen.dart';
import 'user_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StoreCatalogScreen(),
    MobilePhonesScreen(),
    MasterclassScreen(),
    UserProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NexusNavbar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.phone_iphone_outlined), activeIcon: Icon(Icons.phone_iphone), label: 'Tech Gear'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
