class User {
  final String? name;
  final String? code;
  final String? id;
  final String? profileUrl;

  final int seenWord;
  final int pons;
  final int winVoting;
  final int solTaskoo;
  final int rank;

  User({
    required this.name,
    required this.code,
    required this.id,
    required this.profileUrl,
    this.seenWord = 0,
    this.pons = 0,
    this.winVoting = 0,
    this.solTaskoo = 0,
    this.rank = 0,
  });

  // ✅ حل صحيح باستخدام factory
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      code: json["code"],
      id: json["id"],
      profileUrl: json["profileUrl"] ?? '',
      seenWord: json["seenWord"] ?? 0,
      pons: json["pons"] ?? 0,
      winVoting: json["winVoting"] ?? 0,
      solTaskoo: json["solTaskoo"] ?? 0,
      rank: json["rank"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'id': id,
      'profileUrl': profileUrl,
      'seenWord': seenWord,
      'pons': pons,
      'winVoting': winVoting,
      'solTaskoo': solTaskoo,
      'rank': rank,
    };
  }
}
