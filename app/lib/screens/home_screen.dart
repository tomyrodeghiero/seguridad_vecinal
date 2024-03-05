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
  final List<String> description;
  final String neighborhood;
  final DateTime timestamp;
  final List<String> images;
  final String senderEmail;
  final String senderProfileImage;
  final String senderFullName;

  Report({
    required this.title,
    required this.description,
    required this.neighborhood,
    required this.timestamp,
    required this.images,
    required this.senderEmail,
    required this.senderProfileImage,
    required this.senderFullName,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    var descriptionData = json['description'];
    List<String> descriptionList;
    if (descriptionData is String) {
      descriptionList = [descriptionData];
    } else if (descriptionData is List) {
      descriptionList = List<String>.from(descriptionData);
    } else {
      descriptionList = [];
    }

    return Report(
      title: json['title'] ?? 'Título predeterminado',
      description: descriptionList,
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
  String _fullName = '';
  String _imageUrl = '';

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  List<Report> reports = [];

  Future<void> fetchReports() async {
    print('Fetching reports...');
    final response = await http
        .get(Uri.parse('https://cori-backend.vercel.app/api/get-reports'));

    if (response.statusCode == 200) {
      List<dynamic> reportsJson = json.decode(response.body);
      setState(() {
        reports = reportsJson.map((json) => Report.fromJson(json)).toList();
      });
    } else {
      print('Failed to load reports: ${response.statusCode}');
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
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  Report report = reports[index];
                  String fullDescription =
                      report.description.join(" "); // Une las descripciones

                  String firstImage =
                      report.images.isNotEmpty ? report.images[0] : '';

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityPostScreen(
                            senderEmail: report.senderEmail,
                            title: report.title,
                            description: report.description,
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
                                  top: BorderSide(
                                      width: 1.0, color: Colors.grey),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        fullDescription, // Usa la descripción completa
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
                            if (report
                                .images.isNotEmpty) // Verifica si hay imágenes
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
                              padding:
                                  const EdgeInsets.only(left: 48.0, top: 12.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/cori.png',
                                      width: 20, height: 20),
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
              ),
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
