import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart'; // Asegúrate de que este archivo exista y contenga la definición de AppColors.purple500

class SatisfactionScreen extends StatefulWidget {
  @override
  _SatisfactionScreenState createState() => _SatisfactionScreenState();
}

class _SatisfactionScreenState extends State<SatisfactionScreen> {
  int _selectedReactionIndex = -1;

  void _onReactionSelected(int index) {
    setState(() {
      _selectedReactionIndex = index;
    });
  }

  String _getReactionAsset(int index) {
    return 'assets/reaction-0${index + 1}${_selectedReactionIndex == index ? '' : '-black'}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 160.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Alinear al inicio para la alineación izquierda
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '¿Qué nivel de satisfacción obtuvo con nuestra ayuda?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.purple500,
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    height: 1.075),
              ),
            ),
            SizedBox(height: 112.0),
            Padding(
              padding: EdgeInsets.only(
                  left: 32), // Añadir padding izquierdo al texto
              child: Text(
                'Seleccioná para medir el nivel',
                style: TextStyle(
                  color: AppColors.purple500,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0), // Reducir espacio antes del contenedor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                alignment: Alignment.center,
                width: double
                    .infinity, // Hacer que el contenedor ocupe todo el ancho
                padding: EdgeInsets.all(8.0), // Espacio dentro del borde
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      32), // Esquinas redondeadas del borde
                  color: Colors.white, // Fondo blanco para el contenedor
                  border: Border.all(
                    color: AppColors.purple500, // Color del borde
                    width: 2, // Grosor del borde
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Distribuye el espacio uniformemente entre las imágenes
                    children: List<Widget>.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => _onReactionSelected(index),
                        child: Image.asset(
                          _getReactionAsset(index),
                          width: 44.0, // Tamaño de las imágenes de reacciones
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ), // Añadir padding horizontal para alinear con el contenedor
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Insatisfecho',
                      style: TextStyle(color: AppColors.purple500)),
                  Text('Muy satisfecho',
                      style: TextStyle(color: AppColors.purple500))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedReactionIndex != -1
          ? FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.purple500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.purple500,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/finish-icon.png',
                    height: 24.0,
                    width: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            )
          : null,
    );
  }
}
