import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Tu perfil', style: TextStyle(color: Colors.black)),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.waterGreen400,
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        leadingWidth: 56,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
      ),
      drawer: Drawer(
        backgroundColor: AppColors.waterGreen400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: Text('L',
                                  style: TextStyle(
                                      fontSize: 40.0, color: Colors.white)),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              'Luciana',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'González',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Editar perfil',
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(Icons.edit, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(16),
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
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.white),
                      title: Text('Configuración',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.white),
                      title: Text('Centro de ayuda',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Luciana González',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(height: 30),
            Text('Ciudad de Río Cuarto, Córdoba.',
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
            Text('Miembro desde Diciembre 2023.',
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
            SizedBox(height: 32.0),
            Container(
              height: 1.0,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.waterGreen400,
                    onPrimary: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Reportes',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 1.0,
              color: AppColors.waterGreen400,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: List.generate(2, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Center(),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
