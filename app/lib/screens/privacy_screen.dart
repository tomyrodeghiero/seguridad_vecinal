import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';

class PrivacyModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final List<String> images;

  PrivacyModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.images,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  List<PrivacyModel> notifications = [];
  Set<String> selectedIds =
      Set(); // Set para mantener los IDs de las opciones seleccionadas.

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  Future<void> _fetchNotifications() async {
    // Simulamos una pequeña demora para imitar la carga de datos
    await Future.delayed(
        Duration(seconds: 0)); // Cambiado a 1 segundo para simular la carga

    setState(() {
      notifications = [
        PrivacyModel(
          id: "1",
          title: "Datos de visitas",
          message:
              "Usar información de los sitios que visitas para mejorar los anuncios.",
          date: "2024-03-07",
          images: [],
        ),
        PrivacyModel(
          id: "2",
          title: "Notificaciones",
          message: "Activa las notificaciones",
          date: "2024-03-06",
          images: [],
        ),
        PrivacyModel(
          id: "3",
          title: "Proteger las publicaciones",
          message: "Solo tus seguidores actuales podrán ver tus publicaciones.",
          date: "2024-03-05",
          images: [],
        ),
        PrivacyModel(
          id: "4",
          title: "Preferencias",
          message:
              "Mostrar fotos y videos que puedan incluir contenido delicado.",
          date: "2024-03-04",
          images: [],
        ),
        PrivacyModel(
          id: "5",
          title: "Ubicación",
          message:
              "Si activas esta opción, podrás ver lo que sucede a tu alrededor en este momento.",
          date: "2024-03-03",
          images: [],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Privacidad',
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
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/privacy-icon.png',
                height: 24.0,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              "Modifica la información de tu cuenta",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            // Agrega Expanded para ocupar el espacio restante
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                var isSelected = selectedIds.contains(notification.id);
                return _buildNotificationItem(
                  notification: notification,
                  context: context,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required PrivacyModel notification,
    required BuildContext context,
    required bool isSelected, // Añade este parámetro.
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
        trailing: isSelected
            ? Image.asset(
                'assets/check-colored.png', // Usa la imagen de check coloreado si está seleccionado.
                height: 24,
              )
            : Image.asset(
                'assets/check.png', // Usa la imagen de check coloreado si está seleccionado.
                height: 24,
              ), // Usa un widget vacío si no está seleccionado.

        onTap: () {
          _toggleSelection(notification
              .id); // Cambia el estado de selección cuando se toca el ítem.
        },
      ),
    );
  }
}
