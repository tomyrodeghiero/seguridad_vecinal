import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/models/notification_model.dart';
import 'package:seguridad_vecinal/screens/notification_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: '1',
      title: 'Alerta de robo',
      subtitle:
          'Juliana te envió una alarma el 10/12/23. Incluye ubicación y un audio de 20 seg. Sólo mantén la calma y espera que ya hemos contactado a las autoridades.',
      date: '10/12/23',
    ),
    NotificationModel(
      id: '2',
      title: 'Incidente cercano: ROBO',
      subtitle:
          'Se ha reportado un robo en zona Banda Norte: San Luis 121. Hace 5 minutos...',
      date: '13/12/23',
    ),
    NotificationModel(
      id: '2',
      title: 'Alerta de peligro',
      subtitle: 'Has entrado en zona roja de peligro...',
      date: '12/12/23',
    ),
    NotificationModel(
      id: '2',
      title: 'Alerta de disparos',
      subtitle:
          'Se ha reportado en tu comunidad: Banda Norte que se han oído sonidos de disparos.',
      date: '11/12/23',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.waterGreen400,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Notificaciones',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 28.0),
            onPressed: () {},
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
    return ListTile(
      title: Text(
        notification.title ?? 'Sin título',
        style: TextStyle(
            color: AppColors.waterGreen400, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        notification.subtitle ?? 'No hay descripción.',
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.waterGreen400),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NotificationDetailScreen(notification: notification),
          ),
        );
      },
    );
  }
}
