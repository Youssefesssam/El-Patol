import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  final String userId;
  final List<dynamic> answers;
  final int score;
  final DateTime submittedAt;

  Submission({
    required this.userId,
    required this.answers,
    required this.score,
    required this.submittedAt,
  });

  factory Submission.fromMap(String id, Map<String, dynamic> data) {
    return Submission(
      userId: id,
      answers: data['answers'] ?? [],
      score: data['score'] ?? 0,
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
    );
  }
}
