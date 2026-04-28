import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

final logger = Logger();

class LocationService {
  // Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    logger.i('Location service enabled: $enabled');
    return enabled;
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    logger.i('Requesting location permission...');
    final permission = await Geolocator.requestPermission();
    logger.i('Location permission: $permission');
    return permission;
  }

  // Check location permission
  Future<LocationPermission> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    logger.i('Current location permission: $permission');
    return permission;
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    try {
      logger.i('Getting current position...');

      // Check permission
      final permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        logger.w('Location permission denied');
        final newPermission = await requestPermission();
        if (newPermission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      // Check if location service enabled
      final enabled = await isLocationServiceEnabled();
      if (!enabled) {
        logger.w('Location service disabled');
        await Geolocator.openLocationSettings();
        throw Exception('Location service disabled');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      logger.i(
        'Current position: ${position.latitude}, ${position.longitude}',
      );

      return position;
    } catch (e) {
      logger.e('Error getting current position: $e');
      rethrow;
    }
  }

  // Get position stream
  Stream<Position> getPositionStream() {
    logger.i('Getting position stream...');
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    );
  }

  // Calculate distance between two coordinates
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    final distance = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distance;
  }
}

