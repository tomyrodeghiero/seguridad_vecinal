import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cori/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cori/services/auth_service.dart';
import 'package:cori/widgets/password_input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> loginUser(
        String email, String password, BuildContext context) async {
      final response = await http.post(
        Uri.parse('http://192.168.88.138:5001/api/validate-login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', data['userEmail']);
        await prefs.setString('fullName', data['fullName'] ?? '');
        await prefs.setString('imageUrl', data['imageUrl'] ?? '');

        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Fluttertoast.showToast(
          msg: "⚠️ Credenciales incorrectas",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      }
    }

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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Ingresa tu mail',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
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
            PasswordField(controller: _passwordController),
            SizedBox(height: 40.0),
            ElevatedButton(
              child: Text(
                'INICIAR SESIÓN',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                loginUser(
                    _emailController.text, _passwordController.text, context);
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
                    final response = await http.get(
                      Uri.parse(
                          'http://192.168.88.138:5001/api/check-email?email=${userCredential.user!.email}'),
                    );
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      if (data['exists']) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            'userEmail', userCredential.user!.email!);
                        await prefs.setString(
                            'fullName', userCredential.user!.displayName ?? '');
                        await prefs.setString('googlePhotoURL',
                            userCredential.user!.photoURL ?? '');
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        final args = {
                          'email': userCredential.user!.email,
                        };
                        Navigator.pushNamed(
                          context,
                          '/register',
                          arguments: args,
                        );
                      }
                    } else {
                      print('Error consultando si el usuario existe.');
                    }
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
                    'Continuar con',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
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
            SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
              child: Center(),
            ),
          ],
        ),
      ),
    );
  }
}
