import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:citizen/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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
  final LocationService _locationService = LocationService();
  final List<Map<String, dynamic>> _evacuationLocations = [
    {
      'iconColor': Colors.red,
      'title': 'Bagong Sikat',
      'subtitle': 'Bagong Sikat Barangay Hall',
      'coords': const LatLng(15.737940096644945, 120.92345025553647),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Bical',
      'subtitle': 'Bical Barangay Hall',
      'coords': const LatLng(15.743414052724845, 120.90244796536255),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Bantug',
      'subtitle': 'Bantug Barangay Hall',
      'coords': const LatLng(15.720975797417958, 120.92010871535568),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Cabisuculan',
      'subtitle': 'QW37+CR8 Science City of Muñoz, Nueva Ecija',
      'coords': const LatLng(15.753540888416289, 120.91457924615241),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Calabalabaan',
      'subtitle': 'Calabalabaan Barangay Hall',
      'coords': const LatLng(15.703033379701347, 120.86435480794931),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Calisitan',
      'subtitle': 'Calisitan Barangay Hall',
      'coords': const LatLng(15.73116145808333, 120.85229518820877),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Catalanacan',
      'subtitle': 'Catalanacan Barangay Hall',
      'coords': const LatLng(15.713185427693757, 120.8855617887578),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Curva',
      'subtitle': 'Curva Covered Basketball Court',
      'coords': const LatLng(15.675117196100313, 120.85053788264668),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Franza',
      'subtitle': 'Franza Barangay Hall',
      'coords': const LatLng(15.754011738906701, 120.90488608119534),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Gabaldon',
      'subtitle': 'Gabaldon Barangay Hall - Gym',
      'coords': const LatLng(15.725862668555521, 120.87723405640517),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Labney',
      'subtitle': 'Labney Barangay Hall - Elementary School',
      'coords': const LatLng(15.69968622267189, 120.8487035396019),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Licaong',
      'subtitle': 'Licaong Barangay Hall',
      'coords': const LatLng(15.751363923416758, 120.94057593323006),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Linglingay',
      'subtitle': 'Linglingay Sangguniang Barangay Hall',
      'coords': const LatLng(15.766065566324107, 120.89073761818217),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Magtanggol',
      'subtitle': 'QW3J+G39 Science City of Muñoz, Nueva Ecija',
      'coords': const LatLng(15.753782801223027, 120.93023487935409),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Maligaya',
      'subtitle': 'Maligaya Baranggay Hall',
      'coords': const LatLng(15.67265962995459, 120.8896119535224),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Mangandingay',
      'subtitle': 'Mangandingay Barangay Hall',
      'coords': const LatLng(15.791250543324656, 120.88227697617819),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Mapangpang',
      'subtitle': 'Mapangpang Elementary School',
      'coords': const LatLng(15.805037304262983, 120.89770115303531),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Maragol',
      'subtitle': 'Maragol Multi-Purpose Covered Court',
      'coords': const LatLng(15.70506431997342, 120.95068352612428),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Matingkis',
      'subtitle': 'Matingkis (Muñoz) Barangay Hall',
      'coords': const LatLng(15.702807164650785, 120.88110230721142),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Naglabrahan',
      'subtitle': 'MRJP+F8G, Guimba, Nueva Ecija',
      'coords': const LatLng(15.681186345177252, 120.83582594827074),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Palusapis',
      'subtitle': 'Palusapis Barangay Hall',
      'coords': const LatLng(15.683311982806059, 120.8619361092253),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Poblacion East',
      'subtitle': 'Poblacion East Barangay Hall',
      'coords': const LatLng(15.712713284207158, 120.90576458419943),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Poblacion South',
      'subtitle': 'Poblacion South Baranggay Hall',
      'coords': const LatLng(15.718412045202038, 120.90564433792288),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Poblacion West',
      'subtitle': 'Poblacion West Barangay Hall',
      'coords': const LatLng(15.709189459309234, 120.90218682949437),
    },
    {
      'iconColor': Colors.orange,
      'title': 'San Andres',
      'subtitle': 'San Andres Barangay Hall',
      'coords': const LatLng(15.771488120048234, 120.92163076886794),
    },
    {
      'iconColor': Colors.orange,
      'title': 'San Antonio',
      'subtitle': 'San Antonio Barangay Hall',
      'coords': const LatLng(15.686410572719778, 120.85632856246322),
    },
    {
      'iconColor': Colors.orange,
      'title': 'San Felipe',
      'subtitle': 'QVFX+GGM Science City of Muñoz, Nueva Ecija',
      'coords': const LatLng(15.773828785606453, 120.89879260168183),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Sapang Cauayan',
      'subtitle': 'PW5J+JF Science City of Muñoz, Nueva Ecija',
      'coords': const LatLng(15.709052332614045, 120.93119030546389),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Villa Cuizon',
      'subtitle': 'Villa Cuizon Barangay Hall',
      'coords': const LatLng(15.72599680440455, 120.94279783250009),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Villa Isla',
      'subtitle': 'Villa Isla Covered Court',
      'coords': const LatLng(15.771015625726811, 120.86841819469628),
    },
    {
      'iconColor': Colors.orange,
      'title': 'Villa Nati',
      'subtitle': 'Villa Nati Barangay Hall',
      'coords': const LatLng(15.691999026175324, 120.93903425144819),
    },
    // Add more locations here...
  ];

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
        _sortLocationsByDistance();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _sortLocationsByDistance() {
    if (_currentPosition != null) {
      final Distance distanceCalculator = Distance();
      final LatLng currentLocation = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      _evacuationLocations.sort((a, b) {
        double distanceA = distanceCalculator.as(
          LengthUnit.Kilometer,
          currentLocation,
          a['coords'],
        );
        double distanceB = distanceCalculator.as(
          LengthUnit.Kilometer,
          currentLocation,
          b['coords'],
        );
        return distanceA.compareTo(distanceB);
      });

      setState(() {}); // Update the UI with the sorted locations
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(LocaleData.evacuationCenter.getString(context)),
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
            for (var location in _evacuationLocations)
              _buildHotlineCard(
                context,
                iconColor: location['iconColor'],
                title: location['title'],
                subtitle: location['subtitle'],
                evacuationCoords: location['coords'],
              ),
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
    bool isLocationAvailable = _currentPosition != null;

    if (isLocationAvailable) {
      final Distance distanceCalculator = Distance();
      final LatLng currentLocation = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      distance = distanceCalculator.as(
        LengthUnit.Kilometer,
        currentLocation,
        evacuationCoords,
      );
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
                '${distance?.toStringAsFixed(2)} km',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
        onTap: () {
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
