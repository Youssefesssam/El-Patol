import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/secend firebase.dart';
import '../../../../../../model/modelUserAttend.dart';

class AttendLogic {
  static const String sharedUserListKey = 'user_list_attendance';

  static Future<void> saveUserListToShared(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> userJsonList =
    users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(sharedUserListKey, userJsonList);
    print("save new data in shared");
  }

  static Future<List<User>> readUserListFromShared() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? userJsonList = prefs.getStringList(sharedUserListKey);

    if (userJsonList == null) return [];
print("read from shiredPrefrence");
    return userJsonList
        .map((userJson) => User.fromJson(jsonDecode(userJson)))
        .toList();
  }
  static Future<void> initialize(BuildContext context) async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    // Get old list from Shared
    final oldUserList = await readUserListFromShared();

    // Fetch from Firebase
    await fetchCurrentWeek(context);
     authProviders.readUsersAttendToLeaders(
      numWeek: authProviders.weekUse!,
      context: context,
    );
print("read from firebase and update shired");
    // Compare old list vs new list
    final newUserList = authProviders.usersAttend;
    final isNewUserAdded = !listsAreEqual(oldUserList, newUserList);

    if (isNewUserAdded) {
      await saveUserListToShared(newUserList);
    }
  }

// مثال مقارنة القوائم (ممكن تحسينها حسب الحاجة)
  static bool listsAreEqual(List<User> a, List<User> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id)
        print("no new data");
      return false;
    }
    print(" new data");

    return true;
  }

  static Future<void> fetchCurrentWeek(BuildContext context) async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    int? week = await New_fire_base_get_data_for_leader.getCurrentWeek(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
    );
    authProviders.setWeek(week!);
    authProviders.setCurrentMonth(week);
  }

  static List<User> filterUsers(List<User> users, String searchText) {
    return users.where((user) =>
    searchText.isEmpty || user.name!.toLowerCase().startsWith(searchText.toLowerCase())
    ).toList();
  }

  static void deleteUser(BuildContext context, User user, int index) {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    authProviders.usersAttend.removeAt(index);
    New_fire_base_set_data_for_leader.deleteUserFromAttend(
      id: user.id!,
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
      week: authProviders.weekUse!,
    );
  }

  static void saveWeeklyAttendanceData(BuildContext context, int data) {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    authProviders.countUserAttendFun(data);
    SecondFirebase.saveWeeklyData(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
      numWeek: authProviders.weekUse!,
      data: data,
    );
  }
}
