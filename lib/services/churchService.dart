import 'package:cloud_firestore/cloud_firestore.dart';

class ChurchService {
  static Future<String> generateNextChurchCode(String governorateCode) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governorateCode)
        .collection('church')
        .get();

    if (snapshot.docs.isEmpty) return '101'; // أول كود

    final codes = snapshot.docs
        .map((doc) => int.tryParse(doc.id))
        .where((num) => num != null)
        .cast<int>()
        .toList();

    if (codes.isEmpty) return '101';

    codes.sort();
    final maxCode = codes.last;
    print(">>>>$maxCode");

    return (maxCode + 1).toString();
  }

  // دالة محدثة لجلب اسم الكنيسة من Firebase
  static Future<String> getChurchName(String governorateCode, String churchCode) async {
    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorateCode)
          .collection("church")
          .doc(churchCode)
          .get();

      if (docSnapshot.exists && docSnapshot.data() is Map<String, dynamic>) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final name = data['name'] as String?;
        return name ?? 'كنيسة غير معروفة';
      } else {
        return 'كنيسة غير معروفة';
      }
    } catch (e) {
      print("Error fetching church name: $e");
      return 'كنيسة غير معروفة';
    }
  }
}