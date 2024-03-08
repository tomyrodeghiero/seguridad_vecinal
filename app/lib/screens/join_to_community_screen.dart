import 'package:cori/colors.dart';
import 'package:cori/screens/satisfaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinToCommunityScreen extends StatefulWidget {
  @override
  _JoinToCommunityScreenState createState() => _JoinToCommunityScreenState();
}

class _JoinToCommunityScreenState extends State<JoinToCommunityScreen> {
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
              'Te uniste a la Comunidad!',
              style: TextStyle(
                color: AppColors.purple500, // Color de texto púrpura
                fontSize: 40.0, // Tamaño de fuente grande
                fontWeight: FontWeight.w500, // Texto en negrita
              ),
            ),
            SizedBox(height: 60.0), // Espacio entre el texto y el ícono
            Image.asset(
              'assets/reaction-05.png',
              fit: BoxFit.contain,
              height: 180,
            ),
            SizedBox(height: 60.0), // Espacio entre el ícono y la pregunta
            Text(
              'Podrás estar conectado con tus vecinos y compartir información sobre hechos de inseguridades para construir juntos un entorno seguro.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, // Color de texto negro
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
          Navigator.pop(context);
        },
      ),
    );
  }
}
