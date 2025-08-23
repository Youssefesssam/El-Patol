import 'package:cloud_firestore/cloud_firestore.dart';

class WatchedVideo {
  final String videoId;
  final DateTime watchedAt;
  final double progress;

  WatchedVideo({
    required this.videoId,
    required this.watchedAt,
    required this.progress,
  });

  /// --- Firestore ---
  factory WatchedVideo.fromMap(String id, Map<String, dynamic> data) {
    return WatchedVideo(
      videoId: id,
      watchedAt: (data['watchedAt'] as Timestamp).toDate(),
      progress: (data['progress'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'watchedAt': watchedAt,
      'progress': progress,
    };
  }

  /// --- JSON ---
  factory WatchedVideo.fromJson(Map<String, dynamic> json) {
    return WatchedVideo(
      videoId: json['videoId'] ?? '',
      watchedAt: DateTime.parse(json['watchedAt']),
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'watchedAt': watchedAt.toIso8601String(),
      'progress': progress,
    };
  }
}
