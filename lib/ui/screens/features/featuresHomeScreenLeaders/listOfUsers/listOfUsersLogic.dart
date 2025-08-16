import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../model/modelUser.dart';

class ListOfUsersController {
  final AuthProviders authProviders;
  final BuildContext context;

  int? selectedCardIndex;
  int? weekToUse;
  TextEditingController searchAllUser = TextEditingController();
  String searchUser = '';
  bool click = false;
  List<String> attendedUsersCodes = [];

  List<MyUser> cachedUsers = [];

  ListOfUsersController(this.context) : authProviders = Provider.of<AuthProviders>(context, listen: false);

  Future<void> initializeData() async {
    await loadCachedUsers(); // ❗ لازم ده الأول
    if (cachedUsers.isEmpty) {
      await refreshUsersFromFirebase(); // لو مفيش بيانات في الكاش، حمل من Firebase
    }
    await loadAttendedUsers();
    print("cached===>${cachedUsers.length}");
  }


  Future<void> saveAttendedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('attended_users_codes', attendedUsersCodes);
  }

  Future<void> loadAttendedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedCodes = prefs.getStringList('attended_users_codes');
    if (savedCodes != null) {
      attendedUsersCodes = savedCodes;
    }
  }

  void handleSearchChange(String value) {
    searchUser = value;
  }

  void handleCardLongPress(int index) {
    click = true;
    selectedCardIndex = index == selectedCardIndex ? null : index;
  }

  void handleCardTap(int index) {
    click = false;
    selectedCardIndex = index == selectedCardIndex ? null : index;
  }

  void closeDetails() {
    selectedCardIndex = null;
  }

  void closeMenu(MyUser user) {
    selectedCardIndex = null;
    if (!attendedUsersCodes.contains(user.code)) {
      attendedUsersCodes.add(user.code);
      saveAttendedUsers();
    }
  }

  List<MyUser> filterUsers(List<MyUser> users) {
    return users.where((user) {
      return searchUser.isEmpty ||
          user.name.toLowerCase().startsWith(searchUser.toLowerCase());
    }).toList();
  }

  // ✅ حفظ اليوزرز كـ JSON في SharedPreferences
  Future<void> cacheUsers(List<MyUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((u) => u.toJson()).toList();
    await prefs.setString('cached_users', jsonEncode(usersJson)); // ✅ استخدم jsonEncode هنا
    cachedUsers = users;
  }

  // ✅ تحميل اليوزرز من SharedPreferences
  Future<void> loadCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('cached_users');
    if (cachedString != null) {
      try {
        final List<dynamic> list = jsonDecode(cachedString);
        cachedUsers = list.map((json) => MyUser.fromJson(json)).toList();
      } catch (e) {
        print('Error loading cached users: $e');
        cachedUsers = [];
      }
    }
  }

  // ✅ جلب البيانات الجديدة من Firebase وتخزينها
  Future<void> refreshUsersFromFirebase() async {
     await authProviders.readUsersToLeadersForList(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
    );
    cachedUsers = authProviders.users;
    await cacheUsers(cachedUsers);
  }
}
