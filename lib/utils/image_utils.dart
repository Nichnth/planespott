import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  // Convert XFile to File
  static File xFileToFile(XFile xFile) {
    return File(xFile.path);
  }

  // Get file size in MB
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  // Check if file size is within limit (in MB)
  static bool isFileSizeValid(File file, double maxSizeMB) {
    return getFileSizeInMB(file) <= maxSizeMB;
  }

  // Get file name from path
  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  // Check if file is an image
  static bool isImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final fileName = file.path.toLowerCase();
    return validExtensions.any((ext) => fileName.endsWith(ext));
  }

  // Generate thumbnail file name
  static String generateThumbnailName(String fileName) {
    return 'thumb_$fileName';
  }

  // Generate sighting image file name
  static String generateSightingFileName(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'sighting_${userId}_$timestamp.jpg';
  }

  // Get image mime type
  static String getImageMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  // Format file size for display
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var byteValue = bytes.toDouble();
    var suffixIndex = 0;

    while (byteValue >= 1024 && suffixIndex < suffixes.length - 1) {
      byteValue /= 1024;
      suffixIndex++;
    }

    return '${byteValue.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }
}

