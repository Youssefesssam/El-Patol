import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/modelData.dart';
import '../../../model/modelEvent.dart';
import '../../../model/modelMonth.dart';
import '../../../model/modelSweetTalk.dart';
import '../../../model/modelUser.dart';
import '../../../model/modelUserAttend.dart';
import '../../../model/modelYear.dart';
import '../../../model/modelweek.dart';
import '../fireBaseForUser/fireBaseSetDataForUser.dart';
import 'fireBaseGetDataForeLeader.dart';

class FireBaseSetDataForLeader {
  static const String taskCollection = 'task';
  static const String answerCollection = 'answer';
  static const String summaryCollection = 'summary';
  static const String weeklyScoresCollection = 'weeklyScores';
  static const String opinionScoresCollection = 'opinion';
  static const String wordScoresCollection = 'word';

  static Future<void> saveImageUrlToFirestore(String imageUrl) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection(ModelHiEvent.collection)
          .doc(docId)
          .update({"image": imageUrl});
      print("✅ تم تحديث رابط الصورة في Firestore بنجاح");
    } else {
      await FirebaseFirestore.instance.collection(ModelHiEvent.collection).add({
        "image": imageUrl,
      });
      print("✅ تم إضافة رابط الصورة إلى Firestore بنجاح");
    }
  }

  static Future<void> updteScore({
    required String governate,
    required String userId,
    required String scoreType,
    required int newValue,
    required String yearId,
    required String monthId,
    required String weekId,
    required String churchCode,
    required String stage,
    required String userCode,
  }) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governate)
        .collection("church")
        .doc(churchCode)
        .collection("users_church")
        .doc(stage)
        .collection("users").doc(userCode)
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
  }) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection(FireBaseSetDataForLeader.taskCollection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String taskId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection(FireBaseSetDataForLeader.taskCollection)
          .doc(taskId)
          .update({'task': task, 'leader': leader});
      print("updated");
    } else {
      FirebaseFirestore.instance
          .collection(FireBaseSetDataForLeader.taskCollection)
          .add({'task': task, 'leader': leader});
      print("added");
    }
  }

  static void deleteDec(MyUser myUser) {
    FirebaseFirestore.instance
        .collection(MyUser.collection)
        .doc(myUser.id)
        .delete();
  }

  static Future<void> addOpinionLeader(String opinionText) async {
    await FirebaseFirestore.instance
        .collection(FireBaseSetDataForLeader.opinionScoresCollection)
        .add({
          'opinion': opinionText,
          'Time': Timestamp.now().toDate(),
          'votes': 0,
          'voters': [],
        });
  }

  static CollectionReference<User> getAttend(int numWeek) {
    if (numWeek <= 0) {
      throw ArgumentError("numWeek must be a positive integer.");
    }
    return FirebaseFirestore.instance
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
    return FireBaseGetDataForLeader.getUser(
      churchCode: churchCode,
      stageCode: stageCode,
      userCode: userCode,
      governate: governate,
    ).doc(myUser.id).set(myUser);
  }

  static Future<void> sendWord({
    required String message,
    required String sender,
  }) async {
    try {
      // الوصول إلى المجموعة
      CollectionReference wordsCollection = FirebaseFirestore.instance
          .collection(FireBaseSetDataForLeader.wordScoresCollection);

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

  static Future<void> numWeek({required numWeek}) async {
    var week = await FirebaseFirestore.instance
        .collection('numWeek')
        .doc(numWeek.toString());
    var doc = await week.get();
    if (doc.exists) {
      print('week number exit');
    } else {
      await week.set({'weekNum': numWeek, 'date': DateTime.now()});
    }
  }

  static Future<void> updateNextWeek(int current) async {
    final nextWeekRef = FirebaseFirestore.instance
        .collection('settings')
        .doc('nextWeek');
    await nextWeekRef.set({'weekNumber': current + 1});
  }

  static Future<void> updatePreviousWeek(int current) async {
    final nextWeekRef = FirebaseFirestore.instance
        .collection('settings')
        .doc('previousWeek');
    await nextWeekRef.set({'weekNumber': current});
  }

  static Future<void> updateCurrentWeek(int weekNumber) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek');
    await currentWeekRef.set({'weekNumber': weekNumber});
  }

  static Future<void> updateWeek(int weekNumber) async {
    final currentWeekRef = FirebaseFirestore.instance
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
    int meetingScore, {
    int seenWord = 0,
    int pons = 0,
    int winVoting = 0,
    int solTaskoo = 0,
    int rank = 0,
  }) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection('numWeek') // مجموعة الأسابيع
        .doc(weekNum.toString()) // وثيقة الأسبوع الحالي
        .collection('attend') // مجموعة الحضور
        .doc(user.id); // استخدام اسم المستخدم كمفتاح للمستند

    await currentWeekRef.set({
      'name': user.name, // اسم المستخدم
      'id': user.id,
      'score': totalScore,
      'meetingScoreDB': meetingScore,
      'communionScoreDB': communionScore,
      'confessionScoreDB': confessionScore,
      'massScoreDB': massScore,
      'seenWord': seenWord,
      'pons': pons,
      'winVoting': winVoting,
      'solTaskoo': solTaskoo,
      'rank': rank,
    });
  }

  static Future<void> UsersAreadyAttend(
    int weekNum,
    MyUser user,
    int totalScore,
    int massScore,
    int communionScore,
    int confessionScore,
    int meetingScore, {
    int seenWord = 0,
  }) async {
    final currentWeekRef = FirebaseFirestore.instance
        .collection('numWeek') // مجموعة الأسابيع
        .doc(weekNum.toString()) // وثيقة الأسبوع الحالي
        .collection('attend') // مجموعة الحضور
        .doc(user.id); // استخدام اسم المستخدم كمفتاح للمستند

    await currentWeekRef.set({
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

  static Future<void> sweetTalkSet({
    required String sweetTalk,
    required String imageUrl,
  }) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection(ModelSweetTalk.collection)
          .doc(textId)
          .update({'talk': sweetTalk, "image": imageUrl});
      print("updated");
    } else {
      FirebaseFirestore.instance.collection(ModelSweetTalk.collection).add({
        'talk': sweetTalk,
      });
      print("added");
    }
  }

  static Future<void> saveImageSweetTalkUrlToFirestore(String imageUrl) async {
    // البحث عن أول وثيقة في المجموعة
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // تحديث الوثيقة الأولى إذا وُجدت
      String docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection(ModelSweetTalk.collection)
          .doc(docId)
          .update({"image": imageUrl});
      print("✅ تم تحديث رابط الصورة في Firestore بنجاح");
    } else {
      // إذا لم تكن هناك وثائق، يتم إنشاء وثيقة جديدة
      await FirebaseFirestore.instance
          .collection(ModelSweetTalk.collection)
          .add({"image": imageUrl});
      print("✅ تم إضافة رابط الصورة إلى Firestore بنجاح");
    }
  }

  static Future<void> HiEventSet({required String hiEvent}) async {
    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (taskSnapshot.docs.isNotEmpty) {
      String textId = taskSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection(ModelHiEvent.collection)
          .doc(textId)
          .update({'hiEvent': hiEvent});
      print("updated");
    } else {
      FirebaseFirestore.instance.collection(ModelHiEvent.collection).add({
        'hiEvent': hiEvent,
      });
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
    int lack = 0,
    int lackWeek = 0,
    required int absentCount,
  }) async {
    try {
      // الوصول إلى المجموعة
      CollectionReference absents = FirebaseFirestore.instance.collection(
        'absents',
      );

      // البحث عن الكلمة الموجودة بالفعل
      QuerySnapshot querySnapshot = await absents
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await absents.doc(id).update({
          "id": id,
          "name": name,
          "count": absentCount,
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

  static Future<void> updateLack(String id, int lack) async {
    FirebaseFirestore.instance.collection(MyUser.collection).doc(id).update({
      "lack": lack + 1,
    });
  }

  static Future<void> updatelackWeek(String id, int currentWek) async {
    FirebaseFirestore.instance.collection(MyUser.collection).doc(id).update({
      "lackWeek": currentWek,
    });
  }

  static void delAbsences(String id) {
    FirebaseFirestore.instance.collection("absents").doc(id).delete();
  }

  static Future<void> updateCustomScore({
    required String userId,
    required String weekNumber,
    required int score,
    required String scoreTypeDoc, // اسم الدوكمنت المختلف لكل نوع
  }) async {
    final docRef = FirebaseFirestore.instance
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
  }) async {
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
        int score = data['score'] ?? 0;
        int massScore = data['massScoreDB'] ?? 0;
        int confessionScore = data['confessionScoreDB'] ?? 0;
        int communionScore = data['communionScoreDB'] ?? 0;
        int meetingScore = data['meetingScoreDB'] ?? 0;

        await FireBaseSetDataForLeader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: score,
          scoreTypeDoc: 'score',
        );

        await FireBaseSetDataForLeader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: massScore,
          scoreTypeDoc: 'massSummary',
        );
        await FireBaseSetDataForLeader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: confessionScore,
          scoreTypeDoc: 'confessionSummary',
        );
        await FireBaseSetDataForLeader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: communionScore,
          scoreTypeDoc: 'communionSummary',
        );
        await FireBaseSetDataForLeader.updateCustomScore(
          userId: userId,
          weekNumber: numWeekUse.toString(),
          score: meetingScore,
          scoreTypeDoc: 'meetingScoreDB',
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  static Future<Map<String, Map<String, int>>> getAallScoresWeek({
    required String userId,
    required String weekNumber,
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
          .doc(church).collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(code)
          .collection(MyUser.collection)
          .doc(userId)
          .collection(FireBaseSetDataForUser.summaryCollection)
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
}
