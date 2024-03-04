import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cori/colors.dart';

class CommunityPostScreen extends StatelessWidget {
  final String senderEmail;
  final String title;
  final String description;
  final List<String> images;
  final DateTime timestamp;

  CommunityPostScreen({
    required this.senderEmail,
    required this.title,
    required this.description,
    required this.images,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back-arrow.png',
            height: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Post Comunidad',
          style: TextStyle(
              color: AppColors.purple500,
              fontWeight: FontWeight.w600,
              fontSize: 22.0),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey),
          )),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/avatar-01.png'), // Usa la función para obtener el avatar
                      radius: 18,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            senderEmail,
                            style: TextStyle(
                              color: AppColors.purple500,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 48.0,
                      top: 8.0,
                      right: 16.0), // Agrega padding a la derecha también
                  child: FractionallySizedBox(
                    widthFactor:
                        1.0, // El ancho de la imagen será el 90% del ancho del contenedor
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(40.0), // Borde redondeado
                      child: Image.asset(
                        'assets/image-01.png',
                        fit: BoxFit.cover,
                        height: 164.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 48.0, top: 12.0, right: 20.0),
                  child: Row(
                    children: [
                      Image.asset('assets/cori.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('209', style: TextStyle(color: Colors.black)),
                      SizedBox(width: 16),
                      Image.asset('assets/marker.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('107', style: TextStyle(color: Colors.black)),
                      Spacer(), // Añade un espacio flexible entre los elementos y el texto de la fecha
                      Text('17:55',
                          style: TextStyle(
                              color: Colors.black)), // Aquí añades la hora
                      SizedBox(width: 8),
                      Text('19/12/23',
                          style: TextStyle(
                              color: Colors.black)), // Y aquí la fecha
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
