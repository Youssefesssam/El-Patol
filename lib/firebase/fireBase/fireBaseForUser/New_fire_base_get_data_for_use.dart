import 'package:cloud_firestore/cloud_firestore.dart';


class New_fire_base_get_data_for_use{

  static Stream<QuerySnapshot> fetchOpinion({required String governorate,required String church,required String stage,}) {
    return FirebaseFirestore.instance .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(church)
        .collection('activites')
        .doc(stage)
        .collection('opinion')
        .orderBy('Time', descending: true) // ترتيب حسب الوقت
        .snapshots();
  }
//
  static Stream<QuerySnapshot> fetchMessages({required String governorate,required String churchCode,required String stageCode,}) {
    return   FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorate)
        .collection('church')
        .doc(churchCode)
        .collection('activites')
        .doc(stageCode)
        .collection('word') // اسم الكولكشن
        .limit(1)
        .snapshots(); // إرجاع Stream
  }

}
