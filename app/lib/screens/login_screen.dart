import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/services/auth_service.dart';
import 'package:seguridad_vecinal/widgets/password_input_field.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = AuthService();

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
              width: 80.0,
              height: 80.0,
              child: Image.asset(
                'assets/cori-full-logotype.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.purple500, width: 2.0),
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
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final userCredential = await AuthService().signInWithGoogle();
                  if (userCredential.user != null) {
                    // Crear un objeto de argumentos para pasar
                    final args = {
                      'email': userCredential.user!.email,
                    };

                    // Navegar y pasar los argumentos
                    Navigator.pushReplacementNamed(
                      context,
                      '/register',
                      arguments: args,
                    );
                  } else {
                    print(
                        'Inicio de sesión fallido o cancelado por el usuario.');
                  }
                } catch (e) {
                  print('Error durante el inicio de sesión: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.purple500,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Continuar con Google',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Image.asset(
                      'assets/google-white-logo.png',
                      height: 24.0,
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
