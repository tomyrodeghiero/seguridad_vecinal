import 'package:cori/colors.dart';
import 'package:cori/screens/satisfaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _firstName =
      ''; // Variable para almacenar el primer nombre del usuario

  @override
  void initState() {
    super.initState();
    _loadUserFirstName(); // Carga el nombre cuando el estado se inicializa
  }

  _loadUserFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String fullName = prefs.getString('fullName') ?? '';
    setState(() {
      _firstName = fullName
          .split(' ')[0]; // Asumiendo que fullName es "FirstName LastName"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco como en la imagen
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 120.0,
            horizontal: 40.0), // Espacio simétrico alrededor del contenido
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hola $_firstName!',
              style: TextStyle(
                color: AppColors.purple500, // Color de texto púrpura
                fontSize: 40.0, // Tamaño de fuente grande
                fontWeight: FontWeight.w500, // Texto en negrita
              ),
            ),
            SizedBox(height: 60.0), // Espacio entre el texto y el ícono
            Image.asset(
              'assets/cori.png',
              fit: BoxFit.contain,
              height: 180,
            ),
            SizedBox(height: 60.0), // Espacio entre el ícono y la pregunta
            Text(
              '¿Tu problema tuvo solución?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, // Color de texto negro
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
            SizedBox(height: 40.0), // Espacio entre la pregunta y los botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SatisfactionScreen()),
                    );
                  },
                  child: Text(
                    'SI',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0), // Color de texto blanco
                  ),
                  style: ElevatedButton.styleFrom(
                    primary:
                        AppColors.turquoiseBlue500, // Color de fondo del botón
                    onPrimary: Colors
                        .white, // Color del contenido (texto/icono) del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18.0), // Bordes redondeados del botón
                    ),
                    minimumSize: Size(120,
                        36), // Tamaño mínimo para hacer el botón más ancho y menos alto
                  ),
                ),
                SizedBox(width: 20.0), // Espaciado entre los botones
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SatisfactionScreen()),
                    );
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600), // Color de texto blanco
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.purple500, // Color de fondo del botón
                    onPrimary: Colors
                        .white, // Color del contenido (texto/icono) del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18.0), // Bordes redondeados del botón
                    ),
                    minimumSize: Size(120,
                        36), // Tamaño mínimo para hacer el botón más ancho y menos alto
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
