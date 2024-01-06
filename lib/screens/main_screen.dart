import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/screens/community_detail_screen.dart';
import 'package:seguridad_vecinal/screens/community_post_screen.dart';
import 'package:seguridad_vecinal/screens/community_screen.dart';
import 'package:seguridad_vecinal/screens/home_screen.dart';
import 'package:seguridad_vecinal/screens/notifications_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    NotificationsScreen(),
    CommunityScreen(),
    CommunityDetailScreen(),
    CommunityPostScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.waterGreen400,
        onTap: _onItemTapped,
      ),
    );
  }
}
