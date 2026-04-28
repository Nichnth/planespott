import 'package:cloud_firestore/cloud_firestore.dart';

class SightingModel {
  final String id;
  final String userId;
  final String aircraftType;
  final String airline;
  final String? flightNumber;
  final String? photoUrl;
  final GeoPoint coordinates;
  final double? altitude;
  final double? speed;
  final double? heading;
  final DateTime timestamp;
  final String? notes;
  final int likeCount;
  final DateTime updatedAt;

  SightingModel({
    required this.id,
    required this.userId,
    required this.aircraftType,
    required this.airline,
    this.flightNumber,
    this.photoUrl,
    required this.coordinates,
    this.altitude,
    this.speed,
    this.heading,
    required this.timestamp,
    this.notes,
    this.likeCount = 0,
    required this.updatedAt,
  });

  // Convert Firestore document to SightingModel
  factory SightingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return SightingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      aircraftType: data['aircraftType'] ?? '',
      airline: data['airline'] ?? '',
      flightNumber: data['flightNumber'],
      photoUrl: data['photoUrl'],
      coordinates: data['coordinates'] ?? const GeoPoint(0, 0),
      altitude: (data['altitude'] as num?)?.toDouble(),
      speed: (data['speed'] as num?)?.toDouble(),
      heading: (data['heading'] as num?)?.toDouble(),
      timestamp: (data['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
      notes: data['notes'],
      likeCount: data['likeCount'] ?? 0,
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert SightingModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'aircraftType': aircraftType,
      'airline': airline,
      'flightNumber': flightNumber,
      'photoUrl': photoUrl,
      'coordinates': coordinates,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'timestamp': timestamp,
      'notes': notes,
      'likeCount': likeCount,
      'updatedAt': updatedAt,
    };
  }

  // Create a copy with modified fields
  SightingModel copyWith({
    String? id,
    String? userId,
    String? aircraftType,
    String? airline,
    String? flightNumber,
    String? photoUrl,
    GeoPoint? coordinates,
    double? altitude,
    double? speed,
    double? heading,
    DateTime? timestamp,
    String? notes,
    int? likeCount,
    DateTime? updatedAt,
  }) {
    return SightingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      aircraftType: aircraftType ?? this.aircraftType,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      coordinates: coordinates ?? this.coordinates,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      likeCount: likeCount ?? this.likeCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

