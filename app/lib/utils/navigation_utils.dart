import 'package:flutter/material.dart';
import 'package:cori/screens/community_screen.dart';
import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/map_screen.dart';

void navigateToScreen(BuildContext context, int currentIndex, int newIndex) {
  // Si el índice seleccionado es el mismo que el índice actual, no hacer nada.
  if (currentIndex == newIndex) return;

  Widget screen =
      HomeScreen(); // Valor predeterminado para evitar el warning de 'screen' podría no estar inicializado.

  switch (newIndex) {
    case 0:
      screen = HomeScreen();
      break;
    case 1:
      screen = MapScreen();
      break;
    case 2:
      screen = CommunityScreen();
      break;
    default:
      return; // No hace nada si el índice no es reconocido
  }

  // Navegar sin efecto de desplazamiento
  Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: Duration(seconds: 0),
      ));
}
