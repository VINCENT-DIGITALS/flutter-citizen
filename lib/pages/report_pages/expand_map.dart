import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FullMapPage extends StatelessWidget {
  final LatLng? reportLocation;

  const FullMapPage({
    Key? key,
    required this.reportLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: reportLocation ?? LatLng(15.7140846, 120.9001115), // Default center

        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app', // Replace with your app package name
          ),
        ],
      ),
    );
  }
}
