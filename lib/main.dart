import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/screens/login_screen.dart';
import 'package:seguridad_vecinal/screens/onboarding_screen.dart';
import 'package:seguridad_vecinal/screens/personal_info_screen.dart';
import 'package:seguridad_vecinal/screens/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/personalInfoScreen': (context) => PersonalInfoScreen(),
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}
