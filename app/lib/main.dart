import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/notifications_screen.dart';
import 'package:cori/screens/onboarding_screen.dart';
import 'package:cori/screens/personal_info_screen.dart';
import 'package:cori/screens/post_screen.dart';
import 'package:cori/screens/profile_screen.dart';
import 'package:cori/screens/register_screen.dart';
import 'package:cori/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAn0XdrsK9NZx9CbDma-DeSd-WXOWckIps",
            appId: "1:79192326921:ios:1d3faaccce195ea31389d8",
            messagingSenderId:
                "79192326921-6vv34aurhs1193ii5nrf44j56ip8ojkj.apps.googleusercontent.com",
            projectId: "cori-a9324"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Use the Firebase initialization Future
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // Log the error or use a breakpoint to inspect the error
          print('Error initializing Firebase: ${snapshot.error}');
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
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

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Cargando...'),
            ),
          ),
        );
      },
    );
  }
}
