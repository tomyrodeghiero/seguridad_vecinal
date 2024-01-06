import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/screens/community_post_screen.dart';
import 'package:seguridad_vecinal/screens/notifications_screen.dart';
import 'package:seguridad_vecinal/screens/profile_screen.dart';

class CommunityDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 28.0),
            onPressed: () {},
          ),
        ],
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
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 40,
                                child: Text('L',
                                    style: TextStyle(
                                        fontSize: 40.0, color: Colors.white)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 14.0,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        2), // Ajusta el padding para el tamaño del borde
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Color del borde
                        width: 1, // Ancho del borde
                      ),
                    ),
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Banda Norte', // Nombre de la comunidad
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          '22 miembros', // Cantidad de miembros
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          height: 28.0,
                          child: FloatingActionButton.extended(
                            onPressed: () {},
                            label: Text(
                              'Unirme'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: AppColors.waterGreen400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Noticias',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  String newsTitle;
                  String newsSubtitle;
                  bool hasImage;
                  if (index == 0) {
                    newsTitle = 'Juan Perez';
                    newsSubtitle =
                        'Apuñalaron a un menor en el parque Sarmiento para robarle el télefono. El chico fue llevado al hospital en grave estado.';
                    hasImage = false;
                  } else if (index == 1) {
                    newsTitle = 'Tobias Gonzales';
                    newsSubtitle =
                        'Entraron a robar un negocio en la calle Sobremonte. Rompieron todos los vidrios para poder ingresar. Cortaron la calle.';
                    hasImage = true;
                  } else {
                    newsTitle = 'Ariel Molina';
                    newsSubtitle =
                        'Muere Marta Perez, la señora que había sido internada después que la tiraron de la moto para robarle.';
                    hasImage = true;
                  }

                  Widget leadingWidget = Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                  );
                  Widget imageWidget = hasImage
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48.0),
                          child: Container(
                            height: 155,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.black),
                            ),
                            margin:
                                const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          ),
                        )
                      : SizedBox();

                  return InkWell(
                    onTap: () {
                      // Navegar a CommunityPostScreen cuando se toque el ListTile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityPostScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: leadingWidget,
                            title: Text(
                              newsTitle,
                              style: TextStyle(
                                  color: AppColors.waterGreen400,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0),
                            ),
                            subtitle: Text(
                              newsSubtitle,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          imageWidget,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Icon(Icons.notifications, color: Colors.white),
        backgroundColor: AppColors.waterGreen400,
      ),
    );
  }
}
