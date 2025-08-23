import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/screens/utilites/consts.dart';
class AuthProviders extends ChangeNotifier {


  //current user data
  String? _userId;
  String? _profileURl;
  String? _name;

  String? _phone;
  String? _email;
  String? _code;
  String? _codeUs;


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

  //////////



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



  String? get code => _code;

  String? get codeUs => _codeUs;


  String? get ageUser => _ageUser;

  String? get stageTypeUser => _stageTypeUser;

  String? get stageYearUser => _stageYearUser;



  String? get phone => _phone;

  String? get email => _email;



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




  void setCodeLeader(String codeLeader) {
    _codeLeader = codeLeader;
    notifyListeners();
  }

  void setCodeMaster(String codeMaster) {
    _codeMaster = codeMaster;
    notifyListeners();
  }

  //28





  SharedPreferences? sharedPreferences;







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
