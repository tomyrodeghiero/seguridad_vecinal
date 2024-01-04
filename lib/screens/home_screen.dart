import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class HomeScreen extends StatelessWidget {
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
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColors.waterGreen400,
                shape: BoxShape.circle,
              ),
            ),
          ],
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
                              onPressed: () {},
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
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

                  return Container(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: AppColors.waterGreen400),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on, color: AppColors.waterGreen400),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language, color: AppColors.waterGreen400),
              label: '',
            ),
          ],
          selectedItemColor: AppColors.waterGreen400,
          unselectedItemColor: Colors.grey[100],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Icon(Icons.notifications, color: Colors.white),
        backgroundColor: AppColors.waterGreen400,
      ),
    );
  }
}
