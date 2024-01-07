import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:seguridad_vecinal/colors.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  void _loadPoliceStations() {
    List<LatLng> policeStationLocations = [
      LatLng(-33.130668, -64.347334),
      LatLng(
          -33.1234, -64.3405), // Comisaría Distrito Nº 2, Rep. del Líbano 158
      LatLng(-33.1152, -64.3496), // Comisaría Distrito Nº 1, H. Yrigoyen 2229
      LatLng(-33.1283, -64.3427), // Comisaría Distrito Alberdi, Montevideo 349
    ];

    List<Marker> newMarkers = policeStationLocations.map((location) {
      return Marker(
        point: location,
        width: 30.0,
        height: 30.0,
        child: Icon(Icons.local_police, color: Colors.blue),
      );
    }).toList();

    setState(() {
      markers = newMarkers;
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
            fontSize: 20.0,
            color: AppColors.waterGreen400,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(
                  -33.1232, -64.3493), // Coordinates of Río Cuarto, Córdoba
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
              MarkerLayer(markers: markers), // Markers list
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: AppColors.waterGreen400,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFloatingButton(
                    icon: Icons.warning_amber_rounded,
                    label: 'Zonas de Riesgo',
                    onTap: () {},
                  ),
                  _buildFloatingButton(
                    icon: Icons.gavel,
                    label: 'Delitos',
                    onTap: () {},
                  ),
                  _buildFloatingButton(
                    icon: Icons.local_police,
                    label: 'Comisarías',
                    onTap: _loadPoliceStations, // Load police stations on tap
                  ),
                  _buildFloatingButton(
                    icon: Icons.local_hospital,
                    label: 'Salud',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24.0),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
