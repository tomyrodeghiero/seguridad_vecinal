import 'package:cori/components/custom_bottom_nav_bar.dart';
import 'package:cori/screens/community_screen.dart';
import 'package:cori/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';

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
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> markers = [];
  List<Polygon> riskZones = [];
  MapContentType _contentType = MapContentType.none;
  List<CircleMarker> circleMarkers = [];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CommunityScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _loadNeighborhoodReports() {
    if (_contentType == MapContentType.neighborhoodReports) {
      _clearMap();
      return;
    }

    setState(() {
      markers = [];
      riskZones = [];
      circleMarkers = [];

      List<String> titles = ["Microcentro", "Banda Norte", "Alberdi", "Bimaco"];
      List<int> reports = [20, 10, 15, 25];

      List<Color> colors = [
        Colors.green,
        Colors.amberAccent,
        Colors.orange,
        Colors.red
      ];

      List<LatLng> reportLocations = [
        LatLng(-33.1232, -64.3493),
        LatLng(-33.1132, -64.3293),
        LatLng(-33.1347184, -64.3512701),
        LatLng(-33.1369584, -64.3713441),
      ];

      circleMarkers = reportLocations.asMap().entries.map((entry) {
        int idx = entry.key;
        LatLng loc = entry.value;

        return CircleMarker(
          point: loc,
          color: colors[idx].withOpacity(0.5),
          borderColor: colors[idx],
          borderStrokeWidth: 1,
          radius: 60,
        );
      }).toList();

      markers.addAll(reportLocations.asMap().entries.map((entry) {
        int idx = entry.key;
        LatLng loc = entry.value;

        return Marker(
          width: 200.0,
          height: 80.0,
          point: loc,
          child: Container(
              alignment: Alignment.center,
              child: FittedBox(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${titles[idx]}\n",
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
                        text: "${reports[idx]} reportes",
                        style: TextStyle(
                          backgroundColor: colors[idx],
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
              )),
        );
      }).toList());

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
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: CustomDrawer(),
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
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ));
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
