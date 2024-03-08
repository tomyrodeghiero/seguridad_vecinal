import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:cori/screens/community_post_screen.dart';
import 'package:cori/screens/notifications_screen.dart';
import 'package:cori/screens/post_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Report {
  final String title;
  final List<String> message;
  final String neighborhood;
  final DateTime timestamp;
  final List<String> images;
  final String senderEmail;
  final String senderProfileImage;
  final String senderFullName;
  String selectedReaction;
  int reactionCount = 0;

  Report({
    required this.title,
    required this.message,
    required this.neighborhood,
    required this.timestamp,
    required this.images,
    required this.senderEmail,
    required this.senderProfileImage,
    required this.senderFullName,
    this.selectedReaction = 'assets/reaction-03.png',
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    var messageData = json['message'];
    List<String> messageList;
    if (messageData is String) {
      messageList = [messageData];
    } else if (messageData is List) {
      messageList = List<String>.from(messageData);
    } else {
      messageList = [];
    }

    return Report(
      title: json['title'] ?? 'Título predeterminado',
      message: messageList,
      neighborhood: json['neighborhood'] ?? 'Barrio predeterminado',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      senderEmail: json['senderEmail'] ?? 'correo@predeterminado.com',
      senderProfileImage: json['senderProfileImage'] ?? '',
      senderFullName: json['senderFullName'] ?? '',
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _fullName = '';
  String _imageUrl = '';

  bool _isReactionBarVisible =
      false; // New state to control the visibility of the reaction bar
  String _selectedReaction = 'assets/reaction-03.png';

  void _toggleReactionBar() {
    setState(() {
      _isReactionBarVisible = !_isReactionBarVisible;
    });
  }

  void _selectReaction(String reaction, Report report) {
    setState(() {
      report.selectedReaction = reaction;
      report.reactionCount = 1; // Establece el contador de reacciones a 1
    });
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  List<Report> reports = [];

  Future<void> fetchReports() async {
    setState(() {
      _isLoading = true; // Indica que la carga de datos ha comenzado
    });

    try {
      final response = await http
          .get(Uri.parse('https://cori-backend.vercel.app/api/get-reports'));

      if (response.statusCode == 200) {
        List<dynamic> reportsJson = json.decode(response.body);
        setState(() {
          reports = reportsJson.map((json) => Report.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        print('Failed to load reports: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Caught error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen()),
    );

    if (result == true) {
      fetchReports();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchReports();
  }

  Widget _buildBody() {
    if (_isLoading) {
      // Si está cargando, muestra el indicador de actividad
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Si los datos ya se cargaron, muestra la lista de reportes
      return ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          Report report = reports[index];
          String fullmessage = report.message.join(" ");

          String firstImage = report.images.isNotEmpty ? report.images[0] : '';

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityPostScreen(
                    senderEmail: report.senderEmail,
                    title: report.title,
                    message: report.message,
                    images: report.images,
                    timestamp: report.timestamp,
                    senderProfileImage: report.senderProfileImage,
                    senderFullName: report.senderFullName,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  border: index > 0
                      ? Border(
                          top: BorderSide(width: 1.0, color: Colors.grey),
                        )
                      : null),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(report.senderProfileImage),
                          radius: 18,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.senderFullName,
                                style: TextStyle(
                                  color: AppColors.purple500,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                fullmessage, // Usa la descripción completa
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (report.images.isNotEmpty) // Verifica si hay imágenes
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 48.0, top: 8.0, right: 16.0),
                        child: FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.network(
                              // Cambiado a Image.network para cargar imágenes de la red
                              firstImage,
                              fit: BoxFit.cover,
                              height: 164.0,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, top: 12.0),
                      child: Row(
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              _selectReaction(value,
                                  report); // Asegúrate de pasar el reporte correcto como argumento
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // Distribuye los ítems uniformemente en el eje horizontal
                                      children:
                                          List<Widget>.generate(5, (int index) {
                                        Widget image = Image.asset(
                                            'assets/reaction-0${index + 1}.png',
                                            width: 32);

                                        // Decide si aplicar padding basado en la condición del índice o la ruta de la imagen
                                        return 'assets/reaction-0${index + 1}.png' !=
                                                'assets/reaction-01.png'
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(left: 12.0),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.of(context).pop(
                                                          'assets/reaction-0${index + 1}.png'),
                                                  child: image,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context).pop(
                                                        'assets/reaction-0${index + 1}.png'),
                                                child: image,
                                              );
                                      }),
                                    ),
                                  ),
                                ),
                              ];
                            },
                            child: Image.asset(report.selectedReaction,
                                width: 24.0, height: 24.0),
                          ),
                          if (report.reactionCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // Añade padding aquí
                              child: Text(
                                '${report.reactionCount}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          SizedBox(width: 16.0),
                          Image.asset('assets/marker.png',
                              width: 20, height: 20),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

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
            Image.asset('assets/cori.png', width: 32.0, height: 32.0),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/notifications.png',
                width: 24.0, height: 24.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        fullName: _fullName,
        imageUrl: _imageUrl,
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
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
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
              child: _buildBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Image.asset(
          'assets/note.png',
          height: 26.0,
        ),
        backgroundColor: AppColors.purple500,
      ),
    );
  }
}
