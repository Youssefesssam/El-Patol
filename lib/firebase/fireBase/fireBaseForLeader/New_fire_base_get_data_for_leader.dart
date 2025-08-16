import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../model/modelEvent.dart';
import '../../../model/modelSweetTalk.dart';
import '../../../model/modelUser.dart';
import 'package:http/http.dart' as http;

import '../../authProvider.dart';

class New_fire_base_get_data_for_leader {
  static Future<String?> uploadImageToImgBB({required File file}) async {
    try {
      // التحقق من حجم الصورة (لا تتجاوز 5MB)
      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024;

      if (fileSize > maxSize) {
        debugPrint('Image size too large: ${fileSize / 1024 / 1024}MB');
        return null;
      }

      const apiKey = "0ad219bb6e48aab453b37fc28ac923ed";
      final uri = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          file.path,
        ));

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode != 200) {
        debugPrint('Upload failed with status: ${response.statusCode}');
        return null;
      }

      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData) as Map<String, dynamic>;

      return jsonData['data']['url'] as String?;

    } on TimeoutException {
      debugPrint('Image upload timed out');
      return null;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return null;
    }
  }

  static CollectionReference<MyUser> getUser({
    required String governate,
    required String churchCode,
    required String stageCode,
    required String userCode,
  }) {
    var collectionReference = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stageCode)
        .collection('users')
        .doc(userCode)
        .collection(MyUser.collection)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromJson(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toJson(),
        );
    return collectionReference;
  }

  //week
  static Future<int> getNextWeek({
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

    final snapshot = await nextWeekRef.get();

    if (!snapshot.exists) {
      return 2; // قيمة افتراضية إن المستند مش موجود
    }

    final data = snapshot.data();
    if (data == null) {
      return 2; // المستند موجود لكن البيانات فاضية
    }

    final weekNumber = data['weekNumber'] as int? ?? 1;
    return weekNumber + 1;
  }

  static Future<int> getPreviousWeek({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    final prevWeekRef = FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('previousWeek');
    final snapshot = await prevWeekRef.get();
    if (!snapshot.exists) {
      return 0;
    }
    if (snapshot.exists && snapshot.data() != null) {
      return snapshot.data()!['weekNumber'] ?? 0;
    }
    return 0;
  }

  static Stream<int> currentWeek({
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
        .collection('settings')
        .doc('currentWeek')
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists ||
              snapshot.data() == null ||
              snapshot.data()!['weekNumber'] == null) {
            return 0;
          } else {
            return snapshot.data()!['weekNumber'];
          }
        });
  }

  static Future<void> newYear({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      final settingsRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection('settings');

      final snapshot = await settingsRef.get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print("Settings collection deleted successfully.");
    } catch (e) {
      print("Error deleting settings collection: $e");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> recieveTask({
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
        .collection('task')
        .limit(1)
        .snapshots();
  }

  static Future<int?> getCurrentWeek({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('currentWeek')
        .get();
    return querySnapshot.data()?['weekNumber'] ?? 0;
  }

  static Future<int> fetchCurrentWeek({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      int? week = await New_fire_base_get_data_for_leader.getCurrentWeek(
        governorate: governorate,
        church: church,
        stage: stage,
      );
      print("Fetched current week: $week");
      if (week != null) {
        return week;
      } else {
        print("Error: week is null.");
        return 1; // Default value
      }
    } catch (e) {
      print("Error fetching current week: $e");
      throw Exception("Failed to fetch current week.");
    }
  }

  //
  static Future<bool> SweetTalkExist({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    print(governorate);
    print(church);
    print(stage);
    QuerySnapshot<Map<String, dynamic>> v = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();
    if (v.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteSweetTalk({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var sweetTalk = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();

    if (sweetTalk.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelSweetTalk.collection)
          .doc(sweetTalk.docs.first.id)
          .delete();
    }
  }

  static Future<List<Map<String, dynamic>>> receiveAnswers({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    // جلب أول task ID
    String? firstTaskId;

    QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('task')
        .limit(1)
        .get();

    if (taskSnapshot.docs.isNotEmpty) {
      firstTaskId = taskSnapshot.docs.first.id;
    } else {
      // مفيش task أصلاً
      return [];
    }

    // جلب الإجابات من كولكشن answer جوا أول Task
    QuerySnapshot answerSnapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('task')
        .doc(firstTaskId)
        .collection('answer')
        .get();

    if (answerSnapshot.docs.isEmpty) {
      return [];
    }

    // تحويل النتائج إلى قائمة من Map<String, String>
    return answerSnapshot.docs.map((doc) {
      return {
        'sender': doc['sender'] ?? 'Unknown',
        'answer': doc['answer'] ?? '',
      };
    }).toList();
  }

  static Future<void> deleteAnswers({
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
        .collection('task')
        .limit(1)
        .get();

    for (QueryDocumentSnapshot taskDoc in taskSnapshot.docs) {
      // 1. امسح الإجابات اللي جوه الكولكشن الفرعي "answers"
      final answersSnapshot = await taskDoc.reference
          .collection('answers')
          .get();

      for (var answerDoc in answersSnapshot.docs) {
        await answerDoc.reference.delete();
      }

      // 2. احذف مستند الـ task نفسه بعد ما مسحت الإجابات
      await taskDoc.reference.delete();
    }
  }

  static Future<bool> eventExist({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    QuerySnapshot<Map<String, dynamic>> v = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (v.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteEvent({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var event = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection(ModelHiEvent.collection)
        .limit(1)
        .get();
    if (event.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection(ModelHiEvent.collection)
          .doc(event.docs.first.id)
          .delete();
    }
  }

  static Future<List<Map<String, dynamic>>> getAllAbsentData({
    required String governorate,
    required String church,
    required String stage,
  }) async {
    try {
      CollectionReference absents = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('activites')
          .doc(stage)
          .collection('absents');

      QuerySnapshot querySnapshot = await absents.get();

      List<Map<String, dynamic>> allUsersData = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return allUsersData;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<void> saveWeekDataInProvider({
    required BuildContext context,
    required String governorate,
    required String church,
    required String stage,
  }) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('settings')
        .doc('currentWeek')
        .get();

    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!.containsKey("weekNumber")) {
      Provider.of<AuthProviders>(
        context,
        listen: false,
      ).setWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(
        context,
        listen: false,
      ).setCurrentMonth(snapshot["weekNumber"]);
    } else {
      print("No weekNumber found in snapshot!");
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsersFromNestedStructure({
    required String governorateName,
    required String churchCode,
    required String stageCode,
  }) async {
    List<Map<String, dynamic>> allUserData = [];

    final DocumentReference governorateDocRef = FirebaseFirestore.instance
        .collection('governorate')
        .doc(governorateName);

    final DocumentReference churchDocRef = governorateDocRef
        .collection('church')
        .doc(churchCode);

    final DocumentReference usersChurchDocRef = churchDocRef
        .collection('users_church')
        .doc(stageCode);

    final CollectionReference usersCollectionRef = usersChurchDocRef.collection(
      'users',
    );

    final QuerySnapshot usersSnapshot = await usersCollectionRef.get();

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      final CollectionReference userSubCollectionRef = userDoc.reference
          .collection('user');

      final QuerySnapshot userSubCollectionSnapshot = await userSubCollectionRef
          .limit(1)
          .get();

      if (userSubCollectionSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot innerUserDoc =
            userSubCollectionSnapshot.docs.first;
        allUserData.add(innerUserDoc.data() as Map<String, dynamic>);
      }
    }

    return allUserData;
  }
  static Future<List<Map<String, String>>> fetchAllUsersCodesAndNames({
    required String governorate,
    required String churchCode,
    required String stageCode,
  }) async {
    List<Map<String, String>> usersList = [];

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('governorate')
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stageCode)
        .collection('users')
        .get();
    for (var userDoc in usersSnapshot.docs) {
      final userData = userDoc.data();
      final userCode = userDoc.id;

      // الدخول على الكولكشن "user" وجيب أول مستند فيه
      final userSubCollection = await FirebaseFirestore.instance
          .collection('governorate')
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection('users_church')
          .doc(stageCode)
          .collection('users')
          .doc(userCode)
          .collection('user')
          .limit(1)
          .get();

      String email = 'غير متوفر';
      String password = 'غير متوفر';
      String userName =  'غير متوفر';
      if (userSubCollection.docs.isNotEmpty) {
        final userSubData = userSubCollection.docs.first.data();
        email = userSubData['email'] ?? email;
        password = userSubData['pass'] ?? password;
        userName = userSubData['name'] ?? userName;
      }

      usersList.add({
        'code': userCode,
        'name': userName,
        'email': email,
        'pass': password,
      });
    }

    return usersList;
  }
  static Future<Map<String, dynamic>?> getWeekData({
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
      // تأكد إن الفيلد `expireAt` يتحوّل لـ DateTime بشكل صحيح
      final data = doc.data()!;
      return {
        'weekNum': data['weekNum'],
        'date': data['date']?.toDate(), // لازم toDate() لو النوع Timestamp
        'weekIsActive': data['weekIsActive'],
        'dayOfRegistration': data['dayOfRegistration'],
        'expireAt': data['expireAt']?.toDate(), // نفس الكلام هنا
      };
    } else {
      return null; // لو الدوكومنت مش موجود
    }
  }



}
