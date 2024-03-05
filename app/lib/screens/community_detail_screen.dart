import 'package:cori/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:cori/screens/community_post_screen.dart';
import 'package:cori/screens/post_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CommunityDetailScreen extends StatefulWidget {
  final String neighborhoodName;
  final int memberCount;

  CommunityDetailScreen(
      {required this.neighborhoodName, required this.memberCount});

  @override
  _CommunityDetailScreenState createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  String _fullName = '';
  String _imageUrl = '';
  bool _isJoined = false;
  int _currentMemberCount = 0;
  bool _originalIsJoinedState = false;

  Future<void> joinNeighborhood(
      String userEmail, String neighborhoodName) async {
    final url = Uri.parse('http://192.168.88.138:5001/api/join-neighborhood');
    final response = await http.post(url,
        body: jsonEncode({
          'userEmail': userEmail,
          'neighborhood': neighborhoodName,
        }),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      setState(() {
        _isJoined = true;
        _originalIsJoinedState = true;
        _currentMemberCount += 1;
      });

      Fluttertoast.showToast(
          msg: "Te has unido exitosamente al vecindario.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Error al unirse al vecindario. Intenta de nuevo.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String _userEmail = ''; // Añade esta línea

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
      _userEmail =
          prefs.getString('userEmail') ?? ''; // Carga el correo electrónico
    });
  }

  Future<void> checkMembership() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');

    final url = Uri.parse(
        'http://192.168.88.138:5001/api/check-membership?userEmail=$userEmail&neighborhood=${widget.neighborhoodName}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      setState(() {
        _isJoined = responseBody['isJoined'];
      });
    } else {
      Fluttertoast.showToast(
          msg: "Error al verificar la membresía. Intenta de nuevo.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    _currentMemberCount = widget.memberCount;
    _originalIsJoinedState = _isJoined;
    _loadUserData().then((_) {
      checkMembership();
    });
    fetchReports();
  }

  String getImagePathForNeighborhood(String neighborhood) {
    switch (neighborhood) {
      case 'Banda Norte':
        return 'assets/banda-norte.png';
      case 'Alberdi':
        return 'assets/alberdi.png';
      case 'Bimaco':
        return 'assets/bimaco.png';
      case 'Barrio Jardín':
        return 'assets/barrio-jardin.png';
      case 'Micro centro':
        return 'assets/micro-centro.png';
      default:
        return 'assets/otro-barrio.png';
    }
  }

  Future<void> fetchReports() async {
    print('Fetching reports...');
    final response = await http.get(Uri.parse(
        'http://192.168.88.138:5001/api/get-reports-by-neighborhood?neighborhood=${Uri.encodeComponent(widget.neighborhoodName)}'));

    if (response.statusCode == 200) {
      List<dynamic> reportsJson = json.decode(response.body);
      setState(() {
        reports = reportsJson.map((json) => Report.fromJson(json)).toList();
      });
    } else {
      print('Failed to load reports: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String neighborhoodImagePath =
        getImagePathForNeighborhood(widget.neighborhoodName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: Image.asset(
            'assets/back-arrow.png',
            height: 24.0,
          ),
          onPressed: () {
            if (_originalIsJoinedState == true) {
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
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
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 14.0,
              ),
              child: Row(
                children: [
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: AssetImage(neighborhoodImagePath),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.neighborhoodName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: AppColors.purple500),
                        ),
                        Text(
                          '${_currentMemberCount} miembros',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          height: 28.0,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              if (!_isJoined) {
                                joinNeighborhood(
                                    _userEmail, widget.neighborhoodName);
                              }
                            },
                            label: Text(
                              _isJoined ? 'Unido' : 'Unirme',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            elevation: 0,
                            backgroundColor: _isJoined
                                ? AppColors.turquoiseBlue500
                                : AppColors.purple500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                'Noticias',
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
                                  SizedBox(width: 8),
                                  Text('209',
                                      style: TextStyle(color: Colors.black)),
                                  SizedBox(width: 16),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
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
