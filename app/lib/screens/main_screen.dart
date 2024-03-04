import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/map_screen.dart';
import 'package:cori/screens/community_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    CommunityScreen(),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Colors.black, width: 1.0), // Borde superior negro
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? Image.asset('assets/home-selected.png',
                      width: 28, height: 28)
                  : Image.asset('assets/home.png', width: 28, height: 28),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? Image.asset('assets/location-pin-selected.png',
                      width: 28, height: 28)
                  : Image.asset('assets/location-pin.png',
                      width: 28, height: 28),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? Image.asset('assets/community-selected.png',
                      width: 28, height: 28)
                  : Image.asset('assets/community.png', width: 28, height: 28),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.waterGreen400,
          showSelectedLabels:
              false, // No muestra la etiqueta de la opción seleccionada
          showUnselectedLabels:
              false, // No muestra la etiqueta de las opciones no seleccionadas
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
