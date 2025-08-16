import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/modelData.dart';
import '../../../model/modelMonth.dart';
import '../../../model/modelUser.dart';
import '../../../model/modelYear.dart';
import '../../../model/modelweek.dart';

class FireBaseSetDataForUser {
  static const String taskCollection = 'task';
  static const String answerCollection = 'answer';
  static const String summaryCollection = 'summary';
  static const String weeklyScoresCollection = 'weeklyScores';
  static const String opinionScoresCollection = 'opinion';

  static Future<void> sendAnswer(
      {required String answer, required String name}) async {
    late String firstId;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(FireBaseSetDataForUser.taskCollection)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      firstId = snapshot.docs.first.id;
    }
    FirebaseFirestore.instance
        .collection(FireBaseSetDataForUser.taskCollection)
        .doc(firstId.toString())
        .collection(FireBaseSetDataForUser.answerCollection)
        .add({'answer': answer, 'sender': name});
  }



  static Future<int> getScore({
    required String yearId,
    required String weekId,
    required String monthId,
    required String scoreType,
    required String userId,
  }) async {
    try {
      // نفترض أن بيانات المستخدم محفوظة في مجموعة "users"
      DocumentSnapshot doc = await FirebaseFirestore.instance
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
        .collection(MyUser.collection)
        .doc(userId)
        .collection(FireBaseSetDataForUser.summaryCollection)
        .doc(FireBaseSetDataForUser.weeklyScoresCollection);

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
  static Future<void> getThisWeek({required String userId, required String monthId,required int numWeekUse,required int numWeek}) async {

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
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
        int  score = data['score'] ?? 0;

        FireBaseSetDataForUser.updateWeekScoreAndTotal(
          userId: userId,
          weekNumber:numWeekUse.toString(),
          score: score,
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  // دالة التصويت أو إلغاء التصويت
  static Future<MyUser?> readUserData2(String userId) async {
    var snapshot =
        await FirebaseFirestore.instance.collection(MyUser.collection).doc(userId).get();

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

  static Future<void> saveProfileUrlToFirestore(
      {required String imageUrl, required String userId}) async {
    // البحث عن أول وثيقة في المجموعة
    var querySnapshot = await FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(userId)
        .get();

    await FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(userId)
        .update({
      "profileUrl": imageUrl,
    });
  }

  static Future<void> upvoteOpinion(String opinionId, String userId) async {
    final opinionRef =
        FirebaseFirestore.instance.collection(FireBaseSetDataForUser.opinionScoresCollection).doc(opinionId);

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

  static Future<void> addOpinionUser(String opinionText, String userId) async {
    await FirebaseFirestore.instance.collection(FireBaseSetDataForUser.opinionScoresCollection).add({
      'opinion': opinionText,
      'Time': Timestamp.now().toDate(),
      'votes': 0,
      'voters': [],
      'userId': userId, // إضافة معرف المستخدم
    });
  }






}
