// custom_drawer.dart
import 'package:cori/screens/help_center.dart';
import 'package:cori/screens/login_screen.dart';
import 'package:cori/screens/privacy_screen.dart';
import 'package:cori/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String _fullName = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        fullName: _fullName,
        imageUrl: _imageUrl,
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final String fullName;
  final String imageUrl;

  const CustomDrawer({
    Key? key,
    required this.fullName,
    required this.imageUrl,
  }) : super(key: key);

  Future<Map<String, dynamic>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
    String imageUrl = prefs.getString('imageUrl') ?? '';
    return {'fullName': fullName, 'imageUrl': imageUrl};
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _clearPreferencesAndLogout(BuildContext context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }

    return Drawer(
      backgroundColor: AppColors.waterGreen400,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/bg-drawer.png"), // Asegúrate de que este path sea correcto
            fit: BoxFit
                .cover, // Esto hará que la imagen cubra todo el fondo del Drawer
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                              radius: 50,
                              child: imageUrl.isEmpty
                                  ? Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            SizedBox(height: 12.0),
                            ...fullName.split(' ').map(
                                  (namePart) => Text(
                                    namePart,
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()),
                                  );
                                },
                                child: Transform.translate(
                                  offset: Offset(-8.0,
                                      0.0), // Ajusta el valor -10.0 según necesites
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Editar perfil',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(width: 8),
                                      Image.asset(
                                        'assets/note.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.lock_outline, color: Colors.white),
                      title: Text('Privacidad',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.settings_outlined, color: Colors.white),
                      title: Text('Configuración',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.white),
                      title: Text('Centro de ayuda',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpCenterScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.exit_to_app_outlined, color: Colors.white),
                      title: Text('Cerrar sesión',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        _clearPreferencesAndLogout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
