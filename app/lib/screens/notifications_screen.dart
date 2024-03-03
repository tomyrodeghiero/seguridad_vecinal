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
    return ListTile(
      title: Text(
        notification.title ?? 'Sin título',
        style: TextStyle(
            color: AppColors.purple500,
            fontWeight: FontWeight.w600,
            fontSize: 22.0),
      ),
      subtitle: Text(
        notification.subtitle ?? 'No hay descripción.',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            height: 1.25),
      ),
      trailing: Image.asset(
        'assets/next-arrow-colored.png', // Asegúrate de que este path sea correcto
        height:
            24, // Ajusta la altura para alinearla con el título según sea necesario
      ),
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
