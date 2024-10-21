import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import 'map/map_page.dart';

class EvacuationMapPage extends StatefulWidget {
  const EvacuationMapPage({super.key});

  @override
  _EvacuationMapPageState createState() => _EvacuationMapPageState();
}

class _EvacuationMapPageState extends State<EvacuationMapPage> {
  Position? _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocationService _locationService =
      LocationService(); // Instantiate the LocationService

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position? position = await _locationService.requestLocation();
      if (position != null) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Evacuation Map'),
        ),
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Science City of Muñoz Evacuation Map',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildHotlineCard(
              context,
              iconColor: Colors.red,
              title: 'Philippine National Police',
              subtitle: 'Science City of Muñoz, Nueva Ecija, Region 3',
              evacuationCoords:
                  const LatLng(15.693981350512871, 120.89656454006607),
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.orange,
              title: 'Bureau of Fire Protection',
              subtitle: 'Science City of Muñoz, Nueva Ecija, Region 3',
              evacuationCoords:
                  const LatLng(15.71886360208975, 120.91798922839145),
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.green,
              title: 'Disaster Risk Reduction Management',
              subtitle: 'Science City of Muñoz, Nueva Ecija, Region 3',
              evacuationCoords:
                  const LatLng(15.71499689773736, 120.91149533088418),
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.purple,
              title: 'OSLAM',
              subtitle: 'Requesting Help',
              evacuationCoords:
                  const LatLng(15.71133310812903, 120.90737920683065),
            ),
            // Add more hotline cards as needed
          ],
        ),
        bottomNavigationBar: const BottomNavBar(currentPage: 'Hotlines'),
      ),
    );
  }

  Widget _buildHotlineCard(
    BuildContext context, {
    required Color iconColor,
    required String title,
    required String subtitle,
    required LatLng evacuationCoords,
  }) {
    double? distance;

    // Check if the current position is available to calculate the distance
    bool isLocationAvailable = _currentPosition != null;

    if (isLocationAvailable) {
      final Distance distanceCalculator = Distance();
      final LatLng currentLocation =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      distance = distanceCalculator.as(
          LengthUnit.Kilometer, currentLocation, evacuationCoords);
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor,
          child: Text(
            title[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: isLocationAvailable
            ? Text(
                '${distance?.toStringAsFixed(2)} km', // Display the calculated distance
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth:
                        2.0), // Show loading spinner when distance is unavailable
              ),
        onTap: () {
          // Allow navigation even if location is still loading
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvacuationPlaceMapPage(
                locationName: title,
                evacuationCoords: evacuationCoords,
              ),
            ),
          );
        },
      ),
    );
  }
}
