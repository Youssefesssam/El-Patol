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

import '../../../models/user_model.dart';
import '../../authProvider.dart';

class FireBaseGetDataForLeader{

  static Future<String?> uploadImageToImgBB() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null; // لو المستخدم ما اختارش صورة
    File imageFile = File(pickedFile.path);
    String apiKey = "0ad219bb6e48aab453b37fc28ac923ed"; // 🔥 ضع API Key هنا
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
    );
    request.files
        .add(await http.MultipartFile.fromPath("image", imageFile.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());
      return responseData["data"]["url"]; // 🔥 رابط الصورة
    } else {
      print("❌ فشل الرفع: ${response.statusCode}");
      return null;
    }
  }

  static CollectionReference<MyUser> getUser({required String governate,required String churchCode,required String stageCode,required String userCode}) {
    var collectionReference = FirebaseFirestore.instance.collection("governate").doc(governate)
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
  static CollectionReference<UserModel> getUserForLeader({required String governate,required String churchCode,required String stageCode}) {
    var collectionReference = FirebaseFirestore.instance.collection("governate").doc(governate)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stageCode)
        .collection('users')
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) =>
          UserModel.fromMap(snapshot.data()!),
      toFirestore: (UserModel, options) => UserModel.toJson(),
    );
    return collectionReference;
  }

  static Future<int> getNextWeek() async {
    final nextWeekRef = FirebaseFirestore.instance.collection('settings').doc('nextWeek');
    final snapshot = await nextWeekRef.get();
    if (snapshot.exists && snapshot.data() != null) {
      return snapshot.data()!['weekNumber'] ?? 0;
    }
    return 0;
  }

  static Future<int> getPreviousWeek() async {
    final prevWeekRef = FirebaseFirestore.instance.collection('settings').doc('previousWeek');
    final snapshot = await prevWeekRef.get();
    if (snapshot.exists && snapshot.data() != null) {
      return snapshot.data()!['weekNumber'] ?? 0;
    }
    return 0;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> recieveTask() {
    return FirebaseFirestore.instance.collection('task').snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> currentWeek() {
    return FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek')
        .snapshots();
  }





  static Future<bool> SweetTalkExist() async {
    QuerySnapshot<Map<String, dynamic>> v = await FirebaseFirestore.instance
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();
    if (v.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteSweetTalk() async {
    var sweetTalk = await FirebaseFirestore.instance
        .collection(ModelSweetTalk.collection)
        .limit(1)
        .get();

    if (sweetTalk.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(ModelSweetTalk.collection)
          .doc(sweetTalk.docs.first.id)
          .delete();
    }
  }

  static Future<List<Map<String, String>>> receiveAnswers() async {
    late String firstId;

    // جلب أول taskId
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('task') // الوصول إلى مجموعة المهام
        .limit(1) // جلب أول مستند فقط
        .get();

    if (snapshot.docs.isNotEmpty) {
      firstId = snapshot.docs.first.id; // إرجاع أول taskId
    } else {
      // في حالة عدم وجود أي مستندات في مجموعة task
      return [];
    }

    // جلب الإجابات من المهمة
    QuerySnapshot answer = await FirebaseFirestore.instance
        .collection('task')
        .doc(firstId)
        .collection('answer')
        .get();

    if (answer.docs.isEmpty) {
      // في حالة عدم وجود إجابات في مجموعة answer
      return [];
    }

    // إرجاع الإجابات في صورة قائمة من الخرائط
    return answer.docs.map((doc) {
      return {
        'sender': doc['sender'] as String,
        'answer': doc['answer'] as String,
      };
    }).toList();
  }

  static Future<void> deleteAnswers() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('task').limit(1).get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<bool> eventExist() async {QuerySnapshot<Map<String, dynamic>> v = await FirebaseFirestore.instance.collection(ModelHiEvent.collection).limit(1).get();if (v.docs.isEmpty) {return false;} else {return true;}}

  static Future<void> deleteEvent() async {var event = await FirebaseFirestore.instance.collection(ModelHiEvent.collection).limit(1).get();if (event.docs.isNotEmpty) {await FirebaseFirestore.instance.collection(ModelHiEvent.collection).doc(event.docs.first.id).delete();}}

  static Future<List<Map<String, dynamic>>> getAllAbsentData() async {
    try {
      CollectionReference absents = FirebaseFirestore.instance.collection('absents');

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
  static Future<void> saveDateInProvider(BuildContext context) async {
    var snapshot = await FirebaseFirestore.instance

        .collection('settings')
        .doc('currentWeek')
        .get();

    if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey("weekNumber")) {
      Provider.of<AuthProviders>(context, listen: false).setWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(context, listen: false).setCurrentMonth(snapshot["weekNumber"]);
    } else {
      print("No weekNumber found in snapshot!");
    }
  }

}