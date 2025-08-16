import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/firebase/fireBase/fireBaseForLeader/secend%20firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/modelData.dart';
import '../../../model/modelEvent.dart';
import '../../../model/modelMonth.dart';
import '../../../model/modelSweetTalk.dart';
import '../../../model/modelUser.dart';
import '../../../model/modelUserAttend.dart';
import '../../../model/modelYear.dart';
import '../../../model/modelweek.dart';
import '../../authProvider.dart';
import '../fireBaseForUser/fireBaseSetDataForUser.dart';
import 'New_fire_base_get_data_for_leader.dart';

class New_fire_base_set_data_for_leader {
  static const String taskCollection = 'task';
  static const String answerCollection = 'answer';
  static const String summaryCollection = 'summary';
  static const String weeklyScoresCollection = 'weeklyScores';
  static const String opinionScoresCollection = 'opinion';
  static const String wordScoresCollection = 'word';

  static Future<void> saveImageUrlEventToFirestore({
    required String imageUrl,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelHiEvent.collection)
          .doc(docId)
          .update({"image": imageUrl});
      print("✅ تم تحديث رابط الصورة في Firestore بنجاح");
    } else {
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelHiEvent.collection)
          .add({"image": imageUrl});
      print("✅ تم إضافة رابط الصورة إلى Firestore بنجاح");
    }
  }

  static Future<void> updateScore({
    required String userId,
    required String scoreType,
    required int newValue,
    required String yearId,
    required String monthId,
    required String weekId,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection("users_church")
        .doc(stage)
        .collection("users")
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
        .doc(ModelData.scoreCollection);

    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);

          int leaderScore = 0;
          int scoreSeenUserEvent = 0;
          int scoreSeenUserSweetTalk = 0;
          int scoreSeenUserWord = 0;
          int massScoreDB = 0;
          int communionScoreDB = 0;
          int confessionScoreDB = 0;
          int meetingScoreDB = 0;

          if (snapshot.exists) {
            leaderScore = snapshot.get("leaderScore") ?? 0;
            scoreSeenUserEvent = snapshot.get("scoreSeenUserEvent") ?? 0;
            scoreSeenUserSweetTalk =
                snapshot.get("scoreSeenUserSweetTalk") ?? 0;
            scoreSeenUserWord = snapshot.get("scoreSeenUserWord") ?? 0;
            massScoreDB = snapshot.get("massScoreDB") ?? 0;
            communionScoreDB = snapshot.get("communionScoreDB") ?? 0;
            confessionScoreDB = snapshot.get("confessionScoreDB") ?? 0;
            meetingScoreDB = snapshot.get("meetingScoreDB") ?? 0;
          } else {
            transaction.set(userRef, {
              "leaderScore": 0,
              "scoreSeenUserEvent": 0,
              "scoreSeenUserSweetTalk": 0,
              "scoreSeenUserWord": 0,
              "massScoreDB": 0,
              "communionScoreDB": 0,
              "confessionScoreDB": 0,
              "meetingScoreDB": 0,
              "score": 0,
            });
          }

          if (scoreType == "leaderScore") leaderScore = newValue;
          if (scoreType == "scoreSeenUserEvent") scoreSeenUserEvent = newValue;
          if (scoreType == "scoreSeenUserSweetTalk")
            scoreSeenUserSweetTalk = newValue;
          if (scoreType == "scoreSeenUserWord") scoreSeenUserWord = newValue;
          if (scoreType == "massScoreDB") massScoreDB = newValue;
          if (scoreType == "communionScoreDB") communionScoreDB = newValue;
          if (scoreType == "confessionScoreDB") confessionScoreDB = newValue;
          if (scoreType == "meetingScoreDB") meetingScoreDB = newValue;

          int totalScore =
              leaderScore +
              scoreSeenUserEvent +
              scoreSeenUserSweetTalk +
              scoreSeenUserWord;
          transaction.update(userRef, {
            "leaderScore": leaderScore,
            "scoreSeenUserEvent": scoreSeenUserEvent,
            "scoreSeenUserSweetTalk": scoreSeenUserSweetTalk,
            "scoreSeenUserWord": scoreSeenUserWord,
            "massScoreDB": massScoreDB,
            "communionScoreDB": communionScoreDB,
            "confessionScoreDB": confessionScoreDB,
            "meetingScoreDB": meetingScoreDB,
            "score": totalScore,
          });
        })
        .then((_) {
          print("done");
        })
        .catchError((error) {
          print("$error");
        });
  }

  static Future<void> sendTask({
    required String task,
    required String leader,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(New_fire_base_set_data_for_leader.taskCollection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String taskId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(New_fire_base_set_data_for_leader.taskCollection)
          .doc(taskId)
          .update({'task': task, 'leader': leader});
      print("updated");
    } else {
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(New_fire_base_set_data_for_leader.taskCollection)
          .add({'task': task, 'leader': leader});
      print("added");
    }
  }

  static void deleteUserFromAttend({
    required String id,
    required String governorate,
    required String church,
    required String stage,
    required int week,
  }) {
    FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection("numWeek")
        .doc(week.toString())
        .collection("attend")
        .doc(id)
        .delete();
  }

  static Future<void> addOpinionLeader({
    required String opinionText,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(New_fire_base_set_data_for_leader.opinionScoresCollection)
        .add({
          'opinion': opinionText,
          'Time': Timestamp.now().toDate(),
          'votes': 0,
          'voters': [],
        });
  }

  static CollectionReference<User> getAttend({
    required int numWeek,
    required String governorate,
    required String church,
    required String stage,
  }) {
    if (numWeek <= 0) {
      throw ArgumentError("numWeek must be a positive integer.");
    }
    return FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('numWeek')
        .doc(numWeek.toString()) // تأكد من تحويل الرقم إلى نص
        .collection('attend')
        .withConverter<User>(
          fromFirestore: (snapshot, options) {
            if (snapshot.data() == null) {
              throw Exception("Document data is null for week $numWeek");
            }
            return User.fromJson(snapshot.data()!);
          },
          toFirestore: (user, options) => user.toJson(),
        );
  }

  static Future<void> addUser({
    required String governate,
    required MyUser myUser,
    required String churchCode,
    required String stageCode,
    required String userCode,
  }) {
    return New_fire_base_get_data_for_leader.getUser(
      churchCode: churchCode,
      stageCode: stageCode,
      userCode: userCode,
      governate: governate,
    ).doc(myUser.id).set(myUser);
  }

  static Future<void> sendWord({
    required String message,
    required String sender,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      // الوصول إلى المجموعة
      CollectionReference wordsCollection = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(New_fire_base_set_data_for_leader.wordScoresCollection);

      // البحث عن الكلمة الموجودة بالفعل
      QuerySnapshot querySnapshot = await wordsCollection
          .where('message', isEqualTo: message)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await wordsCollection.doc(docId).update({
          'sender': sender,
          'Time': Timestamp.now(), // تحديث وقت الإرسال
        });
      } else {
        await wordsCollection.doc().set({
          'message': message,
          'sender': sender,
          'Time': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Eroor $e');
    }
  }

  static Future<void> numWeek({
    required int numWeek,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var weekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('numWeek')
        .doc(numWeek.toString());

    var doc = await weekRef.get();

    if (doc.exists) {
      print('week number exists');
    } else {
      DateTime now = DateTime.now();
      String dayName = _getDayName(now.weekday);

      await weekRef.set({
        'weekNum': numWeek,
        'date': now,
        'weekIsActive': true, // ممكن تغيرها حسب الحالة
        'dayOfRegistration': dayName,
        'expireAt': DateTime(now.year, now.month, now.day + 1),

      });
    }
  }
  /// دالة للحصول على اسم اليوم بالعربي أو الإنجليزي حسب رغبتك
  static String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'Saturday'; // أو 'السبت'
      case DateTime.sunday:
        return 'Sunday';
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      default:
        return 'Unknown';
    }
  }

  static Future<void> updateNextWeek({
    required int current,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final nextWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('nextWeek');
    await nextWeekRef.set({'weekNumber': current + 1});
  }

  static Future<void> updatePreviousWeek({
    required int current,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final nextWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('previousWeek');
    await nextWeekRef.set({'weekNumber': current});
  }

  static Future<void> updateCurrentWeek({
    required int weekNumber,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('currentWeek');
    await currentWeekRef.set({'weekNumber': weekNumber});
  }

  static Future<void> updateWeek({
    required int weekNumber,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('updateWeek');
    await currentWeekRef.set({'weekNumber': weekNumber});
  }

  static Future<void> attendUsers(
    int weekNum,
    User user,
    int totalScore,
    int massScore,
    int communionScore,
    int confessionScore,
    int meetingScore,
    String governorate,
    String church,
    String stage, {
    int seenWord = 0,
    int pons = 0,
    int winVoting = 0,
    int solTaskoo = 0,
    int rank = 0,
  }) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('numWeek') // مجموعة الأسابيع
        .doc(weekNum.toString()) // وثيقة الأسبوع الحالي
        .collection('attend') // مجموعة الحضور
        .doc(user.id); // استخدام اسم المستخدم كمفتاح للمستند

    await currentWeekRef.update({
      'name': user.name, // اسم المستخدم
      'id': user.id,
      'score': totalScore,
      'meetingScoreDB': meetingScore,
      'communionScoreDB': communionScore,
      'confessionScoreDB': confessionScore,
      'massScoreDB': massScore,
      'seenWord': seenWord,
    });
  }

  static Future<void> UsersAlreadyAttend({
    required int weekNum,
    required MyUser user,
    required int totalScore,
    required int massScore,
    required int communionScore,
    required int confessionScore,
    required int meetingScore,
    required String governorate,
    required String church,
    required String stage,
    required String profileUrl,
  }) async {
    try {
      final currentWeekRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection('numWeek')
          .doc(weekNum.toString())
          .collection('attend')
          .doc(user.id);

      await currentWeekRef.set({
        'name': user.name,
        'id': user.id,
        'code': user.code,
        'score': totalScore,
        'meetingScoreDB': meetingScore,
        'communionScoreDB': communionScore,
        'confessionScoreDB': confessionScore,
        'massScoreDB': massScore,
        'profileUrl': profileUrl,
        'attendanceDate': FieldValue.serverTimestamp(),
      });

      print('✅ Attendance for ${user.name} saved successfully.');
    } catch (e) {
      print('❌ Error in UsersAlreadyAttend: $e');
    }
  }

  static Future<void> sweetTalkSet({
    required String sweetTalk,
    required String imageUrl,
    required String governorate,
    required String church,
    required String stage,
    required String leader,
  }) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelSweetTalk.collection)
          .doc(textId)
          .update({'talk': sweetTalk, "image": imageUrl, 'leader': leader,});
      print("updated");
    } else {
      FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelSweetTalk.collection)
          .add({'talk': sweetTalk, 'leader': leader});
      print("added");
    }
  }

  static Future<void> saveImageSweetTalkUrlToFirestore({
    required String imageUrl,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    // البحث عن أول وثيقة في المجموعة
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // تحديث الوثيقة الأولى إذا وُجدت
      String docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelSweetTalk.collection)
          .doc(docId)
          .update({"image": imageUrl});
      print("✅ تم تحديث رابط الصورة في Firestore بنجاح");
    } else {
      // إذا لم تكن هناك وثائق، يتم إنشاء وثيقة جديدة
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelSweetTalk.collection)
          .add({"image": imageUrl});
      print("✅ تم إضافة رابط الصورة إلى Firestore بنجاح");
    }
  }

  static Future<void> HiEventSet({
    required String hiEvent,
    required String governorate,
    required String church,
    required String stage,
    required String leader,
  }) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelHiEvent.collection)
          .doc(textId)
          .update({'hiEvent': hiEvent, "leader": leader, });
      print("updated");
    } else {
      FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelHiEvent.collection)
          .add({'hiEvent': hiEvent, "leader": leader,});
      print("added");
    }
  }

  static Future<void> addAbsent({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String profile,
    required String address,
    required String whatsapp,
    required String facebook,
    required String governorate,
    required String church,
    required String stage,
    required String code,
    int lack = 0,
    int lackWeek = 0,
    required int absentCount,
  }) async {
    try {
      // الوصول إلى المجموعة
      CollectionReference absents = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection('absents');

      // البحث عن الكلمة الموجودة بالفعل
      QuerySnapshot querySnapshot = await absents
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await absents.doc(id).update({
          "id": id,
          "name": name,
          "count": absentCount,
          "code": code,
          "profile": profile,
          "email": email,
          "phone": phone,
          "address": address,
          "whatsapp": phone,
          "lack": lack,
          "facebook": facebook,
          "lackWeek": lackWeek,
        });
      } else {
        await absents.doc(id).set({
          "id": id,
          "name": name,
          "count": absentCount,
          "profile": profile,
          "email": email,
          "phone": phone,
          "code": code,
          "address": address,
          "whatsapp": phone,
          "lack": lack,
          "facebook": facebook,
          "lackWeek": lackWeek,
        });
      }
    } catch (e) {
      print('Eroor $e');
    }
  }

  static Future<void> updateLack({
    required String id,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection(MyUser.collection)
        .doc(id);

    final doc = await docRef.get();
    final currentLack = (doc.data()?["lack"] ?? 0) as int;
    await docRef.update({"lack": currentLack + 1});
  }

  static Future<void> updatelackWeek({
    required String id,
    required int currentWek,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection(MyUser.collection)
        .doc(id)
        .update({"lackWeek": currentWek});
  }

  static Stream<int> streamLackWeek({
    required String id,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) {
    return FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection(MyUser.collection) // أو حسب ما تستخدمه
        .doc(id)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>?;
            final lackWeek = data?['lack'];
            if (lackWeek is int) {
              return lackWeek;
            } else if (lackWeek is num) {
              return lackWeek.toInt();
            }
          }
          return 0;
        });
  }

  static Future<void> delAbsences({
    required String id,
    required String governorate,
    required String church,
    required String stage,
  }) {
    return FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('absents')
        .doc(id)
        .delete();
  }

  static Future<void> updateCustomScore({
    required String userId,
    required String weekNumber,
    required int score,
    required String scoreTypeDoc,
    required String governorate,
    required String church,
    required String code,
    required String stage, // اسم الدوكمنت المختلف لكل نوع
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection(MyUser.collection)
        .doc(userId)
        .collection(FireBaseSetDataForUser.summaryCollection)
        .doc(scoreTypeDoc); // مختلف لكل نوع

    final doc = await docRef.get();

    Map<String, dynamic> weekScores = {};

    if (doc.exists) {
      weekScores = doc.data()?['weekScores'] as Map<String, dynamic>? ?? {};
    }

    int? oldScore = weekScores[weekNumber.toString()] as int?;

    if (oldScore == score) {
      return;
    }

    weekScores[weekNumber.toString()] = score;

    int totalScore = 0;
    weekScores.forEach((key, value) {
      if (value is int) {
        totalScore += value;
      } else if (value is num) {
        totalScore += value.toInt();
      }
    });

    await docRef.set({
      'weekScores': weekScores,
      'totalScore': totalScore,
    }, SetOptions(merge: true));
  }

  static Future<void> getThisDetalsWeek({
    required String userId,
    required String monthId,
    required int numWeekUse,
    required int numWeek,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('users_church')
          .doc(stage)
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
        int massScore = data['massScoreDB'] ?? 0;
        int confessionScore = data['confessionScoreDB'] ?? 0;
        int communionScore = data['communionScoreDB'] ?? 0;
        int meetingScore = data['meetingScoreDB'] ?? 0;

        await New_fire_base_set_data_for_leader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: score,
          scoreTypeDoc: 'score',
          governorate: governorate,
          church: church,
          code: code,
          stage: stage,
        );

        await New_fire_base_set_data_for_leader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: massScore,
          scoreTypeDoc: 'massSummary',
          governorate: governorate,
          church: church,
          code: code,
          stage: stage,
        );
        await New_fire_base_set_data_for_leader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: confessionScore,
          scoreTypeDoc: 'confessionSummary',
          governorate: governorate,
          church: church,
          code: code,
          stage: stage,
        );
        await New_fire_base_set_data_for_leader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: communionScore,
          scoreTypeDoc: 'communionSummary',
          governorate: governorate,
          church: church,
          code: code,
          stage: stage,
        );
        await New_fire_base_set_data_for_leader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: meetingScore,
          scoreTypeDoc: 'meetingScoreDB',
          governorate: governorate,
          church: church,
          code: code,
          stage: stage,
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  // في FireBaseSetDataForLeader class

  static Stream<Map<String, Map<String, int>>> getAallScoresWeekStream({
    required String userId,
    required String weekNumber,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) {
    List<String> scoreTypes = [
      'score',
      'massSummary',
      'confessionSummary',
      'communionSummary',
      'meetingScoreDB',
    ];

    // تحويل كل نوع إلى Stream<DocumentSnapshot>
    List<Stream<DocumentSnapshot>> streams = scoreTypes.map((type) {
      return FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('users_church')
          .doc(stage)
          .collection('users')
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(New_fire_base_set_data_for_leader.summaryCollection)
          .doc(type)
          .snapshots();
    }).toList();

    // دمج جميع الاستريلات في واحد باستخدام Rx.combineLatest
    return CombineLatestStream.list(streams).map((snapshotList) {
      Map<String, Map<String, int>> result = {};

      for (var snapshot in snapshotList) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          final weekScores = data['weekScores'] as Map<String, dynamic>? ?? {};
          final totalScore = data['totalScore'] as int? ?? 0;
          final scoreType = snapshot.id;

          final weekScore = weekScores[weekNumber] as int? ?? 0;

          result[scoreType] = {
            'weekScore': weekScore,
            'totalScore': totalScore,
          };
        }
      }

      return result;
    });
  }
  static Future<Map<String, Map<String, int>>> getAallScoresWeek({
    required String userId,
    required String weekNumber,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    List<String> scoreTypes = [
      'score',
      'massSummary',
      'confessionSummary',
      'communionSummary',
      'meetingScoreDB',
    ];
    Map<String, Map<String, int>> result = {};
    for (String type in scoreTypes) {
      final docRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('users_church')
          .doc(stage)
          .collection('users')
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(FireBaseSetDataForUser.summaryCollection)
          .doc(type);
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final weekScores = data['weekScores'] as Map<String, dynamic>? ?? {};
        final totalScore = data['totalScore'] as int? ?? 0;
        final scoreForWeek = weekScores[weekNumber.toString()] as int? ?? 0;
        result[type] = {
          'weekScore': scoreForWeek is int ? scoreForWeek : 0,
          'totalScore': totalScore is int ? totalScore : 0,
        };
      } else {
        result[type] = {'weekScore': 0, 'totalScore': 0};
      }
    }
    return result;
  }

  // في FireBaseSetDataForLeader class

  static Future<Map<String, Map<String, int>>> getAllScoresForWeekOnce({
    required String userId,
    required String weekNumber,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    List<String> scoreTypes = [
      'score',
      'massSummary',
      'confessionSummary',
      'communionSummary',
      'meetingScoreDB',
    ];

    Map<String, Map<String, int>> result = {};

    for (String type in scoreTypes) {
      final docRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('users_church')
          .doc(stage)
          .collection('users')
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(New_fire_base_set_data_for_leader.summaryCollection)
          .doc(type);

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
        final weekScores = data['weekScores'] as Map<String, dynamic>? ?? {};
        final totalScore = data['totalScore'] as int? ?? 0;
        final weekScore = weekScores[weekNumber] as int? ?? 0;

        result[type] = {
          'weekScore': weekScore,
          'totalScore': totalScore,
        };
      }
    }

    return result;
  }



  static Future<void> saveWeeklyScoresInOneDoc({
    required String userId,
    required String weekNumber,
    required String governorate,
    required String church,
    required String code,
    required String stage,
    required int meetingScore,
    required int communionScore,
    required int massScore,
    required int confessionScore,
    required int totalScore,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection("church")
        .doc(church)
        .collection("users_church")
        .doc(stage)
        .collection("users")
        .doc(code)
        .collection('user')
        .doc(userId)
        .collection("weeklyScores")
        .doc(weekNumber);

    final data = {
      'meetingScoreDB': {
        'weekScore': meetingScore,
        'totalScore': meetingScore, // أو عدل حسب المجموع الكلي
      },
      'communionSummary': {
        'weekScore': communionScore,
        'totalScore': communionScore,
      },
      'massSummary': {
        'weekScore': massScore,
        'totalScore': massScore,
      },
      'confessionSummary': {
        'weekScore': confessionScore,
        'totalScore': confessionScore,
      },
      'score': {
        'weekScore': totalScore,
        'totalScore': totalScore,
      },
    };

    await docRef.set(data);
  }

  static Future<Map<String, Map<String, int>>> getWeeklyScoresFromOneDoc({
    required String userId,
    required String weekNumber,
    required String governorate,
    required String church,
    required String code,
    required String stage,
  }) async {
    final doc = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection('user')
        .doc(userId)
        .collection("weeklyScores")
        .doc(weekNumber)
        .get();

    // قائمة الأنواع الأساسية اللي نرجعها لو الوثيقة مش موجودة
    final defaultTypes = [
      'meetingScoreDB',
      'communionSummary',
      'massSummary',
      'confessionSummary',
      'score',
    ];

    if (!doc.exists) {
      return {
        for (var type in defaultTypes)
          type: {
            'weekScore': 0,
            'totalScore': 0,
          },
      };
    }

    final data = doc.data() as Map<String, dynamic>? ?? {};
    Map<String, Map<String, int>> result = {};

    for (final key in defaultTypes) {
      final typeData = data[key] as Map<String, dynamic>? ?? {};
      final weekScore = (typeData['weekScores'] ?? {})[weekNumber] ?? 0;
      final totalScore = typeData['totalScore'] ?? 0;

      result[key] = {
        'weekScore': weekScore,
        'totalScore': totalScore,
      };
    }

    return result;
  }
  static Future<int> getLastAvailableWeek({
    required String userId,
    required String code,
    required String church,
    required String governorate,
    required String stage,
    required String weekNumber,
  }) async {
    final colRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('users_church')
        .doc(stage)
        .collection('users')
        .doc(code)
        .collection('user')
        .doc(userId)
        .collection("weeklyScores"); // 👉 دي Collection مش Document

    final snapshot = await colRef.get(); // ✅ قراءة كل الوثائق داخل الـ Collection

    if (snapshot.docs.isEmpty) return 0;

    final weeks = snapshot.docs
        .map((doc) => int.tryParse(doc.id))
        .whereType<int>()
        .toList();

    weeks.sort();
    return weeks.isNotEmpty ? weeks.last : 0;
  }
  void sendListLengthToFirebase(int length) async {
    try {
      await FirebaseFirestore.instance.collection('stats').doc('list_info').set({
        'length': length,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('تم إرسال طول القائمة بنجاح: $length');
    } catch (e) {
      print('حدث خطأ أثناء إرسال طول القائمة: $e');
    }
  }

  static void saveStageUserCountIfChanged(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    int currentCount = authProviders.users.length;
    int? lastSavedCount = prefs.getInt('last_stage_user_count_${authProviders.stageCode!}');

    if (lastSavedCount != currentCount) {
      await prefs.setInt('last_stage_user_count_${authProviders.stageCode!}', currentCount);
      await SecondFirebase.saveStageUserCount(
        governorate: authProviders.governorate!,
        church: authProviders.churchCodeL!,
        stage: authProviders.stageCode!,
        totalUsers: currentCount,
      );
    }
  }


}
