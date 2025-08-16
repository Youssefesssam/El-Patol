import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


import '../model/modelUser.dart';
import '../model/modelUserAttend.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/churchService.dart';
import '../ui/screens/utilites/consts.dart';
import 'fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import 'fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import 'fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;
  int? week;
  int? weekUse;
  String? currentMonth;
  List<MyUser> users = [];
  List<User> usersAttend = [];
  List<int> absentWeek = [];
  List<Map<String, dynamic>> absentUsers = []; // تخزين الاسم + عدد مرات الغياب
  bool get isUserLoggedIn => currentUser != null;

  String? _sweetId;
  String? _wordId;
  String? _hiEventId;

  //current user data
  String? _userId;
  String? _profileURl;
  String? _name;
  String? _address;
  String? _talent;
  String? _phone;
  String? _email;
  String? _code;
  String? _codeUs;
  String? _university;
  String? _gender;
  String? _facebook;
  String? _whatsapp;

  String? _codeMaster;
  String? _churchCodeMaster;
  String? _governorateMaster;

  String? _codeLeader;
  String? _phoneLeader;
  String? _nameLeader;
  String? _genderLeader;
  String? _ageLeader;
  String? _ageUser;
  String? _codeSubLeader;
  String? _stageTypeLeader;
  String? _stageYearLeader;
  String? _stageTypeUser;
  String? _stageYearUser;
  String? _specialtyLeader;
  String? _roleLeader;

  //common
  String? _stageCode;
  String? _stageCodeUs;
  String? _church;
  String? _churchUs;
  String? _churchCodeL;
  String? _churchCode;
  String? _governorateUs;
  String? _governorate;
  String? _governorateCode;

  /////////////////////////////////
  int _countUserAttend =0;
  int _countUserUnAttend =0;
  //////////

  int get countUserAttend => _countUserAttend;
  int get countUserUnAttend => _countUserUnAttend;


  String? get codeMaster => _codeMaster;
  String? get governorateMaster => _governorateMaster;
  String? get churchCodeMaster => _churchCodeMaster;

  String? get codeLeader => _codeLeader;

  String? get userId => _userId;

  String? get governorateUs => _governorateUs;

  String? get governorate => _governorate;

  String? get governorateCode => _governorateCode;

  String? get churchCodeL => _churchCodeL;

  String? get churchCodeUs => _churchCode;

  String? get profileURl => _profileURl;

  String? get name => _name;

  String? get facebook => _facebook;

  String? get whatsapp => _whatsapp;

  String? get code => _code;

  String? get codeUs => _codeUs;

  String? get talent => _talent;

  String? get gender => _gender;

  String? get ageUser => _ageUser;

  String? get stageTypeUser => _stageTypeUser;

  String? get stageYearUser => _stageYearUser;

  String? get address => _address;

  String? get university => _university;

  String? get phone => _phone;

  String? get email => _email;

  int? get currentWeek => week;

  String? get sweetId => _sweetId;

  String? get wordId => _wordId;

  String? get hiEventId => _hiEventId;

  String? get nameL => _nameLeader;

  String? get codeSubl => _codeSubLeader;

  String? get stageCodeUs => _stageCodeUs;

  String? get stageCode => _stageCode;

  String? get stageTypeL => _stageTypeLeader;

  String? get stageYearL => _stageYearLeader;

  String? get ageL => _ageLeader;

  String? get genderLeader => _genderLeader;

  String? get phoneL => _phoneLeader;

  String? get church => _church;

  String? get churchUs => _churchUs;

  String? get specialtyL => _specialtyLeader;

  String? get roleL => _roleLeader;

  Future<void> countUserAttendFun(int attend) async {
    final prefs = await SharedPreferences.getInstance();

    if (attend == 0) {
      _countUserAttend = 0;
    } else {
      _countUserAttend += attend;
    }

    // احفظ القيمة
    await prefs.setInt('user_attend_count', _countUserAttend);

    notifyListeners();
  }

  // 🆕 أضف هذه الدالة لتحميل الرقم عند بداية التطبيق
  Future<void> loadUserAttendCountFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _countUserAttend = prefs.getInt('user_attend_count') ?? 0;
    notifyListeners();
  }

  void setCodeLeader(String codeLeader) {
    _codeLeader = codeLeader;
    notifyListeners();
  }

  void setCodeMaster(String codeMaster) {
    _codeMaster = codeMaster;
    notifyListeners();
  }

  //28
  void setWeek(int numweek) {
    print('===============================');
    print('numWeek ===============================$numweek');
    print('🧭 StackTrace:\n${StackTrace.current}');
    print('===============================');
    weekUse = numweek;
    week = (numweek - 1) % 4 + 1;
    notifyListeners();
    print('week in auth ===============================$week');
    print('weekUse in auth ===============================$weekUse');
  }

  void setCurrentMonth(int weekfun) {
    print('===============================');
    print('🧭 StackTrace:\n${StackTrace.current}');
    print('===============================');

    print(
      '+++++++++++++ week to cnvert to month in auth: $weekfun -------------',
    );
    int month = (weekfun - 1) ~/ 4 + 1;
    currentMonth = month.toString().padLeft(2, '0');
    notifyListeners();
    print('+++++++++++++month now in auth: $currentMonth -------------');
  }

  void setSweetId(String sweetId) {
    _sweetId = sweetId;
    notifyListeners();
  }

  void setwordId(String wordId) {
    _wordId = wordId;
    notifyListeners();
  }

  void sethiEventId(String hiEventId) {
    _hiEventId = hiEventId;
    notifyListeners();
  }

  SharedPreferences? sharedPreferences;

  void changeUser({
    required MyUser newUser,
    required String governorate,
    required String church,
    required String stage,
  }) {
    if (newUser.id.isEmpty) {
      print("Error: newUser ID is empty");
      return;
    }
    currentUser = newUser;
    print("Changed current user to: ${currentUser?.name}");
    readUsersToLeaders(governorate: governorate, church: church, stage: stage);
    notifyListeners();
  }

  void readUsersToLeaders({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      final List<Map<String, dynamic>> result =
      await New_fire_base_get_data_for_leader.getAllUsersFromNestedStructure(
        governorateName: governorate,
        churchCode: church,
        stageCode: stage,
      );

      print('Result from Firebase: $result'); // <-- خطوة مهمة

      if (result.isEmpty) {
        print('No data found in the specified path');
      }

      List<MyUser> fetchedUsers = result
          .map((data) => MyUser.fromJson(data))
          .toList();

      users = fetchedUsers; // تأكد إنها _users وليس users
      notifyListeners();
    } catch (e) {
      print("Error reading users: $e");
    }
  }
  Future<void> readUsersToLeadersForList({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      final List<Map<String, dynamic>> result =
      await New_fire_base_get_data_for_leader.getAllUsersFromNestedStructure(
        governorateName: governorate,
        churchCode: church,
        stageCode: stage,
      );

      print('Result from Firebase: $result'); // <-- خطوة مهمة

      if (result.isEmpty) {
        print('No data found in the specified path');
      }

      List<MyUser> fetchedUsers = result
          .map((data) => MyUser.fromJson(data))
          .toList();

      users = fetchedUsers; // تأكد إنها _users وليس users
      notifyListeners();
    } catch (e) {
      print("Error reading users: $e");
    }
  }

  void readUsersAttendToLeaders({
    required int numWeek,
    required BuildContext context,
  }) {
    AuthProviders authProviders = Provider.of<AuthProviders>(
      context,
      listen: false,
    );
    try {
      // مسح بيانات الأسبوع السابق
      usersAttend.clear();

      CollectionReference<User> attendCollection =
      New_fire_base_set_data_for_leader.getAttend(
        numWeek: numWeek,
        governorate: authProviders.governorate!,
        church: authProviders.churchCodeL!,
        stage: authProviders.stageCode!,
      );

      attendCollection.snapshots().listen(
            (querySnapshot) {
          usersAttend = querySnapshot.docs.map((doc) => doc.data()).toList();
          notifyListeners(); // تحديث الواجهة عند وصول بيانات جديدة
        },
        onError: (e) {
          print("Error reading attendance: $e");
        },
      );
    } catch (e) {
      print("Error setting up listener: $e");
    }
  }

  void calculateAbsentUsers(int currentWeek) async {
    try {
      Map<String, int> absenceCount = {};

      for (var user in users) {
        // إذا لم يكن هناك lackWeek، نعتبر أن المستخدم لم يفتقد من قبل
        if (user.lackWeek == null) continue;

        // نبدأ الحساب من الأسبوع التالي لآخر افتقاد
        int startWeek = user.lackWeek! + 1;

        // نتأكد أن startWeek ليس أكبر من currentWeek
        if (startWeek > currentWeek) continue;

        // عدد الأسابيع المطلوب حسابها
        int weeksToCalculate = currentWeek - startWeek + 1;

        // إذا لم يكن هناك أسابيع للحساب
        if (weeksToCalculate <= 0) continue;

        absenceCount[user.id] = 0; // نبدأ العد من الصفر لهذا المستخدم

        for (int week = startWeek; week <= currentWeek; week++) {
          CollectionReference<User> attendCollection =
          FireBaseSetDataForLeader.getAttend(week);
          QuerySnapshot<User> querySnapshot = await attendCollection.get();

          List presentUserIds = querySnapshot.docs
              .map((doc) =>
          doc
              .data()
              .id)
              .toList();

          if (!presentUserIds.contains(user.id)) {
            absenceCount[user.id] = (absenceCount[user.id] ?? 0) + 1;
          }
        }

        // في حالة وجود غياب، نقوم بزيادة absencesSinceLack في Firestore
      }

      // تحديث البيانات فقط للمستخدمين الذين لديهم غيابات
      absentUsers =
          absenceCount.entries.where((entry) => entry.value > 0).map((entry,) {
            MyUser user = users.firstWhere((u) => u.id == entry.key);

            FireBaseSetDataForLeader.addAbsent(
              id: user.id,
              name: user.name,
              absentCount: entry.value,
              email: user.email,
              address: user.address,
              phone: user.phone,
              profile: user.profileUrl,
              whatsapp: user.phone,
              lack: user.lack,
              lackWeek: currentWeek,
              // نحدث lackWeek إلى الأسبوع الحالي
              facebook: user.facebook,
            );

            return {
              "name": user.name,
              "absences": entry.value,
              "id": user.id,
              "profile": user.profileUrl,
              "email": user.email,
              "phone": user.phone,
              "address": user.address,
              "whatsapp": user.phone,
              "lack": user.lack,
              "lackWeek": currentWeek,
              "facebook": user.facebook,
            };
          }).toList();

      notifyListeners();
    } catch (e) {
      print("Error calculating absences since last lack: $e");
    }
  }

  Stream<Map<int, bool>> streamWeekStatuses({
    required int monthNum,
    required String governorateName,
    required String churchCode,
    required String stage,
    required String id,
  }) {
    List<int> weeksToCheck = [];

    switch (monthNum) {
      case 1:
        weeksToCheck = [1, 2, 3, 4];
        break;
      case 2:
        weeksToCheck = [5, 6, 7, 8];
        break;
      case 3:
        weeksToCheck = [9, 10, 11, 12];
        break;
      case 4:
        weeksToCheck = [13, 14, 15, 16];
        break;
      case 5:
        weeksToCheck = [17, 18, 19, 20];
        break;
      case 6:
        weeksToCheck = [21, 22, 23, 24];
        break;
      case 7:
        weeksToCheck = [25, 26, 27, 28];
        break;
      case 8:
        weeksToCheck = [29, 30, 31, 32];
        break;
      case 9:
        weeksToCheck = [33, 34, 35, 36];
        break;
      case 10:
        weeksToCheck = [37, 38, 39, 40];
        break;
      case 11:
        weeksToCheck = [41, 42, 43, 44];
        break;
      case 12:
        weeksToCheck = [45, 46, 47, 48];
        break;
      default:
        weeksToCheck = [];
    }

    return FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorateName)
        .collection('church')
        .doc(churchCode)
        .collection('activites')
        .doc(stage)
        .collection('numWeek')
        .snapshots()
        .asyncMap((querySnapshot) async {
      Map<int, bool> weekStatus = {};

      for (int week in weeksToCheck) {
        DocumentSnapshot<
            Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection("governorate")
            .doc(governorateName)
            .collection('church')
            .doc(churchCode)
            .collection('activites')
            .doc(stage)
            .collection('numWeek')
            .doc(week.toString())
            .collection("attend")
            .doc(id)
            .get();

        // true = غياب | false = حضور
        weekStatus[week] = !snapshot.exists;
      }

      return weekStatus;
    });
  }

  Future<void> setDataForUser({
    required String nameU,
    required String ageU,
    required String emailU,
    required String talentU,
    required String universityU,
    required String phoneU,
    required String genderU,
    required String profileU,
    required String codeU,
    required String addressU,
    required String churchCodeU,
    required String governateCodeU,
    required String governorateNameForUser,
    required String stageCodeUser,
    required String stageTypeUser,
    required String stageYearUser,
    required String idForUser,
    required String churchU,
    required String whatsapp,
    required String facebook,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences == null) {
      print("❌ Error: sharedPreferences is null");
      return;
    }

    // 🟢 Print all values before saving
    print("🔹 name: $nameU");
    print("🔹 whatsapp: $whatsapp");
    print("🔹 facebook: $facebook");
    print("🔹 userId: $idForUser");
    print("🔹 email: $emailU");
    print("🔹 age: $ageU");
    print("🔹 talent: $talentU");
    print("🔹 university: $universityU");
    print("🔹 phone: $phoneU");
    print("🔹 gender: $genderU");
    print("🔹 profile: $profileU");
    print("🔹 code: $codeU");
    print("🔹 address: $addressU");
    print("🔹 church_code: $churchCodeU");
    print("🔹 stage: $stageCodeUser");
    print("🔹 stage_year: $stageYearUser");
    print("🔹 stage_type: $stageTypeUser");
    print("🔹 church: $churchU");
    print("🔹 governorateCode: $governateCodeU");
    print("🔹 governorateName: $governorateNameForUser");

    // ✅ Save to SharedPreferences
    await sharedPreferences?.setString("name", nameU);
    await sharedPreferences?.setString("userId", idForUser);
    await sharedPreferences?.setString("email", emailU);
    await sharedPreferences?.setString("age", ageU);
    await sharedPreferences?.setString("talent", talentU);
    await sharedPreferences?.setString("university", universityU);
    await sharedPreferences?.setString("phone", phoneU);
    await sharedPreferences?.setString("gender", genderU);
    await sharedPreferences?.setString("profile", profileU);
    await sharedPreferences?.setString("user_code", codeU);
    await sharedPreferences?.setString("address", addressU);
    await sharedPreferences?.setString("church_code", churchCodeU);
    await sharedPreferences?.setString("stage", stageCodeUser);
    await sharedPreferences?.setString("whatsapp", whatsapp);
    await sharedPreferences?.setString("facebook", facebook);
    await sharedPreferences?.setString("stage_year", stageYearUser);
    await sharedPreferences?.setString("stage_type", stageTypeUser);
    await sharedPreferences?.setString("church", churchU);
    await sharedPreferences?.setString("governorateCode", governateCodeU);
    await sharedPreferences?.setString(
        "governorateName", governorateNameForUser);

    print("✅ بيانات المستخدم تم تخزينها في SharedPreferences");

    // 🟢 Set to provider and print after
   // await setUserData();

    // 🟣 Print from AuthProvider
    print(
        "🔁 بيانات المستخدم بعد التحميل من SharedPreferences داخل AuthProvider:");
    print("🔸 الاسم: $_name");
    print("🔸 فيسبوك: $_facebook");
    print("🔸 واتساب: $_whatsapp");
    print("🔸 الإيميل: $_email");
    print("🔸 التليفون: $_phone");
    print("🔸 العمر: $_ageUser");
    print("🔸 النوع: $_gender");
    print("🔸 العنوان: $_address");
    print("🔸 الجامعة: $_university");
    print("🔸 المواهب: $_talent"); // لو مخزنتهاش في AuthProvider ضيفها
    print("🔸 الكود: $_codeUs");
    print("🔸 المرحلة: $_stageCodeUs");
    print("🔸 سنة المرحلة: $_stageYearUser");
    print("🔸 نوع المرحلة: $_stageTypeUser");
    print("🔸 اسم الكنيسة: $_churchUs");
    print("🔸 كود الكنيسة: $_churchCode");
    print("🔸 كود المحافظة: $_governorateCode");
    print("🔸 اسم المحافظة: $_governorateUs");
    print("🔸 ID: $_userId");
    print("🔸 الصورة: $_profileURl");
  }

  Future<void> setUserData() async {
    print("get data from shired to provider");
    String? codeUser = await Consts.getUserCode(); //1
    print("User Code: $codeUser");

    String? stageCode = await Consts.getUserStage();
    print("Stage Code: $stageCode");
    String? talent = await Consts.getTalent();
    print("talent: $talent");

    String? stageType = await Consts.getUserStageType();
    print("Stage Type: $stageType");

    String? stageYear = await Consts.getUserStageYear();
    print("Stage Year: $stageYear");

    String? age = await Consts.getUserAge();
    print("Age: $age");

    String? gender = await Consts.getGender();
    print("Gender: $gender");

    String? address = await Consts.getAddress();
    print("Address: $address");

    String? name = await Consts.getName();
    print("Name: $name");

    String? id = await Consts.getUserId();
    print("User ID: $id");

    String? email = await Consts.getEmail();
    print("Email: $email");

    String? university = await Consts.getUniversity();
    print("University: $university");

    String? profile = await Consts.getProfile();
    print("Profile URL: $profile");

    String? governorateName = await Consts.getUserGovernorate();
    print("Governorate Name: $governorateName");

    String? phone = await Consts.getPhone();
    print("Phone: $phone");

    String? churchName = await Consts.getUserchurchName();
    print("Church Name: $churchName");

    String? governorateCodeUser = await Consts.getGovernorateCode();
    print("Governorate Code: $governorateCodeUser");

    String? churchCode = await Consts.getUserchurchCode();
    print("Church Code: $churchCode");
    String? whatsappUser = await Consts.getWhatsapp();
    print("whatsappUser: $whatsappUser");
    String? facebookUser = await Consts.getFacebook();
    print("facebookUser : $facebookUser");

    // حفظ البيانات في المتغيرات
    _gender = gender;
    _stageCodeUs = stageCode;
    _stageTypeUser = stageType;
    _stageYearUser = stageYear;
    _ageUser = age;
    _governorateUs = governorateName;
    _governorateCode = governorateCodeUser;
    _churchUs = churchName;
    _churchCode = churchCode;
    _name = name;
    _address = address;
    _email = email;
    _talent = talent;
    _phone = phone;
    _profileURl = profile;
    _userId = id;
    _university = university;
    _codeUs = codeUser;
    _facebook=facebookUser;
    _whatsapp=whatsappUser;
    notifyListeners();
    print(
        "🔁 بيانات المستخدم بعد التحميل من SharedPreferences داخل AuthProvider:");
    print("🔸 الاسم: $_name");
    print("🔸 الإيميل: $_email");
    print("🔸 التليفون: $_phone");
    print("🔸 العمر: $_ageUser");
    print("🔸 النوع: $_gender");
    print("🔸 العنوان: $_address");
    print("🔸 الجامعة: $_university");
    print("🔸 المواهب: $_talent"); // لو مخزنتهاش في AuthProvider ضيفها
    print("🔸 الكود: $_codeUs");
    print("🔸 المرحلة: $_stageCodeUs");
    print("🔸 سنة المرحلة: $_stageYearUser");
    print("🔸 نوع المرحلة: $_stageTypeUser");
    print("🔸 اسم الكنيسة: $_churchUs");
    print("🔸 كود الكنيسة: $_churchCode");
    print("🔸 كود المحافظة: $_governorateCode");
    print("🔸 اسم المحافظة: $_governorateUs");
    print("🔸 ID: $_userId");
    print("🔸 الصورة: $_profileURl");
    print("DONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNEEEEEEEEEEEE");
  }


  Future<void> setDataForSubLeader({
    required String name,
    required String code,
    required String gender,
    required String phone,
    required String specialty,
    required String role,
    required String age,
    required String image,
    required String governorateNameL,
    required String governorateCodeL,
    required String church_code,
    required String church,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (name.isEmpty || code.isEmpty) {
      print("Error: Required fields are empty");
      return;
    }
    print(code);
    print(name);
    print(gender);
    print(phone);
    print(specialty);
    print(role);
    print(age);
    print(governorateNameL);
    print(image);
    print("${church_code}4444444444444444444");
    print(church);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("code", code);
    await sharedPreferences!.setString("gender", gender);
    await sharedPreferences!.setString("phone", phone);
    await sharedPreferences!.setString("specialty", specialty);
    await sharedPreferences!.setString("role", role);
    await sharedPreferences!.setString("age", age);
    await sharedPreferences!.setString("governorateName", governorateNameL);
    await sharedPreferences!.setString("governorateCode", governorateCodeL);
    await sharedPreferences!.setString("image", image);
    await sharedPreferences!.setString("church_code", church_code);
    await sharedPreferences!.setString("church", church);

    print("✅ بيانات الخادم تم تخزينها في SharedPreferences");
    notifyListeners();
  }

  Future<void> saveDataForLeader() async {
    String? codeSubLeader = await Consts.getCodeLeader(); //1
    String? stageCodeLeader = await Consts.getStage_codeLeader();
    String? stageTypeLeader = await Consts.getStageTypeLeader();
    String? stageYearLeader = await Consts.getStageYearLeader();
    String? ageLeader = await Consts.getAgeLeader();
    String? genderLeader = await Consts.getGender();
    String? nameLeader = await Consts.getNameLeader();
    String? governorateName = await Consts.getGovernorateName();
    String? phoneLeader = await Consts.getPhoneLeader();
    String? churchLeader = await Consts.getChurchLeader();
    String? specialtyLeader = await Consts.getSpecialtyLeader();
    String? roleLeader = await Consts.getRoleLeader();
    String? governorateCode = await Consts.getGovernorateCode();
    String? churchCode = await Consts.getChurchCodeLeader();
    print('///////////////////////////////////////////');
    print('codeSubLeader  $codeSubLeader');
    print("stageCodeLeader  $stageCodeLeader");
    print("stageTypeLeader  $stageTypeLeader");
    print("stageYearLeader  $stageYearLeader");
    print("ageLeader  $ageLeader");
    print("genderLeader  $genderLeader");
    print("nameLeader  $nameLeader");
    print("governorateLeader  $governorateName");
    print("phoneLeader  $phoneLeader");
    print("churchLeader  $churchLeader");
    print("churchCode  $churchCode");
    print("specialty  $specialtyLeader");
    print("role  $roleLeader");
    print('///////////////////////////////////////////');
    setDataForLeader(
      name: nameLeader,
      code: codeSubLeader,
      stageCode: stageCodeLeader,
      stageType: stageTypeLeader,
      stageYear: stageYearLeader,
      age: ageLeader,
      gender: genderLeader,
      governorate: governorateName,
      phone: phoneLeader,
      church: churchLeader,
      specialty: specialtyLeader,
      role: roleLeader,
      governorateCode: governorateCode,
      churchCode: churchCode,
    );
    print('********************************************');

    print('codeSubLeader  $codeSubLeader');
    print("stageCodeLeader  $stageCodeLeader");
    print("stageTypeLeader  $stageTypeLeader");
    print("stageYearLeader  $stageYearLeader");
    print("ageLeader  $ageLeader");
    print("genderLeader  $genderLeader");
    print("nameLeader  $nameLeader");
    print("governorateLeader  $governorateName");
    print("phoneLeader  $phoneLeader");
    print("churchLeader  $churchLeader");
    print("specialty  $specialtyLeader");
    print("role  $roleLeader");
    print('********************************************');
    notifyListeners();
  }

  void setDataForLeader({
    required String? name,
    required String? code,
    required String? stageCode,
    required String? stageType,
    required String? stageYear,
    required String? age,
    required String? gender,
    required String? governorate,
    required String? governorateCode,
    required String? phone,
    required String? church,
    required String? churchCode,
    required String? specialty,
    required String? role,
  }) {
    print('||||||||||||||||||||||||||||||||||||||||||||||||||||');

    print(code);
    print(stageCode);
    print(age);
    print(gender);
    print(governorate);
    print(church);

    print('||||||||||||||||||||||||||||||||||||||||||||||||||||');
    _nameLeader = name;
    _codeSubLeader = code;
    _church = church;
    _churchCodeL = churchCode;
    _phoneLeader = phone;
    _governorate = governorate;
    _governorateCode=governorateCode;
    _genderLeader = gender;
    _ageLeader = age;
    _stageCode = stageCode;
    _stageTypeLeader = stageType;
    _stageYearLeader = stageYear;
    _specialtyLeader = specialty;
    _roleLeader = role;
    print('=========================================================');
    print(nameL);

    print('======================================================');

    notifyListeners();
  }

  Future<void> calculateAbsentUser({
    required int currentWeek,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      Map<String, int> absenceCount = {};
      Map<int, List<String>> allAttendances = {};

      // 🔁 جلب بيانات الحضور لكل أسبوع من الأسبوع 1 إلى الأسبوع الحالي
      for (int week = 1; week <= currentWeek; week++) {
        var attendCollection = New_fire_base_set_data_for_leader.getAttend(
          numWeek: week,
          governorate: governorate,
          church: church,
          stage: stage,
        );

        var snapshot = await attendCollection.get();
        allAttendances[week] = snapshot.docs.map((doc) => doc.id).toList();
      }

      for (var user in users) {
        if (user.lackWeek == null) continue;

        // 🧮 نبدأ الحساب من الأسبوع بعد lackWeek
        int startWeek = user.lackWeek! + 1;
        if (startWeek > currentWeek) continue;

        int absences = 0;

        // 👇 فقط من startWeek إلى currentWeek
        for (int week = startWeek; week <= currentWeek; week++) {
          bool attended = allAttendances[week]?.contains(user.id) ?? false;
          if (!attended) {
            absences++;
          }
        }

        if (absences > 0) {
          absenceCount[user.id] = absences;
        }
      }

      // 📤 إرسال النتائج إلى Firebase
      await Future.wait(
        absenceCount.entries.map((entry) async {
          final user = users.firstWhere((u) => u.id == entry.key);

          await New_fire_base_set_data_for_leader.addAbsent(
            id: user.id,
            name: user.name,
            code: user.code,
            absentCount: entry.value,
            email: user.email,
            address: user.address,
            phone: user.phone,
            profile: user.profileUrl,
            whatsapp: user.phone,
            lack: user.lack,
            facebook: user.facebook,
            governorate: governorate,
            church: church,
            stage: stage,
          );
        }),
      );

      // 📋 تحديث قائمة الغيابات في الذاكرة
      absentUsers = absenceCount.entries.map((entry) {
        final user = users.firstWhere((u) => u.id == entry.key);
        return {
          "name": user.name,
          "absences": entry.value,
          "id": user.id,
          "profile": user.profileUrl,
          "email": user.email,
          "phone": user.phone,
          "address": user.address,
          "whatsapp": user.phone,
          "lack": user.lack,
          "lackWeek": currentWeek,
          "facebook": user.facebook,
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("❌ Error calculating absences: $e");
    }
  }

  static Future<void> addAttend({
    required String userId,
    required int week,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection("church")
        .doc(church)
        .collection("activites")
        .doc(stage)
        .collection("numWeek")
        .doc(week.toString())
        .collection("attend")
        .doc(userId) // ← أهم حاجة: الـ ID هو user.id
        .set({"attendedAt": DateTime.now()});
  }

  Future<void> updateUserData({
    required Map<String, dynamic> updatedData,
    required String governorate,
    required String church,
    required String stage,
    required String code,
    required String userId,
  }) async {
    await FirebaseFirestore.instance
        .collection("governorate").doc(governorate)
        .collection('church').doc(church)
        .collection('users_church').doc(stage)
        .collection('users').doc(code)
        .collection(MyUser.collection).doc(userId)
        .update(updatedData);
  }
  void updateProfileUrl(String newUrl) {
    _profileURl = newUrl;
    notifyListeners(); // This will rebuild widgets that depend on profileURl
  }

  Future<void> setDataForMaster({required String code,required String church_code,required String governorateName,})async{
    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString("church_code", church_code);
    await sharedPreferences!.setString("governorateName", governorateName);
    await sharedPreferences!.setString("master_code", code);
    await setMasterInProvider();
  }
  Future<void> setMasterInProvider() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String? codeMasterLeader = await Consts.getCodeMasterLeader(); // من SharedPreferences
    String? churchMasterLeader = await Consts.getChurchCodeMasterLeader();
    String? governorateName = await Consts.getGovernorateName();

    // ✅ اطبعي القيم اللي اتجابت من الشيرد
    print('🔹 code from SharedPrefs: $codeMasterLeader');
    print('🔹 church_code from SharedPrefs: $churchMasterLeader');
    print('🔹 governorateName from SharedPrefs: $governorateName');

    _codeMaster = codeMasterLeader;
    _churchCodeMaster = churchMasterLeader;
    _governorateMaster = governorateName;

    notifyListeners();
  }
}
