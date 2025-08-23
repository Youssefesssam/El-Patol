import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import '../models/leader_model.dart';
import 'churchService.dart';
import 'governorateserveces.dart';

abstract class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // المراجع الأساسية

  // دالة لإنشاء أرقام عشوائية
  static String generateRandomNumber(int digits) {
    final random = Random();
    int min = pow(10, digits - 1).toInt();
    int max = pow(10, digits).toInt() - 1;
    int number = min + random.nextInt(max - min);
    return number.toString();
  }

  // دالة للحصول على ليدر بواسطة الكود
  /* Future<LeaderModel?> getLeaderByCode(String code) async {
    final DocumentSnapshot snapshot = await leadersRef.collection('011').doc(code).get();
    if (snapshot.exists) {
      return LeaderModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }*/
  static Future<void> addCenterCode(
      {required String centerCode, required String churchName}) async {
    await FirebaseFirestore.instance.collection("center").doc(centerCode).set({
      "name": churchName,
    });
  }

  static Future<void> addNewMrLeader({
    required String centerCode,
    required String specialty,
    required String nameMr,
    required String image,
  }) async {
    final collectionRef = FirebaseFirestore.instance
        .collection("center")
        .doc(centerCode)
        .collection('Mr');

    final snapshot = await collectionRef.get();

    final randomId = (Random().nextInt(9000) + 1000);
    final leaderCode = 'Mr$centerCode$randomId';

    String centerName =
        await ChurchService.getChurchName(centerCode); // ✅ await هنا

    await collectionRef.doc(leaderCode).set({
      'code': leaderCode,
      'name': nameMr,
      'center name': centerName,
      'stage': 'X',
      'role': 'Mr',
      'email': '',
      'specialty': specialty,
      'image': image,
      'students': [],
    });

    print('✅ تم إضافة الليدر العام بنجاح.');
  }

  static Future<bool> checkMasterCode(String centerCode, String codeMr) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("center")
          .doc(centerCode)
          .collection('Mr')
          .doc(codeMr)
          .get();

      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }

// دالة لإضافة ساب ليدر جديد بدون مرحلة
  static Future<String> addNewSubLeader(String centerCode, String specialty,
      String leaderName, String codeMr) async {
    final randomId = randomNumeric(4);
    final leaderCode = 'L$centerCode$randomId';

    String churchName = await ChurchService.getChurchName(centerCode);

    final subLeaderData = {
      'code': leaderCode,
      'name': leaderName,
      'church': churchName,
      'centerCode': centerCode,
      'role': 'sub_leader',
      'specialty': specialty,
      'is_registered': false,
      'created_at': FieldValue.serverTimestamp(),
    };

    // حفظ الساب ليدر مباشرة تحت الكنيسة بدون مرحلة
    await FirebaseFirestore.instance
        .collection("center")
        .doc(centerCode)
        .collection('Mr')
        .doc(codeMr)
        .collection("assistant")
        .doc(leaderCode)
        .set(subLeaderData);

    // يمكن حفظ نسخة إضافية في مجموعة sub_leaders الرئيسية إذا أردت
    return leaderCode;
  }

  // دالة لإضافة مستخدم جديد
  static Future<String> addNewUser({
    required String centerCode,
    required String stageCode,
    required String userName,
    required String codeMr,
  }) async {
    print("Add new user now");

    final randomId = generateRandomNumber(4);
    final userCode = 'S$stageCode$centerCode$randomId';
    final stageType = stageCode[0];
    final stageYear = stageCode.length > 1 ? stageCode.substring(1) : '';

    // ✅ استخدم await لانتظار اسم الكنيسة
    String churchName = await ChurchService.getChurchName(centerCode);

    final userData = {
      'code': userCode,
      'name': userName,
      'church': churchName, // ✅ تم تعديلها لتصبح String
      'centerCode': centerCode,
      'stage_code': stageCode,
      'stage_type': stageType,
      'stage_year': stageYear,
      'role': 'user',
      'is_registered': false,
      'created_at': FieldValue.serverTimestamp(),
    };

    print("Add user data ");

    // إضافة المستخدم تحت المرحلة المناسبة

    await FirebaseService._firestore
        .collection("center")
        .doc(centerCode)
        .collection("Student")
        .doc('${stageType}_$stageYear')
        .collection('users')
        .doc(userCode)
        .set(userData);

    print("center---->>${centerCode}---->Mr---->${codeMr}------>Student${stageType}_${stageYear}--->users---->${userCode}");
    print("user addddedddddd");


    return userCode;
  }

  // دالة لجلب جميع المستخدمين لمرحلة معينة
  static Future<QuerySnapshot> getUsersByStage(
      String stageType, String stageYear) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc('M011013977')
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('users')
        .get();
  }

  // دالة لجلب جميع الساب ليدرز لمرحلة معينة
  static Future<QuerySnapshot> getSubLeadersByStage(
      String stageType, String stageYear) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc('M011013977')
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('sub_leaders')
        .get();
  }

  static Future<DocumentSnapshot> getSelectedSubLeaderByStage(String stageType,
      String stageYear, String leaderId, String subLeaderId) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc(leaderId) // Using parameter instead of hardcoded value
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('sub_leaders')
        .doc(subLeaderId) // Using parameter instead of hardcoded value
        .get();
  }

  // دالة لجلب جميع مراحل ليدر معين
  static Future<QuerySnapshot> getLeaderStages() async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc('M011013977')
        .collection('stages')
        .get();
  }

  // أضف هذه الدالة داخل كلاس FirebaseService
  static Future<LeaderModel?> getSubLeaderByCode(String code) async {
    try {
      final snapshot = await FirebaseService._firestore
          .collection('leaders')
          .doc('M011013977')
          .collection('sub_leaders')
          .doc(code)
          .get();

      if (snapshot.exists) {
        return LeaderModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting sub-leader: $e');
      return null;
    }
  }

  static Future<LeaderModel?> getCodeSubLeader(
    String centerCode,
    String code,
    String codeMr,
  ) async {
    try {
      final snapshot = await FirebaseService._firestore
          .collection("center")
          .doc(centerCode)
          .collection('Mr')
          .doc(codeMr)
          .collection("assistant")
          .doc(code)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();

        return LeaderModel.fromMap(data!);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  static Map<String, dynamic> codeDetails(String code, String type) {
    String churchCode;
    String stageType;
    String stageYear;
    String stageCode;
    if (code.length >= 8 && code.startsWith(type)) {
      churchCode = code.substring(2, 5); // مثلاً 002
      stageType = code[6]; // مثلاً L
      stageYear = code.substring(7, 8); // مثلاً 1
    } else {
      churchCode = 'XXX';
      stageType = 'X';
      stageYear = 'X';
    }

    stageCode = '${stageType}_$stageYear';

    print("======= $churchCode ======= $stageCode====");

    return {
      "churchCode": churchCode,
      "stageCode": stageCode,
    };
  }
}
