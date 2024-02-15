import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/widgets/password_input_field.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 80.0, // Ajusta este valor según sea necesario
              height: 80.0, // Ajusta este valor según sea necesario
              child: Image.asset(
                'assets/cori-full-logotype.png', // Asegúrate de que el PNG esté en la carpeta de assets
                fit: BoxFit.contain, // Esto asegurará que el PNG se ajuste bien
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 32.0), // Esto agrega padding vertical
              child: Text(
                '¿Ya tienes cuenta?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.purple500,
                    fontWeight: FontWeight.w500),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Ingresa tu mail',
                labelStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 20.0), // Ajusta el padding aquí
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.purple500,
                      width:
                          2.0), // Asegúrate de que el color esté definido en la clase AppColors
                  borderRadius: BorderRadius.circular(100.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.purple500, width: 2.0),
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            SizedBox(height: 22.0),
            PasswordField(),
            SizedBox(height: 40.0),
            ElevatedButton(
              child: Text(
                'REGISTRARTE',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.purple500,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 12.0), // Tamaño vertical del botón
              ),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                // Implementar funcionalidad de inicio de sesión con Google
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.purple500, // Color de fondo del botón
                onPrimary: Colors.white, // Color de texto del botón
                padding: EdgeInsets.symmetric(
                    vertical: 12.0), // Tamaño vertical del botón
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centrar horizontalmente el contenido
                children: <Widget>[
                  Text(
                    'Continuar con',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0), // Espacio entre texto e imagen
                  // Usamos un widget Flexible para evitar problemas de overflow
                  Flexible(
                    child: Image.asset(
                      'assets/google-white-logo.png', // Asegúrate de que el PNG esté en la carpeta de assets
                      height: 24.0, // Altura del logo
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
