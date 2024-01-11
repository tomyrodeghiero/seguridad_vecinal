import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/widgets/password_input_field.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 160.0,
              height: 160.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
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
                    color: AppColors.waterGreen100,
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
                      color: AppColors.waterGreen200,
                      width:
                          2.0), // Asegúrate de que el color esté definido en la clase AppColors
                  borderRadius: BorderRadius.circular(100.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.waterGreen200, width: 2.0),
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
                primary: AppColors.waterGreen300, // background (button) color
                onPrimary: Colors.white, // foreground (text) color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
