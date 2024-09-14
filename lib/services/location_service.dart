import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Method to check and request location services and permissions
  Future<bool> checkLocationServicesAndPermissions() async {
    try {
      // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   return false;
      // }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return true;
    } catch (e) {
      print('Error checking location services and permissions: $e');
      return false;
    }
  }

  // Updated method to get the current location with permission checks
  Future<Position> getCurrentLocation() async {
    try {
      // Ensure that location services are enabled and permissions are granted
      bool hasPermission = await checkLocationServicesAndPermissions();
      if (!hasPermission) {
        throw Exception('Location services or permissions are not enabled.');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting current location: $e');
      rethrow;
    }
  }

  // Method to get address from a location
  Future<String> getAddressFromLocation(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print('Error getting address from location: $e');
      return 'Error retrieving address';
    }
  }

  // Method to open location settings
  Future<void> openLocationSettings() async {
    try {
      bool opened = await Geolocator.openLocationSettings();
      if (!opened) {
        throw Exception('Could not open location settings.');
      }
    } catch (e) {
      print('Error opening location settings: $e');
      rethrow;
    }
  }

  // Method to check if location usage is enabled
  Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      print('Error checking if location is enabled: $e');
      return false;
    }
  }

  // Request location services only if enabled
  Future<Position?> requestLocation() async {
    try {
      bool isEnabled = await isLocationEnabled();
      if (isEnabled) {
        return await Geolocator.getCurrentPosition();
      } else {
        return null; // Return null if location is disabled
      }
    } catch (e) {
      print('Error requesting location: $e');
      return null;
    }
  }
}
