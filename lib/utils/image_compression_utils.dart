import 'dart:io';
import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger();

class ImageCompressionUtils {
  // Convert image file to Base64 string
  static Future<String> fileToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      logger.i('Image converted to Base64, size: ${base64String.length} chars');
      return base64String;
    } catch (e) {
      logger.e('Error converting to Base64: $e');
      rethrow;
    }
  }

  // Convert Base64 string back to File
  static Future<File> base64ToFile(String base64String, String fileName) async {
    try {
      final bytes = base64Decode(base64String);
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);
      logger.i('Base64 converted to file: $fileName');
      return file;
    } catch (e) {
      logger.e('Error converting Base64 to file: $e');
      rethrow;
    }
  }

  // Get file size in KB
  static Future<double> getFileSizeInKB(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final sizeInKB = bytes.length / 1024;
      logger.i('File size: ${sizeInKB.toStringAsFixed(2)} KB');
      return sizeInKB;
    } catch (e) {
      logger.e('Error getting file size: $e');
      return 0;
    }
  }

  // Get Base64 size in KB (after encoding)
  static double getBase64SizeInKB(String base64String) {
    // Base64 increases size by ~33%
    final sizeInBytes = base64String.length; // Each character is ~1 byte in UTF-8
    final sizeInKB = sizeInBytes / 1024;
    logger.i('Base64 size: ${sizeInKB.toStringAsFixed(2)} KB (will increase ~33% from original)');
    return sizeInKB;
  }

  // Check if image is too large for Firestore
  static Future<bool> isImageTooLarge(File file) async {
    final sizeInKB = await getFileSizeInKB(file);
    // 700KB * 1.33 = 931KB, leaving 69KB buffer
    const maxRecommendedSizeKB = 700;

    if (sizeInKB > maxRecommendedSizeKB) {
      logger.w('Image size ($sizeInKB KB) exceeds recommended limit ($maxRecommendedSizeKB KB)');
      return true;
    }
    return false;
  }

  // Get formatted size string
  static Future<String> getFormattedSize(File file) async {
    final sizeInKB = await getFileSizeInKB(file);
    if (sizeInKB < 1) {
      return '${(sizeInKB * 1024).toStringAsFixed(0)} B';
    } else if (sizeInKB < 1024) {
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      return '${(sizeInKB / 1024).toStringAsFixed(2)} MB';
    }
  }
}

