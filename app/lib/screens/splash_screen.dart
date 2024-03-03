import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:seguridad_vecinal/colors.dart';
import 'dart:async';

import 'package:seguridad_vecinal/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple500,
      body: Center(
        child: SvgPicture.asset(
          'assets/cori-logotype.svg', // Ruta a tu archivo SVG
          width: 120.0,
          height: 120.0,
        ),
      ),
    );
  }
}
