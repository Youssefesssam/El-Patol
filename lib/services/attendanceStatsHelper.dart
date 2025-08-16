import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase/fireBase/fireBaseForLeader/secend firebase.dart';

class AttendanceStatsHelper {
  static const List<String> monthNames = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر",
  ];

  static const String _cachedMonthsKey = 'cached_months_';

  // دالة مساعدة للحصول على مفتاح التخزين الخاص بالبيانات
  static String _getStorageKey(String governorate, String church, String stageCode) {
    return '${_cachedMonthsKey}${governorate}_${church}_${stageCode}';
  }

  // جلب الشهور المخزنة محليًا
  static Future<Map<String, dynamic>?> _getCachedMonths(
      String governorate, String church, String stageCode
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getStorageKey(governorate, church, stageCode);
      final cachedData = prefs.getString(key);
      if (cachedData != null) {
        return Map<String, dynamic>.from(json.decode(cachedData));
      }
    } catch (e) {
      print('❌ Error reading cached months: $e');
    }
    return null;
  }

  // حفظ الشهور محليًا
  static Future<void> _cacheMonths(
      String governorate,
      String church,
      String stageCode,
      Map<String, dynamic> monthsData
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getStorageKey(governorate, church, stageCode);
      await prefs.setString(key, json.encode(monthsData));
    } catch (e) {
      print('❌ Error caching months: $e');
    }
  }

  // جلب الإحصائيات الشهرية مع التخزين المؤقت
  static Future<Map<String, double>> getAllMonthlyStats({
    required String governorate,
    required String church,
    required String stageCode,
    List<String>? skipMonths,
    bool forceRefresh = false, // لجلب البيانات الجديدة رغم وجودها مخزنة
  }) async {
    try {
      // جلب البيانات المخزنة إذا لم نكن نريد تحديثها
      if (!forceRefresh) {
        final cachedData = await _getCachedMonths(governorate, church, stageCode);
        if (cachedData != null) {
          return Map<String, double>.from(cachedData['averages'] ?? {});
        }
      }

      await SecondFirebase.initialize();

      final doc = await SecondFirebase.firestore
          .collection("governorate")
          .doc(governorate)
          .collection("church")
          .doc(church)
          .collection("master_leader_church")
          .doc("basic")
          .collection("stage")
          .doc(stageCode)
          .get();

      if (!doc.exists) return {};

      final data = doc.data()!;
      if (data['weeks'] == null) return {};

      final weeks = Map<String, dynamic>.from(data['weeks']);
      final totalUsers = data['stageTotalUsers'] as int;
      final Map<String, List<int>> groupedByMonth = {};

      weeks.forEach((key, value) {
        if (key.startsWith("weeks.")) {
          final weekNumber = int.tryParse(key.split(".").last);
          if (weekNumber != null) {
            final month = ((weekNumber - 1) ~/ 4) + 1;
            final monthKey = "month_$month";
            groupedByMonth.putIfAbsent(monthKey, () => []);
            groupedByMonth[monthKey]!.add(value);
          }
        }
      });

      final Map<String, double> monthlyAverages = {};
      groupedByMonth.forEach((month, values) {
        if ((skipMonths == null || !skipMonths.contains(month)) && values.isNotEmpty) {
          monthlyAverages[month] = (values.reduce((a, b) => a + b) / (values.length*totalUsers))*100;
        }
      });

      // تخزين البيانات الجديدة
      await _cacheMonths(governorate, church, stageCode, {
        'averages': monthlyAverages,
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      return monthlyAverages;
    } catch (e) {
      print("❌ Error in getAllMonthlyStats: $e");
      // في حالة الخطأ، نعيد البيانات المخزنة إن وجدت
      final cachedData = await _getCachedMonths(governorate, church, stageCode);
      return Map<String, double>.from(cachedData?['averages'] ?? {});
    }
  }

  // جلب الإحصائيات الشهرية (المجموع) مع التخزين المؤقت
  static Future<Map<String, int>> getMonthStats({
    required String governorate,
    required String church,
    required String stageCode,
    bool forceRefresh = false,
  }) async {
    try {
      // جلب البيانات المخزنة إذا لم نكن نريد تحديثها
      if (!forceRefresh) {
        final cachedData = await _getCachedMonths(governorate, church, stageCode);
        if (cachedData != null) {
          return Map<String, int>.from(cachedData['sums'] ?? {});
        }
      }

      await SecondFirebase.initialize();

      final doc = await SecondFirebase.firestore
          .collection("governorate")
          .doc(governorate)
          .collection("church")
          .doc(church)
          .collection("master_leader_church")
          .doc("basic")
          .collection("stage")
          .doc(stageCode)
          .get();

      if (!doc.exists) return {};

      final data = doc.data()!;
      if (data['weeks'] == null) return {};

      final weeks = Map<String, dynamic>.from(data['weeks']);
      final Map<String, List<int>> groupedByMonth = {};

      weeks.forEach((key, value) {
        if (key.startsWith("weeks.")) {
          final weekNumber = int.tryParse(key.split(".").last);
          if (weekNumber != null) {
            final month = ((weekNumber - 1) ~/ 4) + 1;
            final monthKey = "month_$month";
            groupedByMonth.putIfAbsent(monthKey, () => []);
            groupedByMonth[monthKey]!.add(value);
          }
        }
      });

      final Map<String, int> monthlySums = {};
      groupedByMonth.forEach((month, values) {
        if (values.isNotEmpty) {
          monthlySums[month] = values.reduce((a, b) => a + b);
        }
      });

      // تخزين البيانات الجديدة
      await _cacheMonths(governorate, church, stageCode, {
        'sums': monthlySums,
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      return monthlySums;
    } catch (e) {
      print("❌ Error in getMonthStats: $e");
      // في حالة الخطأ، نعيد البيانات المخزنة إن وجدت
      final cachedData = await _getCachedMonths(governorate, church, stageCode);
      return Map<String, int>.from(cachedData?['sums'] ?? {});
    }
  }

  // دالة لجلب آخر وقت تم فيه التحديث
  static Future<DateTime?> getLastUpdateTime(
      String governorate, String church, String stageCode
      ) async {
    final cachedData = await _getCachedMonths(governorate, church, stageCode);
    if (cachedData != null && cachedData['lastUpdated'] != null) {
      return DateTime.tryParse(cachedData['lastUpdated']);
    }
    return null;
  }
}