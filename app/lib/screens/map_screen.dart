import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final url = Uri.parse('http://127.0.0.1:5001/api/get-reports-summary');
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
      LatLng(-33.130668, -64.347334),
      LatLng(-33.1234, -64.3405),
      LatLng(-33.1152, -64.3496),
      LatLng(-33.1283, -64.3427),
    ];

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      markers = policeStationLocations
          .map((location) => Marker(
                point: location,
                width: 40.0,
                height: 40.0,
                child: Image.asset(
                  'assets/police-station-pin.png',
                ),
              ))
          .toList();
      riskZones = [];
      _contentType = MapContentType.policeStations;
    });
  }

  void _loadHealthLocations() {
    if (_contentType == MapContentType.healthStations) {
      _clearMap();
      return;
    }

    List<LatLng> healthLocations = [
      LatLng(-33.1092818, -64.3580956),
      LatLng(-33.1291435, -64.3561459),
    ];

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      markers = healthLocations
          .map((location) => Marker(
                point: location,
                width: 40.0,
                height: 40.0,
                child: Image.asset(
                  'assets/health-pin.png',
                ),
              ))
          .toList();
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
