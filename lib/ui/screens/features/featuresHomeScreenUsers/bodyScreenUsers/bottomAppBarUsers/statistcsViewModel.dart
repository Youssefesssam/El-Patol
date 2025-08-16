import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../model/modelData.dart';
import '../../../../../../model/modelMonth.dart';
import '../../../../../../model/modelUser.dart';
import '../../../../../../model/modelUserAttend.dart';
import '../../../../../../model/modelYear.dart';
import '../../../../../../model/modelweek.dart';

class StatisticsViewModel extends ChangeNotifier {
  int selectedMonthIndex = 1;
  int selectedWeekIndex = 0;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> weeks = ['week 1', 'week 2', 'week 3', 'week 4'];



  void updateMonthIndex(int index) {
    selectedMonthIndex = index;
    notifyListeners();
  }

  void updateWeekIndex(int index) {
    selectedWeekIndex = index;
    notifyListeners();
  }
  Stream<int> getStatisticsCircle(
      String userId,
      String select,
      String weekId,
      String monthId,
      ) {
    return FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(userId)
        .collection(ModelYear.collection)
        .doc('1')
        .collection(ModelMonth.collection)
        .doc(monthId)
        .collection(ModelWeek.collection)
        .doc(weekId)
        .collection(ModelData.dataCollection) // Order results if needed
        .limit(1) // Get only the first document
        .snapshots()

        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return data.containsKey(select) ? data[select] as int : 0;
      } else {
        return 0;
      }
    });
  }




  Future<int> getTotalScoreForMonthYear(String userId, String year) async {
    final firestore = FirebaseFirestore.instance;
    final prefs = await SharedPreferences.getInstance();

    // جلب الأسبوع الحالي
    final currentWeekDoc = await firestore.collection('settings').doc('currentWeek').get();
    final currentWeek = currentWeekDoc['weekNumber'].toString();

    // الأسبوع الأخير المعالج
    final lastProcessedWeek = prefs.getString('lastProcessedWeek_$year');

    // السكور الإجمالي القديم
    int cachedTotalScore = prefs.getInt('totalScore_$year') ?? 0;

    if (lastProcessedWeek == currentWeek) {
      // لو مفيش تغيير، رجع السكور القديم
      return cachedTotalScore;
    }

    // الأسبوع الحالي: شهر وأسبوع
    final now = DateTime.now();
    final monthId = now.month.toString().padLeft(2, '0');
    final weekNumber = now.weekday ~/ 2 + 1; // أو احسبه حسب طريقتك لتحديد الأسبوع داخل الشهر

    final weekDoc = await firestore
        .collection(MyUser.collection)
        .doc(userId)
        .collection(ModelYear.collection)
        .doc(year)
        .collection(ModelMonth.collection)
        .doc(monthId)
        .collection(ModelWeek.collection)
        .doc(weekNumber.toString())
        .collection(ModelData.dataCollection)
        .doc(ModelData.scoreCollection)
        .get();

    int newScore = 0;

    if (weekDoc.exists) {
      final rawScore = weekDoc.data()?['score'];
      if (rawScore is num) {
        newScore = rawScore.toInt();
      }
    }

    // السكور القديم لهذا الأسبوع
    final lastWeekScoreKey = 'lastScoreValue_${year}_$currentWeek';
    final oldWeekScore = prefs.getInt(lastWeekScoreKey) ?? 0;

    // احسب الفرق واضف للسكور الإجمالي
    final updatedTotalScore = cachedTotalScore - oldWeekScore + newScore;

    // حفظ القيم الجديدة
    await prefs.setInt('totalScore_$year', updatedTotalScore);
    await prefs.setString('lastProcessedWeek_$year', currentWeek);
    await prefs.setInt(lastWeekScoreKey, newScore);

    return updatedTotalScore;
  }



  Future<int> calculateCurrentWeekScore(String userId, String year) async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    // تحديد الشهر والأسبوع الحالي
    final monthId = now.month.toString().padLeft(2, '0');
    final weekNumber = now.weekday ~/ 2 + 1; // يمكن تعديلها حسب نظام حساب الأسابيع
    try {
      // جلب بيانات الأسبوع من Firebase
      final weekDoc = await firestore
          .collection(MyUser.collection)
          .doc(userId)
          .collection(ModelYear.collection)
          .doc(year)
          .collection(ModelMonth.collection)
          .doc(monthId)
          .collection(ModelWeek.collection)
          .doc(weekNumber.toString())
          .collection(ModelData.dataCollection)
          .doc(ModelData.scoreCollection)
          .get();

      if (weekDoc.exists) {
        final rawScore = weekDoc.data()?['score'];
        return (rawScore is num) ? rawScore.toInt() : 0;
      }
      return 0;
    } catch (e) {
      print('حدث خطأ في حساب سكور الأسبوع: $e');
      return 0;
    }
  }


  Future<int> getStata(String numWeek ,String userId) async {

      // استخراج بيانات الأسبوع الحالي من Firestore
      final weekDoc = await FirebaseFirestore.instance
          .collection(MyUser.collection)
          .doc(userId)
          .collection("summary")
          .doc("weeklyScores")
          .get();

      // التحقق من وجود الوثيقة
      if (!weekDoc.exists) {
        print("Document does not exist");
        return 0;
      }

      // استخراج المصفوفة weekScores
      final weekScores = weekDoc.data()?['weekScores'] as Map<String, dynamic>?;

       // Assuming "0" is a valid key in the map
        return weekScores?[numWeek] ?? 0;  // Accessing the key "1" for the current week's score

  }

  Future<List<int>> getStatsForWeeks(List<int> weekNumbers, String userId) async {
    return Future.wait(
      weekNumbers.map((week) => getStata(week.toString(), userId)),
    );
  }
  Future<List<int>> getStatsForMonth(int monthNumber, String userId) async {
    int startWeek = (monthNumber - 1) * 4 + 1;
    List<int> weeks = List.generate(4, (index) => startWeek + index);

    return getStatsForWeeks(weeks, userId);
  }




}