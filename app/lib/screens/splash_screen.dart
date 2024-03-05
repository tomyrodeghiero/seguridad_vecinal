import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cori/colors.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cori/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => checkLoginStatus());
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      // Realiza la solicitud HTTP al nuevo endpoint
      final response = await http.get(Uri.parse(
          'http://192.168.88.138:5001/api/check-email?email=$userEmail'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exists']) {
          Navigator.of(context).pushNamed('/home');
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple500,
      body: Center(
        child: SvgPicture.asset(
          'assets/cori-logotype.svg',
          width: 120.0,
          height: 120.0,
        ),
      ),
    );
  }
}
