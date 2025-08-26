import 'package:shared_preferences/shared_preferences.dart';

class ConstsWeb {
  // المفاتيح
  static const String stageName = "stageName";
  static const String location = "location";
  static const String codeStudent = "codeStudent";
  static const String email = "email";
  static const String phoneStudent = "phoneStudent";
  static const String phoneParent = "phoneParent";
  static const String stageCode = "stageCode";
  static const String centerCode = "centerCode";
  static const String name = "name";
  static const String password = "password";

  /// حفظ بيانات String
  static Future<void> setStudentData({required String key,required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// قراءة بيانات String
  static Future<String?> getStudentData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// حذف مفتاح محدد
  static Future<void> remove({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// مسح كل البيانات
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
