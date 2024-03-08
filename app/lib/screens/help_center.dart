import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';

class HelpModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final List<String> images;

  HelpModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.images,
  });

  factory HelpModel.fromJson(Map<String, dynamic> json) {
    return HelpModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  List<HelpModel> notifications = [];
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
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      notifications = [
        HelpModel(
          id: "1",
          title: "Permisos Sociales",
          message:
              "Usar información de los sitios que visitas para mejorar los anuncios.",
          date: "2024-03-07",
          images: [], // Aquí se pueden poner enlaces a las imágenes si es necesario.
        ),
        HelpModel(
          id: "2",
          title: "Seguridad",
          message: "Activa las notificaciones",
          date: "2024-03-06",
          images: [],
        ),
        HelpModel(
          id: "3",
          title: "Sonidos de la aplicación",
          message: "Solo tus seguidores actuales podrán ver tus publicaciones.",
          date: "2024-03-05",
          images: [],
        ),
        HelpModel(
          id: "4",
          title: "Preferencias",
          message:
              "Mostrar fotos y videos que puedan incluir contenido delicado.",
          date: "2024-03-04",
          images: [],
        ),
        HelpModel(
          id: "5",
          title: "Eliminar datos de cuenta",
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
            Text('Centro de Ayuda',
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
                'assets/help-center-icon.png',
                height: 28.0,
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
              "¿En qué podemos ayudarte? Si deseas reportar un problema o una consulta escribelo a continuación...",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Escribe tus dudas aquí...",
                hintStyle: TextStyle(
                  color: AppColors.purple500, // Color del texto del placeholder
                ),
                filled: true, // Relleno de color
                fillColor:
                    Colors.white, // Color de fondo del campo de texto blanco
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.purple500, // Borde color púrpura
                  ),
                  borderRadius:
                      BorderRadius.circular(30.0), // Bordes redondeados
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.purple500), // Borde color púrpura
                  borderRadius:
                      BorderRadius.circular(30.0), // Bordes redondeados
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.purple500,
                      width:
                          1), // Borde color púrpura más grueso cuando el campo está enfocado
                  borderRadius:
                      BorderRadius.circular(30.0), // Bordes redondeados
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    // Acción cuando se toca el icono de búsqueda
                  },
                  child: Container(
                    padding:
                        EdgeInsets.all(8.0), // Espaciado dentro del Container

                    child: Image.asset(
                      'assets/search.png', // Asegúrate de que la ruta de la imagen sea correcta
                      width: 8,
                      height: 8,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal:
                        20.0), // Padding interno para texto dentro del TextField
              ),
            ),
          ),
        ],
      ),
    );
  }
}
