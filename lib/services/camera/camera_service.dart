import 'dart:io';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CameraService {
  CameraController? _cameraController;

  CameraController get cameraController => _cameraController!;

  // Initialize available cameras
  Future<List<CameraDescription>> initializeCameras() async {
    try {
      logger.i('Initializing cameras...');
      final cameras = await availableCameras();
      logger.i('Found ${cameras.length} cameras');
      return cameras;
    } catch (e) {
      logger.e('Error initializing cameras: $e');
      rethrow;
    }
  }

  // Initialize specific camera
  Future<void> initializeCamera(CameraDescription camera) async {
    try {
      logger.i('Initializing ${camera.name} camera');

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      logger.i('Camera initialized successfully');
    } catch (e) {
      logger.e('Error initializing camera: $e');
      rethrow;
    }
  }

  // Take a picture
  Future<File?> takePicture() async {
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }

      logger.i('Taking picture...');
      final image = await _cameraController!.takePicture();
      logger.i('Picture taken: ${image.path}');

      return File(image.path);
    } catch (e) {
      logger.e('Error taking picture: $e');
      rethrow;
    }
  }

  // Set flash mode
  Future<void> setFlashMode(FlashMode mode) async {
    try {
      if (_cameraController == null) return;
      await _cameraController!.setFlashMode(mode);
      logger.i('Flash mode set to: $mode');
    } catch (e) {
      logger.e('Error setting flash mode: $e');
    }
  }

  // Set zoom level
  Future<void> setZoomLevel(double zoom) async {
    try {
      if (_cameraController == null) return;
      await _cameraController!.setZoomLevel(zoom);
      logger.i('Zoom level set to: $zoom');
    } catch (e) {
      logger.e('Error setting zoom: $e');
    }
  }

  // Dispose camera
  void dispose() {
    _cameraController?.dispose();
  }
}

