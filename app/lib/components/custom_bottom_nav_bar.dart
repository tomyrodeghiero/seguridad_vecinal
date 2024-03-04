import 'package:flutter/material.dart';
import 'package:cori/colors.dart'; // Asegúrate de tener este archivo para los colores

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: selectedIndex == 0
                ? Image.asset('assets/home-selected.png', width: 28, height: 28)
                : Image.asset('assets/home.png', width: 28, height: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 1
                ? Image.asset('assets/location-pin-selected.png',
                    width: 28, height: 28)
                : Image.asset('assets/location-pin.png', width: 28, height: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 2
                ? Image.asset('assets/community-selected.png',
                    width: 28, height: 28)
                : Image.asset('assets/community.png', width: 28, height: 28),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.waterGreen400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onItemTapped,
      ),
    );
  }
}
