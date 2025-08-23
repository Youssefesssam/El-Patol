

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models_web/model_student.dart';

class New_fire_base_get_data_for_leader_web {
  static DocumentReference<Map<String, dynamic>> getUser({
    required String governate,
    required String churchCode,
    required String stageCode,
    required String userCode,
  }) {
    return FirebaseFirestore.instance
        .collection('master')
        .doc('Alexandria')
        .collection('churches')
        .doc('101')
        .collection('stages')
        .doc('P_2')
        .collection('users')
        .doc('U03101P21100');
  }
}
