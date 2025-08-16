class ModelMonth {
  static const String collection = 'Month';

  final int totalScoreOfMonth;

  ModelMonth({required this.totalScoreOfMonth});

  factory ModelMonth.fromJson(Map<String, dynamic> json) {
    return ModelMonth(
      totalScoreOfMonth: json["TotalScorOfMonth"] ?? 0, // تجنب القيم الفارغة
    );
  }

  Map<String, dynamic> toJson() => {
    'TotalScorOfMonth': totalScoreOfMonth,
  };
}
