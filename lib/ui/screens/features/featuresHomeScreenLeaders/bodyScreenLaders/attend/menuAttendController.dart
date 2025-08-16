import 'package:flutter/material.dart';

class MenuAttendController with ChangeNotifier {
  int totalScore = 0;
  bool isMassActive = false;
  int massScore = 0;

  bool isCommunionActive = false;
  int communionScore = 0;

  bool isConfessionActive = false;
  int confessionScore = 0;

  bool isMeetingActive = false;
  int meetingScore = 0;

  bool isWaiting = false;
  bool isDone = false;

  void toggleState(String key) {
    switch (key) {
      case "mass":
        isMassActive = !isMassActive;
        massScore = isMassActive ? 25 : 0;
        break;
      case "communion":
        isCommunionActive = !isCommunionActive;
        communionScore = isCommunionActive ? 25 : 0;
        break;
      case "confession":
        isConfessionActive = !isConfessionActive;
        confessionScore = isConfessionActive ? 25 : 0;
        break;
      case "meeting":
        isMeetingActive = !isMeetingActive;
        meetingScore = isMeetingActive ? 25 : 0;
        break;
    }

    totalScore = massScore + communionScore + confessionScore + meetingScore;
    notifyListeners();
  }

  void resetScores() {
    totalScore = 0;
    isMassActive = isCommunionActive = isConfessionActive = isMeetingActive = false;
    massScore = communionScore = confessionScore = meetingScore = 0;
    isWaiting = false;
    isDone = false;
    notifyListeners();
  }

  Future<void> submitScores({
    required Function onSuccess,
    required Function(String error) onError,
    required Future<void> Function({
    required int score,
    required int meetingScoreDB,
    required int communionScoreDB,
    required int confessionScoreDB,
    required int massScoreDB,
    }) saveFunction,
  }) async {
    isWaiting = true;
    isDone = false;
    notifyListeners();

    try {
      await saveFunction(
        score: totalScore,
        meetingScoreDB: meetingScore,
        communionScoreDB: communionScore,
        confessionScoreDB: confessionScore,
        massScoreDB: massScore,
      );

      isWaiting = false;
      isDone = true;
      notifyListeners();

      onSuccess();
    } catch (e) {
      isWaiting = false;
      isDone = false;
      notifyListeners();
      onError(e.toString());
    }
  }
}
