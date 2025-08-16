import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/leader_model.dart';

class LeaderProvider with ChangeNotifier {
  LeaderModel? _currentLeader;
  String? _leaderCode;

  LeaderModel? get currentLeader => _currentLeader;
  String? get leaderCode => _leaderCode;

  // دالة لتحديث بيانات الليدر
  void setCurrentLeader(LeaderModel leader) {
    _currentLeader = leader;
    notifyListeners();
  }

  // دالة لتحديث كود الليدر فقط
  void setLeaderCode(String code) {
    _leaderCode = code;
    notifyListeners();
  }

  // دالة لجلب بيانات الليدر من Firebase وتخزينها في Provider
  Future<void> fetchAndStoreLeaderData(String code) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('leaders')
          .doc('M011013977')
          .collection('sub_leaders')
          .doc(code)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final leader = LeaderModel.fromMap(data);

        setCurrentLeader(leader); // تخزين بيانات الليدر
        setLeaderCode(code);      // تخزين الكود
      }
    } catch (e) {
      throw Exception('فشل في جلب بيانات الليدر: $e');
    }
  }
}