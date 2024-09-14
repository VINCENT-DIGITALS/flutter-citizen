import 'dart:async';
import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String currentPage;

  const MapPage({Key? key, this.currentPage = 'weather'}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(15.7295, 120.8729);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Map'),
          shadowColor: Colors.black,
          elevation: 2.0,
        ),
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Location: On'),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: constraints.maxWidth > 600 ? 400 : 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _pGooglePlex,
                            zoom: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Looking for quickest route...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  '• Go right to Pelmoka Street\n• Take a left turn',
                                  style: TextStyle(fontSize: constraints.maxWidth > 600 ? 18 : 14),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/sample_image.png', // Replace with your actual image path
                                    height: constraints.maxWidth > 600 ? 100 : 60,
                                    width: constraints.maxWidth > 600 ? 100 : 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Looking for quickest route...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  '• Go right to Pelmoka Street\n• Take a left turn',
                                  style: TextStyle(fontSize: constraints.maxWidth > 600 ? 18 : 14),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/sample_image.png', // Replace with your actual image path
                                    height: constraints.maxWidth > 600 ? 100 : 60,
                                    width: constraints.maxWidth > 600 ? 100 : 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }
}
