import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/screens/notification_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final List<String> images;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.images,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
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
  bool _isLoading = true; // Añade esta línea

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true; // Indica que la carga de datos ha comenzado
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail != null) {
      final response = await http.get(
        Uri.parse('https://cori-backend.vercel.app/api/get-reports'),
      );

      setState(() {
        _isLoading = false; // Indica que la carga de datos ha finalizado
        if (response.statusCode == 200) {
          List<dynamic> reportsJson = json.decode(response.body);
          notifications = reportsJson
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        } else {
          print('Error fetching reports: ${response.statusCode}');
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
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
                    fontWeight: FontWeight.w500)),
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
      body: _isLoading // Comprueba si está cargando
          ? Center(child: CircularProgressIndicator()) // Muestra el indicador
          : ListView.builder(
              // De lo contrario, muestra la lista
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
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              height: 1.15),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
              top:
                  4.0), // Añade un poco de espacio entre el título y la descripción
          child: Text(
            notification.message,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                height: 1.25),
          ),
        ),
        trailing: Image.asset(
          'assets/next-arrow.png',
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
