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
  late final DatabaseService _dbService;
  Timer? _locationUpdateTimer; // Timer for periodic updates
  Timer? _autoStopTimer; // Timer to stop the service after 30 minutes

  MyForegroundService() {
    _dbService = DatabaseService(); // Initialize the service here
  }

  final LocationService _locationService =
      LocationService(); // Instance of LocationService

  // Start the foreground service with periodic location updates
  Future<void> startForegroundService() async {
    if (_dbService.isAuthenticated()) {
      // Stop any existing timer before starting a new one
      if (_locationUpdateTimer != null && _locationUpdateTimer!.isActive) {
        print(
            'Stopping existing location update timer before starting a new one.');
        _locationUpdateTimer!.cancel();
      }

      if (_autoStopTimer != null && _autoStopTimer!.isActive) {
        print('Stopping existing auto-stop timer before starting a new one.');
        _autoStopTimer!.cancel();
      }

      // Start the foreground service
      await FlutterForegroundTask.startService(
        notificationTitle: 'Location Service Running',
        notificationText: 'We are tracking your location in the background',
        callback: updateLocationInBackground, // This is required
      );

      // Start the periodic location updates with a timer
      const updateInterval = Duration(minutes: 1); // Set desired interval
      _locationUpdateTimer = Timer.periodic(updateInterval, (timer) async {
        print('Timer triggered, updating location at ${DateTime.now()}');
        updateLocationInBackground(); // This is where location updates happen
      });

      // Start an auto-stop timer that will stop the service after 30 minutes
      const autoStopInterval = Duration(minutes: 30);
      _autoStopTimer = Timer(autoStopInterval, () async {
        print('Auto-stop timer triggered, stopping the foreground service.');
        await stopForegroundService(); // Automatically stop the service after 30 minutes
      });

      print(
          'Foreground service started with location updates every $updateInterval.');
      print('Service will automatically stop after $autoStopInterval.');
    } else {
      throw Exception("User not authenticated, cannot start location service");
    }
  }

  // Stop the foreground service and update location sharing to false
  Future<void> stopForegroundService() async {
    if (_dbService.isAuthenticated()) {
      // Stop the foreground service
      await FlutterForegroundTask.stopService();

      // Cancel the timers
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = null;
      _autoStopTimer?.cancel();
      _autoStopTimer = null;

      // Update Firestore to indicate that location sharing is turned off
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GeoPoint dummyLocation = GeoPoint(0, 0);
        await _dbService.updateLocationSharing(
          location: dummyLocation,
          locationSharing: false,
        );
      }
    } else {
      print("User not authenticated, skipping stop of location service.");
      return;
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
          // Get the current locationSharing status from Firestore
          DocumentSnapshot userDoc = await _dbService.getUserDoc(user.uid);
          bool isLocationSharing = userDoc['locationSharing'] ?? false;

          // Only update Firestore if location sharing is still enabled
          if (isLocationSharing) {
            await _dbService.updateLocationSharing(
              location: location,
              locationSharing:
                  true, // Indicate that location sharing is enabled
            );
          }
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
