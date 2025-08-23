import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_submission.dart';

class Assignment {
  final String id;
  final String title;
  final String stage;
  final String teacherId;
  final DateTime deadline;
  final List<dynamic> questions;
  final Map<String, Submission> submissions;

  Assignment({
    required this.id,
    required this.title,
    required this.stage,
    required this.teacherId,
    required this.deadline,
    required this.questions,
    required this.submissions,
  });

  factory Assignment.fromMap(String id, Map<String, dynamic> data) {
    return Assignment(
      id: id,
      title: data['title'] ?? '',
      stage: data['stage'] ?? '',
      teacherId: data['teacherId'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      questions: data['questions'] ?? [],
      submissions: (data['submissions'] ?? {}).map<String, Submission>((key, value) {
        return MapEntry(key, Submission.fromMap(key, value));
      }),
    );
  }
}
