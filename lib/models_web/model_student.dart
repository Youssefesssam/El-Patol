import 'package:cloud_firestore/cloud_firestore.dart';
import 'model_assignmentStatus.dart';
import 'model_wachedvideo.dart';

class Student {
  final String id;
  final String name;
  final String stage;

  final String phoneStudent;
  final String phoneParent;
  final String location;

  final Map<String, dynamic> paidModules;
  final Map<String, WatchedVideo> watchedVideos;
  final Map<String, AssignmentStatus> assignments;
  final Map<String, String> teachers;

  // الحقول الإضافية
  final String code;
  final String email;
  final String centerCode;
  final String stageCode;
  final String stageType;
  final String stageYear;
  final String role;
  final bool isRegistered;
  final DateTime? createdAt;
  Student({
    required this.id,
    required this.name,
    required this.stage,
    required this.paidModules,
    required this.watchedVideos,
    required this.assignments,
    required this.code,
    required this.email,
    required this.centerCode,
    required this.stageCode,
    required this.stageType,
    required this.stageYear,
    required this.role,
    required this.isRegistered,
    required this.createdAt,
    required this.teachers,
    required this.phoneParent,
    required this.phoneStudent,
    required this.location,
  });

  factory Student.fromMap(String id, Map<String, dynamic> data) {
    // ✅ معالجة watchedVideos سواء كانت Map أو List
    Map<String, WatchedVideo> parsedWatchedVideos = {};
    if (data['watchedVideos'] is Map) {
      parsedWatchedVideos = (data['watchedVideos'] as Map).map(
            (key, value) => MapEntry(
          key.toString(),
          WatchedVideo.fromMap(key.toString(), Map<String, dynamic>.from(value)),
        ),
      );
    } else if (data['watchedVideos'] is List) {
      for (var item in (data['watchedVideos'] as List)) {
        if (item is Map<String, dynamic> && item['videoId'] != null) {
          parsedWatchedVideos[item['videoId']] =
              WatchedVideo.fromMap(item['videoId'], item);
        }
      }
    }

    // ✅ معالجة assignments بنفس الفكرة
    Map<String, AssignmentStatus> parsedAssignments = {};
    if (data['assignments'] is Map) {
      parsedAssignments = (data['assignments'] as Map).map(
            (key, value) => MapEntry(
          key.toString(),
          AssignmentStatus.fromMap(key.toString(), Map<String, dynamic>.from(value)),
        ),
      );
    } else if (data['assignments'] is List) {
      for (var item in (data['assignments'] as List)) {
        if (item is Map<String, dynamic> && item['assignmentId'] != null) {
          parsedAssignments[item['assignmentId']] =
              AssignmentStatus.fromMap(item['assignmentId'], item);
        }
      }
    }

    return Student(
      id: id,
      name: data['name'] ?? '',
      stage: data['stage'] ?? '',
      phoneParent: data['phoneParent'] ?? '',
      phoneStudent: data['phoneStudent'] ?? '',
      location: data['location'] ?? '',
      paidModules: Map<String, dynamic>.from(data['paidModules'] ?? {}),
      watchedVideos: parsedWatchedVideos,
      assignments: parsedAssignments,
      code: data['code'] ?? '',
      email: data['email'] ?? '',
      centerCode: data['centerCode'] ?? '',
      stageCode: data['stageCode'] ?? '',
      stageType: data['stageType'] ?? '',
      stageYear: data['stageYear'] ?? '',

      role: data['role'] ?? 'student',
      isRegistered: data['isRegistered'] is bool ? data['isRegistered'] : true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      teachers: Map<String, String>.from(data['teachers'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stage': stage,
      'location': location,
      'phoneStudent': phoneStudent,
      'phoneParent': phoneParent,
      'paidModules': paidModules,
      'watchedVideos': watchedVideos.map((k, v) => MapEntry(k, v.toMap())),
      'assignments': assignments.map((k, v) => MapEntry(k, v.toMap())),
      'teachers': teachers,
      'code': code,
      'email': email,
      'centerCode': centerCode,
      'stageCode': stageCode,
      'stageType': stageType,
      'stageYear': stageYear,
      'role': role,
      'isRegistered': isRegistered,
      'createdAt': createdAt,
    };
  }
}
