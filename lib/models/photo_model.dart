import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String id;
  final String userId;
  final String name;
  final String? imageBase64; // Base64 encoded image string
  final double latitude;
  final double longitude;
  final DateTime dateTaken;
  final bool isFavorite;
  final DateTime createdAt;

  PhotoModel({
    required this.id,
    required this.userId,
    required this.name,
    this.imageBase64,
    required this.latitude,
    required this.longitude,
    required this.dateTaken,
    this.isFavorite = false,
    required this.createdAt,
  });

  // Convert from Firestore
  factory PhotoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PhotoModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Unnamed Photo',
      imageBase64: data['imageBase64'], // Retrieve Base64 string from Firestore
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      dateTaken: (data['dateTaken'] as dynamic)?.toDate() ?? DateTime.now(),
      isFavorite: data['isFavorite'] ?? false,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'imageBase64': imageBase64, // Store Base64 string in Firestore
      'latitude': latitude,
      'longitude': longitude,
      'dateTaken': dateTaken,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
    };
  }

  // Copy with changes
  PhotoModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? imageBase64,
    double? latitude,
    double? longitude,
    DateTime? dateTaken,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageBase64: imageBase64 ?? this.imageBase64,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dateTaken: dateTaken ?? this.dateTaken,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

