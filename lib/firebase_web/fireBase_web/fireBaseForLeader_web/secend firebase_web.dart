import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondFirebase_web {
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



}


