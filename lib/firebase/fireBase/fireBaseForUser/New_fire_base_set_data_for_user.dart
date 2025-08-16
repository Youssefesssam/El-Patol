import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/modelData.dart';
import '../../../model/modelMonth.dart';
import '../../../model/modelUser.dart';
import '../../../model/modelYear.dart';
import '../../../model/modelweek.dart';

class New_fire_base_set_data_for_user {
  static const String taskCollection = 'task';
  static const String answerCollection = 'answer';
  static const String summaryCollection = 'summary';
  static const String weeklyScoresCollection = 'weeklyScores';
  static const String opinionScoresCollection = 'opinion';

  static Future<void> sendAnswer({
    required String answer,
    required String name,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    late String firstId;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('task')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      firstId = snapshot.docs.first.id;
    }
    FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('task')
        .doc(firstId.toString())
        .collection(New_fire_base_set_data_for_user.answerCollection)
        .add({'answer': answer, 'sender': name});
  }

  static Future<int> getScore({
    required String yearId,
    required String weekId,
    required String monthId,
    required String scoreType,
    required String userId,
    required String governorate,
    required String church,
    required String stage,
    required String code,
  }) async {
    try {
      // نفترض أن بيانات المستخدم محفوظة في مجموعة "users"
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("governorate").doc(governorate)
          .collection('church')
          .doc(church)
          .collection('users_church')
          .doc(stage)
           .collection('users')
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(ModelYear.collection)
          .doc(yearId)
          .collection(ModelMonth.collection)
          .doc(monthId)
          .collection(ModelWeek.collection)
          .doc(weekId)
          .collection(ModelData.dataCollection)
          .doc(ModelData.scoreCollection)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data[scoreType] ?? 0;
      }
      return 0;
    } catch (e) {
      print("Error in getScore: $e");
      return 0;
    }
  }

  static Future<void> updateWeekScoreAndTotal({
    required String userId,
    required String weekNumber,
    required int score,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('church')
        .doc('011')
        .collection('users_church')
        .doc('P_2')
        .collection('users')
        .doc('U01101P24709')
        .collection(MyUser.collection)
        .doc(userId)
        .collection(New_fire_base_set_data_for_user.summaryCollection)
        .doc(New_fire_base_set_data_for_user.weeklyScoresCollection);

    final doc = await docRef.get();

    Map<String, dynamic> weekScores = {};

    if (doc.exists) {
      weekScores = doc.data()?['weekScores'] as Map<String, dynamic>? ?? {};
    }

    int? oldScore = weekScores[weekNumber.toString()] as int?;

    if (oldScore == score) {
      return;
    }

    // تحديث السكور
    weekScores[weekNumber.toString()] = score;

    // حساب totalScore
    int totalScore = 0;
    weekScores.forEach((key, value) {
      if (value is int) {
        totalScore += value;
      } else if (value is num) {
        totalScore += value.toInt();
      }
    });

    // التحديث النهائي
    await docRef.set({
      'weekScores': weekScores,
      'totalScore': totalScore,
    }, SetOptions(merge: true));
  }

  static Future<void> getThisWeek({
    required String userId,
    required String monthId,
    required int numWeekUse,
    required int numWeek,
    required String governorate,
    required String churchCode,
    required String stageCode,
    required String code,
  }) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection('users_church')
          .doc(stageCode)
          .collection('users')
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(ModelYear.collection)
          .doc("1")
          .collection(ModelMonth.collection)
          .doc(monthId)
          .collection(ModelWeek.collection)
          .doc(numWeek.toString())
          .collection(ModelData.dataCollection)
          .doc(ModelData.scoreCollection)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        int score = data['score'] ?? 0;

        New_fire_base_set_data_for_user.updateWeekScoreAndTotal(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: score,
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // دالة التصويت أو إلغاء التصويت
  static Future<MyUser?> readUserData2({
    required String governorate,
    required String churchCode,
    required String stageCode,
    required String code,
    required String userId,
  }) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stageCode)
        .collection('users')
        .doc(code)
        .collection(MyUser.collection)
        .doc(userId)
        .get();

    if (snapshot.exists) {
      print("Document exists!"); // لازم ده يطبع
      var data = snapshot.data();
      if (data != null) {
        print("Data fetched: $data"); // لازم يظهر البيانات هنا
        return MyUser.fromJson(data); // حول البيانات لنموذجك لو شغال صح
      } else {
        print("Document is empty or data() returned null.");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<void> saveProfileUrlToFirestore({
    required String imageUrl,
    required String userId,
    required String governorate,
    required String churchCode,
    required String stage,
    required String userCode,
  }) async {
    print("^^^^^^ $imageUrl^^^^^^^^^^^^^^^^^^^^");
    print("^^^^^^ $userId^^^^^^^^^^^^^^^^^^^^");
    print("^^^^^^ $governorate^^^^^^^^^^^^^^^^^^^^");
    print("^^^^^^ $stage^^^^^^^^^^^^^^^^^^^^");
    print("^^^^^^ $userCode^^^^^^^^^^^^^^^^^^^^");

    var querySnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(userCode)
        .collection(MyUser.collection)
        .doc(userId)
        .get();
    print("^^^^^^ $imageUrl^^^^^^^^^^^^^^^^^^^^");

    await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(userCode)
        .collection(MyUser.collection)
        .doc(userId)
        .update({"profileUrl": imageUrl});
    print("^^^^^^ $imageUrl^^^^^^^^^^^^^^^^^^^^");
  }

  static Future<void> upvoteOpinion({
    required String opinionId,
    required String userId,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final opinionRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(New_fire_base_set_data_for_user.opinionScoresCollection)
        .doc(opinionId);

    // جلب البيانات الحالية
    final doc = await opinionRef.get();

    // تحقق من وجود المستند
    if (!doc.exists) {
      throw Exception("المستند غير موجود!");
    }

    // تحقق من وجود حقل voters أو قم بإنشائه إذا لم يكن موجودًا
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final voters = List<String>.from(data['voters'] ?? []);

    if (voters.contains(userId)) {
      // إذا كان المستخدم قد صوت مسبقًا، قم بإزالة تصويته
      await opinionRef.update({
        'votes': FieldValue.increment(-1),
        'voters': FieldValue.arrayRemove([userId]),
      });
    } else {
      // إذا لم يكن المستخدم قد صوت مسبقًا، قم بإضافة تصويته
      await opinionRef.update({
        'votes': FieldValue.increment(1),
        'voters': FieldValue.arrayUnion([userId]),
      });
    }
  }
static Future<void> deleteOpinion({required String governorate,required String church,required String stage,})async {
  final opinionRef =await FirebaseFirestore.instance
      .collection("governorate")
      .doc(governorate)
      .collection('church')
      .doc(church)
      .collection('activites')
      .doc(stage)
      .collection(New_fire_base_set_data_for_user.opinionScoresCollection).get();
  for(DocumentSnapshot doc in opinionRef.docs){
doc.reference.delete();
  }
}
  static Future<void> addOpinionUser({required String opinionText, required String userId,required String governorateUs,required String churchCodeUs,required String stageCodeUs}) async {
    await   FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorateUs)
        .collection('church')
        .doc(churchCodeUs)
        .collection('activites')
        .doc(stageCodeUs)
        .collection(New_fire_base_set_data_for_user.opinionScoresCollection)
        .add({
          'opinion': opinionText,
          'Time': Timestamp.now().toDate(),
          'votes': 0,
          'userId': userId, // إضافة معرف المستخدم
        });
  }
}
