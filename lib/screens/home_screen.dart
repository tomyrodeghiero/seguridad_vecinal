import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/components/custom_drawer.dart';
import 'package:seguridad_vecinal/screens/community_post_screen.dart';
import 'package:seguridad_vecinal/screens/notifications_screen.dart';
import 'package:seguridad_vecinal/screens/post_screen.dart';

class HomeScreen extends StatelessWidget {
  String getAvatarAsset(int index) {
    switch (index) {
      case 0:
        return 'assets/avatar-01.png';
      case 1:
        return 'assets/avatar-02.png';
      case 2:
        return 'assets/avatar-03.png';
      default:
        return 'assets/avatar-01.png';
    }
  }

  String getImageAsset(int index) {
    switch (index) {
      case 1:
        return 'assets/image-01.png';
      case 2:
        return 'assets/image-02.png';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/cori.png', width: 32.0, height: 32.0),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/notifications.png',
                width: 24.0, height: 24.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Noticias de Río Cuarto',
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
                  String imageAsset = getImageAsset(index);
                  bool hasImage = imageAsset.isNotEmpty;
                  if (index == 0) {
                    newsTitle = 'Juan Perez';
                    newsSubtitle =
                        'Apuñalaron a un menor en el parque Sarmiento para robarle el télefono. El chico fue llevado al hospital en grave estado.';
                  } else if (index == 1) {
                    newsTitle = 'Tobias Gonzales';
                    newsSubtitle =
                        'Entraron a robar un negocio en la calle Sobremonte. Rompieron todos los vidrios para poder ingresar. Cortaron la calle.';
                  } else {
                    newsTitle = 'Ariel Molina';
                    newsSubtitle =
                        'Muere Marta Perez, la señora que había sido internada después que la tiraron de la moto para robarle.';
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityPostScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: index > 0
                              ? Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: Colors
                                          .grey), // Solo el primer elemento tendrá borde superior
                                ) // No aplica ningún borde si el índice es mayor que 0
                              : null),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(getAvatarAsset(
                                      index)), // Usa la función para obtener el avatar
                                  radius: 18,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        newsTitle,
                                        style: TextStyle(
                                          color: AppColors.purple500,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        newsSubtitle,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (hasImage)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 48.0, top: 8.0, right: 16.0),
                                child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: Image.asset(
                                      imageAsset,
                                      fit: BoxFit.cover,
                                      height: 160.0,
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 48.0, top: 12.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/cori.png',
                                      width: 20, height: 20),
                                  SizedBox(width: 8),
                                  Text('209',
                                      style: TextStyle(color: Colors.black)),
                                  SizedBox(width: 16),
                                  Image.asset('assets/marker.png',
                                      width: 20, height: 20),
                                  SizedBox(width: 8),
                                  Text('107',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
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
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Image.asset(
          'assets/note.png',
          height: 26.0,
        ),
        backgroundColor: AppColors.purple500,
      ),
    );
  }
}
