import 'package:flutter/material.dart';

class ProviderTotalScore extends ChangeNotifier {
  int hiEvent = 0;
  int sweetTalk = 0;
  int scoreWord = 0;
  int totalScoreUser = 0;
  int totalScoreLeader = 0;

  ProviderTotalScore({
    this.totalScoreLeader = 0,
    this.totalScoreUser = 0,
    this.scoreWord = 0,
    this.hiEvent = 0,
    this.sweetTalk = 0,
  });

  /// تحديث إجمالي نقاط القائد
  void setTotalScoreLeader(int allScoreLeader) {
    totalScoreLeader = allScoreLeader;
    notifyListeners();
  }

  /// تحديث نقاط رؤية الحدث
  void updateSeenEventScore(int seenEvent) {
    hiEvent = seenEvent;
    _updateTotalUserScore();
  }

  /// تحديث نقاط رؤية رسالة Sweet Talk
  void updateSeenSweetTalkScore(int seenSweetTalk) {
    sweetTalk = seenSweetTalk;
    _updateTotalUserScore();
  }

  /// تحديث نقاط رؤية كلمة الأسبوع
  void updateSeenWordScore(int seenWordScore) {
    scoreWord = seenWordScore;
    _updateTotalUserScore();
  }

  /// تحديث النقاط الكلية للمستخدم عند أي تغيير
  void _updateTotalUserScore() {
    totalScoreUser = hiEvent + sweetTalk + scoreWord;
    notifyListeners();
  }

  void resetScores() {
    hiEvent = 0;
    sweetTalk = 0;
    scoreWord = 0;
    totalScoreUser = 0;
    totalScoreLeader = 0;
    notifyListeners();
  }

  void updateScoresFromFirebase(int newEventScore, int newSweetTalk, int newScoreWord) {
    hiEvent = newEventScore;
    sweetTalk = newSweetTalk;
    scoreWord = newScoreWord;
    _updateTotalUserScore();
    notifyListeners();
  }



  /// الحصول على النقاط المكتسبة من قبل المستخدم فقط
  int get scoreFromUser => hiEvent + sweetTalk + scoreWord;

  /// الحصول على مجموع النقاط بالكامل (المستخدم + القائد)
  int get totalScore => totalScoreUser + totalScoreLeader;
}
