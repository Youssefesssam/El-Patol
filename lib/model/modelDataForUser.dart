class ModelDataForUser {
  static const String collection = 'data';

  int scoreSeenUserEvent;
  int scoreSeenUserSweetTalk;
  int scoreSeenUserWord;

  ModelDataForUser({this.scoreSeenUserEvent =0,this.scoreSeenUserSweetTalk = 0, this.scoreSeenUserWord=0});

  factory ModelDataForUser.fromJson(Map<String, dynamic> data) {
    return ModelDataForUser(
      scoreSeenUserEvent: data['scoreSeenUserEvent'] ?? 0,
      scoreSeenUserSweetTalk: data['scoreSeenUserSweetTalk'] ?? 0,
      scoreSeenUserWord: data['scoreSeenUserWord'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scoreSeenUserEvent': scoreSeenUserEvent,
      'scoreSeenUserSweetTalk': scoreSeenUserSweetTalk,
      'scoreSeenUserWord': scoreSeenUserWord,
    };
  }
}
