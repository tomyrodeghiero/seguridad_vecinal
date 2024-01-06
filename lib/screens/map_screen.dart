import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Importar latlong2

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center:
              LatLng(-33.1232, -64.3493), // Coordenadas de Río Cuarto, Córdoba
          zoom: 13.0,
          interactiveFlags: InteractiveFlag.pinchZoom |
              InteractiveFlag.drag, // Habilitar zoom y arrastre
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                    -33.1232, -64.3493), // Coordenadas de Río Cuarto, Córdoba
                width: 80.0,
                height: 80.0,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
