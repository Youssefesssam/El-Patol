import 'package:flutter/material.dart';

class MonthProvider with ChangeNotifier {
  int _selectedMonth = 1;

  int get selectedMonth => _selectedMonth;

  void updateMonth(int newMonth) {
    _selectedMonth = newMonth;
    notifyListeners();
  }
}
