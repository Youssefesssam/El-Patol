class AssignmentStatus {
  final bool submitted;
  final int score;

  AssignmentStatus({
    required this.submitted,
    required this.score,
  });

  /// --- Firestore ---
  factory AssignmentStatus.fromMap(String id, Map<String, dynamic> data) {
    return AssignmentStatus(
      submitted: data['submitted'] ?? false,
      score: data['score'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'submitted': submitted,
      'score': score,
    };
  }

  /// --- JSON ---
  factory AssignmentStatus.fromJson(Map<String, dynamic> json) {
    return AssignmentStatus(
      submitted: json['submitted'] ?? false,
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submitted': submitted,
      'score': score,
    };
  }
}
