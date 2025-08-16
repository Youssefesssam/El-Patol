import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consts {
  static String? path;

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String? testName = prefs.getString("name");
    return testName;
  }static Future<String?> getFacebook() async {
    final prefs = await SharedPreferences.getInstance();
    String? Facebook = prefs.getString("facebook");
    return Facebook;
  }static Future<String?> getWhatsapp() async {
    final prefs = await SharedPreferences.getInstance();
    String? Whatsapp = prefs.getString("whatsapp");
    return Whatsapp;
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    return email;
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");
    return phone;
  }

  static Future<String?> getTalent() async {
    final prefs = await SharedPreferences.getInstance();
    String? talent = prefs.getString("talent");
    return talent;
  }

  static Future<String?> getUniversity() async {
    final prefs = await SharedPreferences.getInstance();
    String? university = prefs.getString("university");
    return university;
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString("gender");
    return gender;
  }

  static Future<String?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? profile = prefs.getString("profile");
    return profile;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    return userId;
  }

  static Future<String?> getUserGovernorate() async {
    final prefs = await SharedPreferences.getInstance();
    String? governorateName = prefs.getString("governorateName");
    return governorateName;
  }


  static Future<String?> getUserchurchName() async {
    final prefs = await SharedPreferences.getInstance();
    String? church = prefs.getString("church");
    return church;
  }

  static Future<String?> getUserStage() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage = prefs.getString("stage");
    return stage;
  }

  static Future<String?> getUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("user_code");
    return code;
  }
  static Future<String?> getUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    String? age = prefs.getString("age");
    return age;
  }

  static Future<String?> getUserchurchCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? church_code = prefs.getString("church_code");
    return church_code;
  }
  static Future<String?> getUserStageType() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage_type = prefs.getString("stage_type");
    return stage_type;
  }
  static Future<String?> getUserStageYear() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage_year = prefs.getString("stage_year");
    return stage_year;
  }

  static Future<String?> getSweetTalkId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sweetId = prefs.getString("sweetId");
    return sweetId;
  }

  static Future<String?> getHiEventId() async {
    final prefs = await SharedPreferences.getInstance();
    String? hiEventId = prefs.getString("hiEventId");
    return hiEventId;
  }

  static Future<String?> getWordId() async {
    final prefs = await SharedPreferences.getInstance();
    String? wordId = prefs.getString("wordId");
    return wordId;
  }

  static Future<String?> getScore() async {
    final prefs = await SharedPreferences.getInstance();
    String? score = prefs.getString("score");
    return score;
  }

  static Future<String?> getAgeLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? age = prefs.getString("age");
    return age;
  }

  static Future<String?> getChurchLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? church = prefs.getString("church");
    return church;
  }

  static Future<String?> getCodeLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("code");
    return code;

  }static Future<String?> getCodeMasterLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("master_code");
    return code;
  }

  static Future<String?> getGenderLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString("gender");
    return gender;
  }

  static Future<String?> getGovernorateLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? governorate = prefs.getString("governorate");
    return governorate;
  }

  static Future<String?> getImageLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? image = prefs.getString("image");
    return image;
  }

  static Future<String?> getNameLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    return name;
  }

  static Future<String?> getPhoneLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");
    return phone;
  }

  static Future<String?> getRoleLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");
    return role;
  }

  static Future<String?> getSpecialtyLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? specialty = prefs.getString("specialty");
    return specialty;
  }

  static Future<String?> getStage_codeLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage_code = prefs.getString("stage_code");
    return stage_code;
  }

  static Future<String?> getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString("address");
    return address;
  }



  static Widget fetcher(Future<String?> function, TextStyle style) {
    return FutureBuilder<String?>(
      future: function, // استدعاء الدالة التي تجلب الاسم
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Text(
          snapshot.data!, // عرض الاسم المخزن
          style: style,
        )
            : Text(
          "", // عرض الاسم المخزن
          style: style,
        );
      },
    );
  }

  static Future<void> pathImg() async {
    path = await Consts.getProfile();
  }

  //code
  static Future<String?> getStageTypeLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage_type = prefs.getString("stage_type");
    return stage_type;
  }

  static Future<String?> getStageYearLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? stage_year = prefs.getString("stage_year");
    return stage_year;
  }

  static Future<String?> getChurchCodeLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? church_code = prefs.getString("church_code");
    return church_code;
  }
  static Future<String?> getChurchCodeMasterLeader() async {
    final prefs = await SharedPreferences.getInstance();
    String? church_code = prefs.getString("church_code");
    return church_code;
  }

  static Future<String?> getGovernorateCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? governorateCode = prefs.getString("governorateCode");
    return governorateCode;
  }

  static Future<String?> getGovernorateName() async {
    final prefs = await SharedPreferences.getInstance();
    String? governorateName = prefs.getString("governorateName");
    return governorateName;
  }
}
