import 'dart:async';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';
import 'locationHandler.dart';
import 'location_service.dart'; // Import your LocationService

class MyForegroundService {
  late DatabaseService _dbService;

  MyForegroundService(); // Constructor

  void initialize(DatabaseService dbService) {
    _dbService = dbService;
  }

  final LocationService _locationService =
      LocationService(); // Instance of LocationService
  Timer? _locationUpdateTimer; // Timer for periodic updates
  // Start the foreground service with periodic location updates
  // Start the foreground service with periodic location updates
  Future<void> startForegroundService() async {
    if (_dbService.isAuthenticated()) {
      // Start the foreground service with the correct parameters
      await FlutterForegroundTask.startService(
        notificationTitle: 'Location Service Running',
        notificationText: 'We are tracking your location in the background',
        callback: updateLocationInBackground, // This is required
      );
      // Start the periodic location updates with a timer
      const updateInterval = Duration(minutes: 1); // Set your desired interval
      _locationUpdateTimer = Timer.periodic(updateInterval, (timer) async {
        updateLocationInBackground();
      });
    } else {
      throw Exception("User not authenticated, cannot start location service");
    }
  }

  // Stop the foreground service and update location sharing to false
  Future<void> stopForegroundService() async {
    // Check if the user is authenticated before stopping the service
    if (_dbService.isAuthenticated()) {
      await FlutterForegroundTask.stopService();

      // Cancel the timer to stop periodic updates
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = null; // Clear the reference to prevent reuse

      // Optionally, update Firestore to indicate that location sharing is turned off
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GeoPoint dummyLocation =
            GeoPoint(0, 0); // Optional last known or dummy location
        await _dbService.updateLocationSharing(
          location: dummyLocation,
          locationSharing: false, // Disable location sharing
        );
      }
    } else {
      throw Exception("User not authenticated, cannot stop location service");
    }
  }

  // Callback method that runs in the background to update location
  void updateLocationInBackground() async {
    try {
      // Ensure that location services are enabled and permissions are granted
      bool hasPermission =
          await _locationService.checkLocationServicesAndPermissions();
      if (hasPermission) {
        Position position = await _locationService.getCurrentLocation();
        GeoPoint location = GeoPoint(position.latitude, position.longitude);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Call the updateLocationSharing method from the DatabaseService
          await _dbService.updateLocationSharing(
            location: location,
            locationSharing: true, // Indicate that location sharing is enabled
          );
        }
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  // Explicit method to stop location sharing if needed
  void stopLocationSharing() async {
    // Stop the foreground service
    await stopForegroundService();

    // You can pass the last known location or a dummy value
    GeoPoint dummyLocation =
        GeoPoint(0, 0); // Use a valid location if available
    await _dbService.updateLocationSharing(
      location: dummyLocation, // Last known or dummy location
      locationSharing: false, // Set location sharing to false
    );
  }
}

Future<bool> grantedForegroundServicePermissionAndroid() async {
  final NotificationPermission notificationPermission =
      await FlutterForegroundTask.checkNotificationPermission();
  if (notificationPermission != NotificationPermission.granted) {
    await FlutterForegroundTask.requestNotificationPermission();
    if (notificationPermission == NotificationPermission.granted) {
      return true;
    }
    return false;
  }
  return true;
}
