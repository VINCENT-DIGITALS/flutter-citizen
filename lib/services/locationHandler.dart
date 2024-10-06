import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_foreground_task/task_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'database_service.dart';
import 'location_service.dart';

class LocationTaskHandler extends TaskHandler {
  final DatabaseService _dbService = DatabaseService();
  final LocationService _locationService = LocationService();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Called when the service is started
    print('LocationTaskHandler started.');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // This will be called periodically based on the interval logic
    Future.delayed(Duration(minutes: 1), () async {
      try {
        bool hasPermission = await _locationService.checkLocationServicesAndPermissions();
        if (hasPermission) {
          Position position = await _locationService.getCurrentLocation();
          GeoPoint location = GeoPoint(position.latitude, position.longitude);

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await _dbService.updateLocationSharing(
              location: location,
              locationSharing: true, // Indicate location sharing is enabled
            );
            print('Location updated: $location');
          }
        }
      } catch (e) {
        print('Error during periodic location update: $e');
      }
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Called when the foreground service is stopped
    print('LocationTaskHandler destroyed.');
  }

  @override
  void onButtonPressed(String id) {
    // Handle button press from the notification (if any)
  }

  @override
  void onNotificationPressed() {
    // Handle notification press
  }
}
