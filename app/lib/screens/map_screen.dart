import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

LatLng getLocationForNeighborhood(String neighborhood) {
  switch (neighborhood) {
    case 'Micro centro':
      return LatLng(-33.1232, -64.3493);
    case 'Banda Norte':
      return LatLng(-33.1132, -64.3293);
    case 'Alberdi':
      return LatLng(-33.1347184, -64.3512701);
    case 'Bimaco':
      return LatLng(-33.1369584, -64.3713441);
    case 'Barrio Jardín':
      return LatLng(-33.0897845, -64.3384708);
    default:
      return LatLng(-33.106862, -64.347241);
  }
}

class NeighborhoodReport {
  String neighborhood;
  int reportsCount;
  LatLng location;

  NeighborhoodReport({
    required this.neighborhood,
    required this.reportsCount,
    required this.location,
  });

  factory NeighborhoodReport.fromJson(Map<String, dynamic> json) {
    return NeighborhoodReport(
      neighborhood: json['neighborhood'],
      reportsCount: json['reportsCount'],
      location: getLocationForNeighborhood(json['neighborhood']),
    );
  }
}

class RiskZone {
  List<LatLng> points;
  bool isHighRisk;

  RiskZone(this.points, this.isHighRisk);
}

enum MapContentType {
  none,
  policeStations,
  riskZones,
  neighborhoodReports,
  healthStations
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _fullName = '';
  String _imageUrl = '';

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> markers = [];
  List<Polygon> riskZones = [];
  MapContentType _contentType = MapContentType.none;
  List<CircleMarker> circleMarkers = [];
  List<NeighborhoodReport> neighborhoodReports = [];

  Future<void> fetchNeighborhoodReports() async {
    final url =
        Uri.parse('https://cori-backend.vercel.app/api/get-reports-summary');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedReports = json.decode(response.body);
        setState(() {
          neighborhoodReports = fetchedReports
              .map((reportJson) => NeighborhoodReport.fromJson(reportJson))
              .toList();
        });
      } else {
        print('Failed to fetch neighborhood reports: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching neighborhood reports: $e');
    }
  }

  void _launchURL(String url) async {
    // Eliminar espacios en blanco al inicio y al final, así como los saltos de línea
    final String trimmedUrl = url
        .trim()
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll(' ', '');

    // Buscar la posición del emoji del teléfono y recortar el URL hasta ese punto
    final int emojiIndex = trimmedUrl.indexOf('📲');
    final String cleanedUrl =
        emojiIndex != -1 ? trimmedUrl.substring(0, emojiIndex) : trimmedUrl;

    // Intentar convertir el URL limpio a un Uri
    final Uri? uri = Uri.tryParse(cleanedUrl);

    if (uri != null && await canLaunchUrl(uri)) {
      // Si el Uri es válido y puede ser lanzado, hacerlo
      await launchUrl(uri);
    } else {
      // En caso de fallo, mostrar un mensaje de error
      print('Could not launch $cleanedUrl');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchNeighborhoodReports();
  }

  void _loadNeighborhoodReports() {
    if (_contentType == MapContentType.neighborhoodReports) {
      _clearMap();
      return;
    }

    final List<Color> levelColors = [
      Colors.red,
      Colors.amber,
      Colors.orange,
      Colors.lightGreen,
      Colors.green,
    ];

    neighborhoodReports
        .sort((a, b) => b.reportsCount.compareTo(a.reportsCount));

    Map<int, Color> reportsColorMapping = {};

    int previousReportsCount = -1;
    Color previousColor = Colors.grey;
    for (int i = 0; i < neighborhoodReports.length; i++) {
      final report = neighborhoodReports[i];
      if (report.reportsCount != previousReportsCount) {
        // Asignar color basado en la posición, si se excede la cantidad de colores definidos, usar el más intenso
        Color color =
            i < levelColors.length ? levelColors[i] : levelColors.last;
        reportsColorMapping[report.reportsCount] = color;
        previousColor = color;
      } else {
        // Si la cantidad de reportes es igual a la anterior, asignar gris
        reportsColorMapping[report.reportsCount] = Colors.grey;
        previousColor = Colors.grey;
      }
      previousReportsCount = report.reportsCount;
    }

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      for (var report in neighborhoodReports) {
        Color color = reportsColorMapping[report.reportsCount] ??
            Colors.grey; // Usar gris como color por defecto

        circleMarkers.add(
          CircleMarker(
            point: report.location,
            color: color.withOpacity(0.5),
            borderColor: color,
            borderStrokeWidth: 1,
            radius: 60, // O ajusta según la cantidad de reportes si prefieres
          ),
        );

        markers.add(
          Marker(
            width: 200.0,
            height: 80.0,
            point: report.location,
            child: Container(
              alignment: Alignment.center,
              child: FittedBox(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${report.neighborhood}\n",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: "${report.reportsCount} reportes",
                        style: TextStyle(
                          backgroundColor: color,
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              blurRadius: 3.0,
                              color: Colors.black,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      _contentType = MapContentType.neighborhoodReports;
    });
  }

  void _loadPoliceStations() {
    if (_contentType == MapContentType.policeStations) {
      _clearMap();
      return;
    }

    List<LatLng> policeStationLocations = [
      LatLng(-33.130668, -64.347334), // Comisaría Distrito Banda Norte
      LatLng(-33.1234, -64.3405), // Comisaría Distrito Alberdi
      LatLng(-33.1152, -64.3496), // Comisaría Distrito
      LatLng(-33.1283, -64.3427), // Policia de la Provincia de Córdoba
      LatLng(-33.1207, -64.3458), // Subcomisaria Bimaco
      LatLng(-33.1221, -64.3429), // Subcomisaria Abilene Río Cuarto
      LatLng(-33.1239, -64.3407), // Policia Federal Argentina DUOF Río Cuarto
      LatLng(-33.1245, -64.3461), // Cárcel Río Cuarto
    ];

    List<String> policeStationInfo = [
      "Comisaría Distrito Banda Norte📌🏢 República del Líbano, Banda Norte\n\n📍https://maps.app.goo.gl/7uGpWMmBb5NshSbBA\n\n📲 0358 467-2979",
      "Comisaría Distrito Alberdi📌🏢 Montevideo 349\n\n📍https://maps.app.goo.gl/Vr3wCK5YyR4WpCvm6\n\n📲0358 467-2901",
      "Comisaría Distrito Primera Policía de la Provincia de Córdoba📌🏢 Hipólito Irigoyen 2229, General Paz\n\n📍https://maps.app.goo.gl/De89SLGb2VQfdTNq5\n\n📲0358 467-2977",
      "Policia de la Provincia de Córdoba - Regional 9📌🏢 Belgrano 53\n\n📍https://maps.app.goo.gl/JVqf1VTu3skKsHNj9\n\n📲 0358 467-2960",
      "Subcomisaria Bimaco📌🏢 Carlos Gardel 1129\n\n📍https://maps.app.goo.gl/Dzn64PpBx9yffooj8\n\n📲0358 467-2976",
      "Subcomisaria Abilene Río Cuarto📌🏢 Diag. Cervantes 600-698\n\n📍https://maps.app.goo.gl/StszpjsECAAczUtj9\n\n📲 0358 467-2974",
      "Policia Federal Argentina DUOF Río Cuarto📌🏢Lamadrid 389, Centro\n\n📍https://maps.google.com/?cid=2544254673140317202&entry=gps\n\n📲 0358 462-1125",
      "Cárcel Río Cuarto📌🏢 Av. Amadeo Sabattini 2602\n\n📍https://maps.app.goo.gl/TTtVTumuHQ7i3YqD6\n\n📲 0358 462-1125",
    ];

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      for (int i = 0; i < policeStationLocations.length; i++) {
        markers.add(
          Marker(
            point: policeStationLocations[i],
            width: 40.0,
            height: 40.0,
            child: GestureDetector(
              onTap: () {
                final partsToTitle = policeStationInfo[i].split('📌');
                final parts = policeStationInfo[i].split('📍');
                final textPart =
                    parts[0]; // La parte del texto antes del enlace
                String url = parts.length > 1 ? parts[1] : '';
                final titlePart = partsToTitle[0];

                url = url.trim();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        titlePart,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.purple500),
                      ),
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: partsToTitle[1],
                              style: TextStyle(fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(url),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Image.asset(
                'assets/police-station-pin.png',
              ),
            ),
          ),
        );
      }

      _contentType = MapContentType.policeStations;
    });
  }

  void _loadHealthLocations() {
    if (_contentType == MapContentType.healthStations) {
      _clearMap();
      return;
    }

    List<LatLng> healthLocations = [
      LatLng(-33.1092863, -64.3555207), // Nuevo hospital San Antonio de Padua
      LatLng(-33.1246887, -64.3530677), // Policlínico Privado San Lucas S.A.
      LatLng(-33.1241, -64.34446), // Centro Médico Belgrano
      LatLng(-33.1273315, -64.3476349), // Instituto Médico Río Cuarto
      LatLng(-33.129148, -64.353571), // Centro de Salud Municipal
      LatLng(-33.1290756, -64.3514141), // Clínica Regional del Sud
      LatLng(-33.1285063, -64.3543394), // Mitre Centro Médico
      LatLng(-33.1092861, -64.3555162), // Fundacion Nuevo Hospital
      LatLng(-33.1492095, -64.3736118), // DISPENSARIO MUNICIPAL Nº 12
      LatLng(-33.1414993, -64.3723732), // Dispensario N° 7
      LatLng(-33.1168099, -64.3710536), // Dispensario 14
      LatLng(-33.1036653, -64.368604), // Dispensario N°5
      LatLng(-33.1024755, -64.3374442), // DISPENSARIO MUNICIPAL Nº 16
      LatLng(33.1066417, -64.3199496), // Dispensario 2
    ];

    List<String> healthLocationsInfo = [
      "Nuevo hospital San Antonio de Padua📌🏥 Guardias Nacionales 1027\n\n📍https://maps.app.goo.gl/6x3ZeoAVzThcksSv7?g_st=ic\n\n📲 0358 467-8700",
      "Policlínico Privado San Lucas S.A.📌🏥 Mitre 930\n\n📍https://maps.app.goo.gl/nDEHjKrT6tSqGJC46?g_st=ic\n\n📲0358 467-5600",
      "Centro Médico Belgrano📌🏥 Belgrano 387\n\n📍https://maps.app.goo.gl/hySD7cbWXkjU8QvZ8?g_st=ic\n\n📲0358 463-8093",
      "Instituto Médico Río Cuarto📌🏥 Hipólito Yrigoyen 1020\n\n📍https://maps.app.goo.gl/XjaKkRjZGBNM1Afp6?g_st=ic\n\n📲0810-444-4672",
      "Centro de Salud Municipal📌🏥 Cabrera 1344\n\n📍https://maps.app.goo.gl/N9VomHt8JGUMavETA?g_st=ic\n\n📲0358 476-8420",
      "Clínica Regional del Sud📌🏥 Av. Italia 1262\n\n📍https://maps.app.goo.gl/JmHKqRrmeA891zNb9?g_st=ic\n\n📲0358 467-9500",
      "Mitre Centro Médico📌🏥 Mitre 1288\n\n📍https://maps.app.goo.gl/SWogSuvcn9UVTLEd8?g_st=ic\n\n📲0358 462-5021",
      "Fundacion Nuevo Hospital📌🏥 Guardias Nacionales 1051\n\n📍https://maps.app.goo.gl/UyQ3A7Tn9hwWJU4k7?g_st=ic\n\n📲 0358 467-8722",
      "DISPENSARIO MUNICIPAL Nº 12📌🏥 Ing. Dinkeldein 3265\n\n📍https://maps.app.goo.gl/x1vzb8Mk7ZzZSbRM6?g_st=ic",
      "Dispensario N° 7📌🏥 Paso de los Andes 1224\n\n📍https://maps.app.goo.gl/mr41yGvigUTZ2PWq8?g_st=ic\n\n📲0358 476-8420",
      "Dispensario 14📌🏥 Leopoldo Lugones\n\n📍https://maps.app.goo.gl/WGYfDfQkuzYY1E1K9?g_st=ic",
      "Dispensario N°5📌🏥 Wenceslao Tejerina Nte. 502-600\n\n📍https://maps.app.goo.gl/PPMAfdMy5YVekFsT7?g_st=ic\n\n📲0358 467-1288",
      "Dispensario 2📌🏥 Av. General José Garibaldi\n\n📍https://maps.app.goo.gl/YHEYtSi1U31bVKoX8?g_st=ic\n\n📲0358 467-1285",
      "DISPENSARIO MUNICIPAL Nº 16📌🏥 Venezuela 809\n\n📍https://maps.app.goo.gl/9MGgSnokdYJetoUB9?g_st=ic"
    ];

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      for (int i = 0; i < healthLocations.length; i++) {
        markers.add(
          Marker(
            point: healthLocations[i],
            width: 40.0,
            height: 40.0,
            child: GestureDetector(
              onTap: () {
                final partsToTitle = healthLocationsInfo[i].split('📌');
                final parts = healthLocationsInfo[i].split('📍');
                final textPart = parts[0];
                String url = parts.length > 1 ? parts[1] : '';
                final titlePart = partsToTitle[0];

                url = url.trim();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        titlePart,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.purple500),
                      ),
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: partsToTitle[1],
                              style: TextStyle(fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(url),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Image.asset(
                'assets/health-pin.png',
              ),
            ),
          ),
        );
      }

      _contentType = MapContentType.healthStations;
    });
  }

  void _clearMap() {
    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];
      _contentType = MapContentType.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        fullName: _fullName,
        imageUrl: _imageUrl,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Mapa',
          style: TextStyle(
            fontSize: 22.0,
            color: AppColors.purple500,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-33.1232, -64.3493),
              zoom: 13.0,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolygonLayer(polygons: riskZones),
              CircleLayer(circles: circleMarkers),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
              bottom: 20.0,
              left: 20.0,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: AppColors.purple500,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 16.0,
                        children: [
                          _buildFloatingButton(
                            icon: Icons.warning_amber_rounded,
                            label: 'Reportes',
                            onTap: _loadNeighborhoodReports,
                            contentType: MapContentType.neighborhoodReports,
                          ),
                          _buildFloatingButton(
                            icon: Icons.local_police,
                            label: 'Comisarías',
                            onTap: _loadPoliceStations,
                            contentType: MapContentType.policeStations,
                          ),
                          _buildFloatingButton(
                            icon: Icons.local_hospital,
                            label: 'Salud',
                            onTap: _loadHealthLocations,
                            contentType: MapContentType.healthStations,
                          ),
                        ],
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required MapContentType contentType,
  }) {
    bool isSelected = _contentType == contentType;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.turquoiseBlue500 : null,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
