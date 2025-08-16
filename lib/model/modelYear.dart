class ModelYear{
  static const String collection = 'Year';
  int? TotalScoreOfYear;
  ModelYear({
    this.TotalScoreOfYear=0,

  });
  ModelYear.fromJson(Map<String, dynamic> json) {
    TotalScoreOfYear =json["TotalScoreOfYear"];
  }

  Map<String, dynamic> toJson() {
    return {
      'TotalScoreOfYear' :TotalScoreOfYear,

    };
  }
}