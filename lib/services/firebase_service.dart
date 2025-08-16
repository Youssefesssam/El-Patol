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
static Future<void> addChurchCode({required String governorate,required String churchCode,required String churchName}) async{
    await FirebaseFirestore.instance.collection("governorate").doc(governorate).collection("church").doc(churchCode).set({
      "name":churchName,
    });
}
 static Future<void> addNewMasterLeader(
     String governorateCode,
     String churchCode,
     String specialty,
     ) async {
   String governorate = await GovernorateService.getName(governorateCode, 'en'); // ✅ await هنا
   final collectionRef = FirebaseFirestore.instance
       .collection("governorate")
       .doc(governorate)
       .collection('church')
       .doc(churchCode)
       .collection('master_leader_church');

   final snapshot = await collectionRef.get();

   if (snapshot.docs.isNotEmpty) {
     print('⚠️ يوجد بالفعل ليدر عام في هذه الكنيسة.');
     return;
   }

   final randomId = (Random().nextInt(9000) + 1000);
   final leaderCode = 'M$governorateCode$churchCode$randomId';

   String churchName = await ChurchService.getChurchName(governorate, churchCode); // ✅ await هنا

   await collectionRef.doc(leaderCode).set({
     'code': leaderCode,
     'name': 'الليدر العام - $specialty',
     'governorate': governorate,
     'church': churchName,
     'stage': 'X',
     'role': 'master_leader',
     'email': '',
     'specialty': specialty,
   });

   print('✅ تم إضافة الليدر العام بنجاح.');
 }

// دالة لإضافة ساب ليدر جديد بدون مرحلة
  static Future<String> addNewSubLeader(
      String governorateCode,
      String churchCode,
      String specialty,
      String leaderName,
      ) async {
    final randomId = randomNumeric(4);
    final leaderCode = 'L$governorateCode$churchCode$randomId';

    String governorate = GovernorateService.getName(governorateCode, 'en');
    String churchName = await ChurchService.getChurchName(governorate, churchCode);

    final subLeaderData = {
      'code': leaderCode,
      'name': leaderName,
      'governorate': governorate,
      'governorate_code': governorateCode,
      'church': churchName,
      'church_code': churchCode,
      'role': 'sub_leader',
      'specialty': specialty,
      'is_registered': false,
      'created_at': FieldValue.serverTimestamp(),
    };

    // حفظ الساب ليدر مباشرة تحت الكنيسة بدون مرحلة
    await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('sub_leaders_church')
        .doc(leaderCode) // كل ليدر كوثيقة مستقلة
        .set(subLeaderData);

    // يمكن حفظ نسخة إضافية في مجموعة sub_leaders الرئيسية إذا أردت
    return leaderCode;
  }

  // دالة لإضافة مستخدم جديد
  static Future<String> addNewUser(
      String governorateCode,
      String churchCode,
      String stageCode,
      String userName) async {
    print("Add new user now");

    final randomId = generateRandomNumber(4);
    final userCode = 'U$governorateCode$churchCode$stageCode$randomId';
    final stageType = stageCode[0];
    final stageYear = stageCode.length > 1 ? stageCode.substring(1) : '';
    String governorate = GovernorateService.getName(governorateCode, 'en');

    // ✅ استخدم await لانتظار اسم الكنيسة
    String churchName = await ChurchService.getChurchName(governorate, churchCode);

    final userData = {
      'code': userCode,
      'name': userName,
      'governorate': governorate,
      'governorate_code': governorateCode,
      'church': churchName, // ✅ تم تعديلها لتصبح String
      'church_code': churchCode,
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
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc('${stageType}_$stageYear')
        .collection('users')
        .doc(userCode)
        .set(userData);

    print("user addddedddddd");

    return userCode;
  }

  // دالة لجلب جميع المستخدمين لمرحلة معينة
  static Future<QuerySnapshot> getUsersByStage(String stageType, String stageYear) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc('M011013977')
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('users')
        .get();
  }

  // دالة لجلب جميع الساب ليدرز لمرحلة معينة
  static Future<QuerySnapshot> getSubLeadersByStage(String stageType, String stageYear) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc('M011013977')
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('sub_leaders')
        .get();
  }

  static  Future<DocumentSnapshot> getSelectedSubLeaderByStage(
      String stageType,
      String stageYear,
      String leaderId,
      String subLeaderId
      ) async {
    return await FirebaseService._firestore
        .collection('leaders')
        .doc(leaderId)  // Using parameter instead of hardcoded value
        .collection('stages')
        .doc('${stageType}_$stageYear')
        .collection('sub_leaders')
        .doc(subLeaderId)  // Using parameter instead of hardcoded value
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
     String governorate,
     String churchCode,
     String Code,
     ) async {
   try {
     final snapshot = await FirebaseService._firestore
         .collection("governorate")
         .doc(governorate)
         .collection('church')
         .doc(churchCode)
         .collection('sub_leaders_church')
         .doc(Code)
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
 static Map<String, dynamic> codeDetails(String code,String type) {
   String? governateCode;
   String? governateName;
   String churchCode;
   String stageType;
   String stageYear;
   String stageCode;
   if (code.length >= 8 && code.startsWith(type)) {
     governateCode = code.substring(1, 3);
     governateName=GovernorateService.getName(governateCode,"en");// مثلاً 01
     churchCode = code.substring(3, 6);          // مثلاً 002
     stageType = code[6];                        // مثلاً L
     stageYear = code.substring(7, 8);           // مثلاً 1
   } else {
     churchCode = 'XXX';
     stageType = 'X';
     stageYear = 'X';
     governateCode = null;
   }

   stageCode = '${stageType}_$stageYear';

   print("$governateCode ======= $churchCode ======= $stageCode====$governateName");

   return {
     "governateCode": governateCode,
     "governateName": governateName,
     "churchCode": churchCode,
     "stageCode": stageCode,
   };
 }


}