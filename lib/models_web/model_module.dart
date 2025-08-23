import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String id;
  final String title;
  final String stage;
  final String imageUrl;
  final double price;
  final List<String> videos;
  final DateTime createdAt;

  Module({
    required this.id,
    required this.title,
    required this.stage,
    required this.imageUrl,
    required this.price,
    required this.videos,
    required this.createdAt,
  });

  /// 🟢 من Firestore → Module
  factory Module.fromMap(Map<String, dynamic> data, String id) {
    return Module(
      id: id,
      title: data['title'] ?? '',
      stage: data['stage'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      videos: List<String>.from(data['videos'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// 🟢 من Module → Firestore
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "stage": stage,
      "imageUrl": imageUrl,
      "price": price,
      "videos": videos,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  /// 🔵 JSON (API / Local Storage)
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      stage: json['stage'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      videos: List<String>.from(json['videos'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "stage": stage,
      "imageUrl": imageUrl,
      "price": price,
      "videos": videos,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  /// ✏️ نسخة جديدة مع تعديلات
  Module copyWith({
    String? id,
    String? title,
    String? stage,
    String? imageUrl,
    double? price,
    List<String>? videos,
    DateTime? createdAt,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      stage: stage ?? this.stage,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      videos: videos ?? this.videos,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
