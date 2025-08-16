import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../firebase/authProvider.dart';
import '../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../model/modelEvent.dart';
import '../../../../model/modelSweetTalk.dart';
import 'package:provider/provider.dart';

import 'componentScreenUser/ad.dart';
import 'mainComponent/compitionWidget/compettion/prize/dailyCheckInScreen.dart';

class HomeScreenUserViewModel extends ChangeNotifier {
  bool isLoading = false;
  double dragOffset = 0.0;

  void showAdOnInit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = "${today.year}-${today.month}-${today.day}";

    final lastShownDate = prefs.getString("lastAdShownDate");

    if (lastShownDate == todayKey) return; // تم العرض اليوم بالفعل

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // عرض الإعلان أولاً
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const AdInterFace(),
        ),
      );

      // بعد غلق الإعلان، عرض نافذة الحضور اليومي
      await showDialog(
        context: context,
        builder: (context) =>
            const DailyCheckInDialog(), // Dialog مخصص للحضور اليومي
      );

      // حفظ تاريخ العرض
      await prefs.setString("lastAdShownDate", todayKey);
    });
  }


  bool isShimmering = true;


  Future<void> saveUserWeekInProvider({
    required BuildContext context,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection("church")
        .doc(church)
        .collection("activites")
        .doc(stage)
        .collection('settings')
        .doc('currentWeek')
        .get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!.containsKey("weekNumber")) {
      final auth = Provider.of<AuthProviders>(context, listen: false);
      auth.setWeek(snapshot["weekNumber"]);
      auth.setCurrentMonth(snapshot["weekNumber"]);
    }
  }

  Future<bool> hasNew(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> keys = {
      "event": "lastEventId",
      "word": "lastWordId",
      "task": "lastTaskId",
      "sweet": "lastSweetId",
    };

    if (!keys.containsKey(type)) return false;

    String lastId = prefs.getString(keys[type]!) ?? "";
    String newId = await hasNotification(type);

    return lastId != newId;
  }

  Future<String> hasNotification(String type) async {
    Map<String, String> collections = {
      "event": ModelHiEvent.collection,
      "word": "word",
      "task": "task",
      "sweet": ModelSweetTalk.collection,
    };

    if (!collections.containsKey(type)) return "";

    var fire = await FirebaseFirestore.instance
        .collection(collections[type]!)
        .limit(1)
        .get();

    return fire.docs.isNotEmpty ? fire.docs.first.id : "";
  }

  Future<void> startLoading(AuthProviders auth) async {
    isLoading = true;
    notifyListeners();

    await New_fire_base_set_data_for_user.getThisWeek(
      userId: auth.userId!,
      numWeek: auth.currentWeek!,
      monthId: auth.currentMonth!,
      numWeekUse: auth.weekUse!,
      governorate: auth.governorateUs!,
      churchCode: auth.churchCodeUs!,
      stageCode: auth.stageCodeUs!,
      code: auth.codeUs!,
    );

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    dragOffset = 0.0;
    notifyListeners();
  }

  void updateDrag(double value) {
    dragOffset += value * 0.2;
    notifyListeners();
  }

  void resetDrag() {
    dragOffset = 0.0;
    notifyListeners();
  }

}
