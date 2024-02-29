import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Tu Perfil',
                style: TextStyle(
                    fontSize: 22.0,
                    color: AppColors.purple500,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Image.asset(
            'assets/back-arrow.png',
            height: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                              radius: 50.0, // Tamaño aumentado
                              child: Text(
                                'L',
                                style: TextStyle(
                                    fontSize:
                                        60.0, // También puedes ajustar el tamaño de la fuente si lo deseas
                                    color: Colors.white),
                              ),
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
                        Container(
                          width:
                              120, // Ajusta el tamaño del contenedor para el efecto de sombra
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purple500.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(
                                    0, 2), // Cambios de posición de la sombra
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.purple500, // Color del borde
                              width: 1.5, // Grosor del borde
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50, // Tamaño del CircleAvatar
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.purple500,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/add.png',
                                width: 16.0,
                                height: 16.0,
                              ),
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple500),
            ),
            SizedBox(height: 28.0),
            Text(
              'Ciudad de Río Cuarto, Córdoba.\nMiembro desde Diciembre 2023.',
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              textAlign: TextAlign
                  .center, // Opcional: Alinea el texto al centro si lo prefieres
            ),
            SizedBox(height: 28.0),
            Container(
              height: 1.0,
              color: Colors.grey,
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Image.asset('assets/statistics.png',
                            width: 20), // Icono para Reportes
                        label: Text(
                          'Reportes',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors
                              .purple500, // Color del botón de Reportes
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 16), // Espaciador entre los botones
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Image.asset('assets/hearth.png',
                            width: 20), // Icono para Favoritos
                        label: Text(
                          'Favoritos',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors
                              .purple500, // Color del botón de Favoritos
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: List.generate(4, (index) {
                    // Genera 4 para tener dos en cada columna
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey
                              .shade300, // Color de fondo de los contenedores
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.purple500)),
                      // Añade el contenido de cada contenedor aquí
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
