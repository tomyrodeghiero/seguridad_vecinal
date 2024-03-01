import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/screens/home_screen.dart';
import 'package:seguridad_vecinal/screens/notifications_screen.dart';
import 'package:seguridad_vecinal/screens/onboarding_screen.dart';
import 'package:seguridad_vecinal/screens/personal_info_screen.dart';
import 'package:seguridad_vecinal/screens/post_screen.dart';
import 'package:seguridad_vecinal/screens/profile_screen.dart';
import 'package:seguridad_vecinal/screens/register_screen.dart';
import 'package:seguridad_vecinal/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/personalInfoScreen': (context) => PersonalInfoScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/post': (context) => PostScreen(),
      },
    );
  }
}
