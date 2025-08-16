import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalScoresCacheHelper {
  static const String _weeksKey = 'cached_weeks';

  /// حفظ بيانات أسبوع معين
  static Future<void> saveWeekScoresLocally({
    required String weekNumber,
    required Map<String, Map<String, int>> scores,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // تحويل map إلى JSON
    final jsonEncoded = jsonEncode(scores);

    await prefs.setString('weekScores_$weekNumber', jsonEncoded);

    // حفظ قائمة الأسبوعات
    List<String> weeks = prefs.getStringList(_weeksKey) ?? [];
    if (!weeks.contains(weekNumber)) {
      weeks.add(weekNumber);
    }

    // لو أكثر من 4، احذف الأقدم
    if (weeks.length > 6) {
      String oldestWeek = weeks.removeAt(0);
      await prefs.remove('weekScores_$oldestWeek');
    }

    await prefs.setStringList(_weeksKey, weeks);
  }

  /// جلب بيانات أسبوع معين (لو موجود محليًا)
  static Future<Map<String, Map<String, int>>?> getWeekScoresLocally(String weekNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('weekScores_$weekNumber');
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      final result = decoded.map((key, value) => MapEntry(
        key,
        Map<String, int>.from(value),
      ));

      return result;
    } catch (_) {
      return null;
    }
  }

  /// حذف كل البيانات المحلية (اختياري عند تسجيل الخروج)
  static Future<void> clearAllLocalScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> weeks = prefs.getStringList(_weeksKey) ?? [];

    for (String week in weeks) {
      await prefs.remove('weekScores_$week');
    }

    await prefs.remove(_weeksKey);
  }
}