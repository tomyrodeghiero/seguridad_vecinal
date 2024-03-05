import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/screens/notification_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final List<String> images;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.images,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail != null) {
      final response = await http.get(
        Uri.parse(
            'http://192.168.88.138:5001/api/get-unread-notifications?email=$userEmail'),
      );

      if (response.statusCode == 200) {
        List<dynamic> notificationsJson = json.decode(response.body);
        setState(() {
          notifications = notificationsJson
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        });
      } else {
        print('Error fetching notifications: ${response.statusCode}');
      }
    }
  }

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
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            notification: notifications[index],
            context: context,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required NotificationModel notification,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0), // Añade padding inferior
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey[300]!, width: 1.0), // Añade borde inferior
        ),
      ),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
              color: AppColors.purple500,
              fontWeight: FontWeight.w600,
              fontSize: 22.0),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
              top:
                  8.0), // Añade un poco de espacio entre el título y la descripción
          child: Text(
            notification.description,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                height: 1.25),
          ),
        ),
        trailing: Image.asset(
          'assets/next-arrow-colored.png',
          height: 24,
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetailScreen(notification: notification),
            ),
          );

          if (result == true) {
            _fetchNotifications();
          }
        },
      ),
    );
  }
}
