import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/models/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  NotificationDetailScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Notificaciones',
                style: TextStyle(
                    fontSize: 22.0,
                    color: AppColors.purple500,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Image.asset(
            'assets/back-arrow-colored.png',
            height: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/notifications.png',
                height: 24.0,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? 'Sin título',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.purple500,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              notification.subtitle ?? 'Sin descripción.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                height: 1.25,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 225.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: AppColors.purple500,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 64.0,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/play.png',
                      height: 24.0,
                    ),
                    onPressed: () {},
                  ),
                  Row(
                    children: List.generate(
                        14,
                        (index) => Icon(Icons.more_vert,
                            size: 15, color: AppColors.purple500)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '0:20',
                      style: TextStyle(
                          color: AppColors.purple500,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
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
      floatingActionButton: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(
            'Eliminar',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.purple500,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
