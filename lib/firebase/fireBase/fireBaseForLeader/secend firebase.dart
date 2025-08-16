import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondFirebase {
  static FirebaseApp? _secondApp;
  static FirebaseFirestore? _firestore;

  static Future<void> initialize() async {
    if (_secondApp != null) return; // علشان ما يعملهاش مرتين

    _secondApp = await Firebase.initializeApp(
      name: 'secondApp',
      options: const FirebaseOptions(
        apiKey: "AIzaSyA7tuXhNxbDcSab6aptQqk3voQhD_lTRiQ",
        appId: "1:924167627464:web:82c87d4cab93857c65bbfd",
        messagingSenderId: "924167627464",
        projectId: "say-win-leaders",
        storageBucket: "say-win-leaders.firebasestorage.app",
      ),
    );

    _firestore = FirebaseFirestore.instanceFor(app: _secondApp!);
  }

  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Second Firebase not initialized yet.');
    }
    return _firestore!;
  }


  static Future<void> saveWeeklyData({
    required String governorate,
    required String church,
    required String stage,
    required int numWeek,
    required int data,
  }) async {
    try {
      await SecondFirebase.initialize();

      final docRef = SecondFirebase.firestore
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('master_leader_church')
          .doc("basic")
          .collection("stage")
          .doc(stage);

      // 1️⃣ تسجيل الأسبوع
      await docRef.set({
        "weeks": {"weeks.$numWeek": data}
      }, SetOptions(merge: true));

      print("✅ Week $numWeek saved successfully.");

      // 2️⃣ لو ده آخر أسبوع في الشهر (كل 4 أسابيع)
      if (numWeek % 4 == 0) {
        final snapshot = await docRef.get();
        final weeksMap = snapshot.data()?['weeks'] ?? {};
        int total = 0;

        // 3️⃣ اجمع آخر 4 أسابيع
        for (int i = numWeek - 3; i <= numWeek; i++) {
          total += (weeksMap['weeks.$i'] ?? 0) as int;
        }

        final monthIndex = (numWeek / 4).ceil(); // مثلًا: كل 4 أسابيع = شهر

        // 4️⃣ حفظ الشهر
        await docRef.set({
          "months": {
            "month_$monthIndex": total,
          }
        }, SetOptions(merge: true));

        print("📆 Saved month_$monthIndex with total: $total");
      }

    } catch (e) {
      print("❌ Error saving weekly data: $e");
    }
  }


  static Future<void> saveStageUserCount({
    required String governorate,
    required String church,
    required String stage,
    required int totalUsers,
  }) async {
    try {
      await SecondFirebase.initialize();

      final docRef = SecondFirebase.firestore
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(church)
          .collection('master_leader_church')
          .doc("basic")
          .collection("stage")
          .doc(stage);

      await docRef.set({
        "stageTotalUsers": totalUsers,
      }, SetOptions(merge: true));

      print("✅ Stage total user count saved: $totalUsers");
    } catch (e) {
      print("❌ Error saving stage user count: $e");
    }
  }


}


