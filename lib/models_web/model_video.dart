import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String title;
  final String teacherId;
  final String stage;
  final String moduleId;
  final String url;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.teacherId,
    required this.stage,
    required this.moduleId,
    required this.url,
    required this.createdAt,
  });

  factory VideoModel.fromMap(String id, Map<String, dynamic> data) {
    return VideoModel(
      id: id,
      title: data['title'] ?? '',
      teacherId: data['teacherId'] ?? '',
      stage: data['stage'] ?? '',
      moduleId: data['moduleId'] ?? '',
      url: data['url'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'teacherId': teacherId,
      'stage': stage,
      'moduleId': moduleId,
      'url': url,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
