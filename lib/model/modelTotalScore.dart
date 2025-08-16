class ModelTotalScore {
  static const String collection = 'data';

  int score;

  ModelTotalScore({this.score=0});

  factory ModelTotalScore.fromJson(Map<String, dynamic> data) {
    return ModelTotalScore(
      score: data['score'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
    };
  }
}
