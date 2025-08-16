import 'package:cloud_firestore/cloud_firestore.dart';


class FireBaseGetDataForUser {

  static Stream<QuerySnapshot> fetchOpinion() {
    return FirebaseFirestore.instance
        .collection('opinion')
        .orderBy('Time', descending: true) // ترتيب حسب الوقت
        .snapshots();
  }

  static Stream<QuerySnapshot> fetchMessages() {
    return FirebaseFirestore.instance
        .collection('word') // اسم الكولكشن
        .orderBy('Time', descending: true)
        .snapshots(); // إرجاع Stream
  }

}
