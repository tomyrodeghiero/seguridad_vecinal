import 'dart:convert';

import 'package:cori/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
              notification.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.purple500,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                height: 1.25,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              children: notification.images.map((image) {
                return Container(
                  height: 225.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double
                            .infinity, // Hace que la imagen se expanda para ocupar el ancho disponible
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String? userEmail = prefs.getString('userEmail');

            if (userEmail != null) {
              final response = await http.post(
                Uri.parse(
                    'https://cori-backend.vercel.app/api/mark-notification-read'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'notificationId': notification.id,
                  'userEmail': userEmail,
                }),
              );

              if (response.statusCode == 200) {
                Navigator.of(context).pop(true);
              } else {
                print('Error marcando la notificación como leída');
              }
            }
          },
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
