import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangProvider extends ChangeNotifier {
  Locale _current_Locale = const Locale("en");
  Locale get currentLocale => _current_Locale;

  Future<void> setLocale(String languageCode) async {
    _current_Locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", languageCode);
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString("language");
    _current_Locale = Locale(language ?? 'en');
    notifyListeners();
  }
}
