import 'dart:async';
import 'dart:convert';
import 'package:citizen/api/routing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../services/location_service.dart';
import '../../sidebar_Pages/about_app_page.dart';
import '../acknowledgement/acknowledgement.dart';

class ReportMapPage extends StatefulWidget {
  final String locationName;
  final LatLng resportCoords;
  final String? responderId; // Optional parameter
  final String? reportStatus;

  const ReportMapPage({
    required this.locationName,
    required this.resportCoords,
    this.responderId,
    this.reportStatus,
    super.key,
  });

  @override
  State<ReportMapPage> createState() => _ReportMapPageState();
}

class _ReportMapPageState extends State<ReportMapPage> {
  // Raw coordinates got from  OpenRouteService
  List listOfPoints = [];

  // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
  List<LatLng> points = [];
  final MapController mapController = MapController();
  late final tileProvider = FMTCStore('mapCache').getTileProvider(
    settings: FMTCTileProviderSettings(
      behavior: CacheBehavior.cacheFirst,
      cachedValidDuration: const Duration(days: 5),
    ),
  );

  final LocationService _locationService =
      LocationService(); // Initialize LocationService
  StreamSubscription<Position>?
      _positionStream; // For listening to location updates
  StreamSubscription<DocumentSnapshot>?
      _responderLocationStream; // Real-time listener for responder's location
  LatLng? _currentLocation; // Store the current location
  final PopupController _popupController =
      PopupController(); // Add PopupController to manage popups
  LatLng? _responderLocation;
  @override
  void initState() {
    super.initState();
    _startListeningToLocationUpdates();
    if (widget.responderId != null && widget.reportStatus != "Completed") {
      _listenToResponderLocationUpdates(); // Start listening to responder's location
    }
  }

  // Start listening to location updates
  void _startListeningToLocationUpdates() async {
    try {
      bool hasPermission =
          await _locationService.checkLocationServicesAndPermissions();
      if (hasPermission) {
        // Get the initial position first
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });

        // Then start the position stream for real-time updates
        _positionStream = Geolocator.getPositionStream(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.best),
        ).listen((Position position) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Location permission denied. Please enable it to use the map.')),
        );
      }
    } catch (e) {
      print('Error starting location updates: $e');
    }
  }

  // Real-time listener for responder's location from Firestore
  void _listenToResponderLocationUpdates() {
    _responderLocationStream = FirebaseFirestore.instance
        .collection('responders')
        .doc(widget.responderId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        GeoPoint geoPoint = snapshot['location'];
        setState(() {
          _responderLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
        });
      } else {
        print('Responder location not found.');
      }
    });
  }

  // Get markers including current and evacuation location
  List<Marker> getMarkers() {
    List<Marker> markers = [
      Marker(
        point: widget.resportCoords,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
        key: const Key(
            'incidentMarker'), // Add unique key for popup functionality
      ),
    ];

    if (_currentLocation != null) {
      markers.add(
        Marker(
          point: _currentLocation!,
          child: const Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 40,
          ),
          key: const Key(
              'myCurrentLocationMarker'), // Add unique key for popup functionality
        ),
      );
    }
    if (widget.reportStatus != "Completed" &&
        widget.responderId != null &&
        _responderLocation != null) {
      print('responder location: ${_responderLocation}');
      markers.add(
        Marker(
          point: _responderLocation!,
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.orange,
            size: 40,
          ),
          key: const Key(
              'responderMarker'), // Add unique key for popup functionality
        ),
      );
    }

    return markers;
  }

// Helper function to convert LatLng to 'longitude,latitude' string format
  String latLngToString(LatLng coords) {
    return '${coords.longitude},${coords.latitude}';
  }

  //Function to use the openrouteservice
  getCoordinates() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // If there is no internet connection, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Internet connection required for routing!'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Exit the function
    }

    if (widget.responderId == null) {
      // If there is no internet connection, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No responder available!'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Exit the function
    }
    if (widget.reportStatus == "Completed") {
      // If there is no internet connection, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The incdent report already been completed!'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Exit the function
    }
    //request
    if (_responderLocation != null) {
      // Convert both current location and evacuation coordinates to string format
      String startPoint = latLngToString(_responderLocation!);
      String endPoint = latLngToString(widget.resportCoords);

      var response = await http.get(getRouteUrl(startPoint, endPoint));

      setState(() {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          listOfPoints = data['features'][0]['geometry']['coordinates'];
          points = listOfPoints
              .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
              .toList();
        }
      });
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Cancel the location updates when disposing
    _responderLocationStream?.cancel(); // Cancel responder's location stream
    super.dispose();
  }

  // Method to delete the cached tiles
  Future<void> _deleteCachedTiles() async {
    final mgmt = FMTCStore('mapCache').manage;

    try {
      await mgmt.delete(); // Delete the cached tiles
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Map cache deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting cache: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting cache.'),
        ),
      );
    }
  }

  // Show a confirmation dialog before deleting the cache
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Cache'),
          content: const Text(
              'Are you sure you want to delete the cached map data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCachedTiles(); // Call the delete method
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Show the confirmation dialog before navigating to the GPL page
  void _showGPLConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GPL License Acknowledgment'),
          content: const Text(
              'This app uses the flutter_map_tile_caching package, which is licensed under the GPL. Would you like to view more details?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AboutAppPage(), // Navigate to GPL License Page
                  ),
                );
              },
              child: const Text('View'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Evacuation Map'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  _showDeleteConfirmationDialog, // Show confirmation dialog on delete button click
            ),
          ],
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: widget
                    .resportCoords, // Center on evacuation location initially
                initialZoom: 15,
                maxZoom: 20,
                minZoom: 13,
                onTap: (_, __) =>
                    _popupController.hideAllPopups(), // Hide popup on map tap
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  tileProvider: tileProvider,
                ),
                MarkerLayer(
                  markers: getMarkers(), // Use dynamic markers
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers: getMarkers(),
                    popupController: _popupController,
                    markerTapBehavior: MarkerTapBehavior
                        .togglePopup(), // Toggle popup on marker tap
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        // Popup content based on marker key
                        if (marker.key == const Key('incidentMarker')) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Location: ${widget.locationName}'),
                          );
                        } else if (marker.key ==
                            const Key('myCurrentLocationMarker')) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('You are here'),
                          );
                        } else if (marker.key == const Key('responderMarker')) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('The Responders are here'),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                // Polylines layer
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                        points: points, color: Colors.black, strokeWidth: 5),
                  ],
                ),
              ],
            ),
            // Add the icons on the right side if locations are available
            if (_currentLocation != null && widget.resportCoords != null)
              Positioned(
                right: 10,
                top: MediaQuery.of(context).size.height / 2 - 60,
                child: Column(
                  children: [
                    // Current location button
                    IconButton(
                      icon:
                          Icon(Icons.my_location, color: Colors.blue, size: 40),
                      onPressed: () {
                        if (_currentLocation != null) {
                          mapController.move(_currentLocation!, 15.0);
                        } else {
                          print("Current location is null.");
                        }
                      },
                    ),
                    // Incident location button
                    IconButton(
                      icon: Icon(Icons.people, color: Colors.red, size: 40),
                      onPressed: () {
                        if (_currentLocation != null) {
                          mapController.move(widget.resportCoords!, 15.0);
                        } else {
                          print("Current location is null.");
                        }
                      },
                    ),
                    // Responder's location button (conditionally shown)
                    if (widget.reportStatus != "Completed" &&
                        widget.responderId != null)
                      IconButton(
                        icon: Icon(Icons.health_and_safety_outlined,
                            color: Colors.orange, size: 40),
                        onPressed: () {
                          if (_responderLocation != null) {
                            mapController.move(_responderLocation!, 15.0);
                          } else {
                            print("Evacuation location is null.");
                          }
                        },
                      ),
                  ],
                ),
              ),

            // Flutter logo at the bottom left
            Positioned(
              bottom: 20,
              left: 20,
              child: GestureDetector(
                onTap: _showGPLConfirmationDialog, // Show dialog on tap
                child: FlutterLogo(size: 30), // Display the Flutter logo
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getCoordinates();
          },
          tooltip: 'increment',
          child: const Icon(Icons.route),
        ));
  }
}
