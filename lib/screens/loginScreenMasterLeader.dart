import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/authProvider.dart';
import '../models/leader_model.dart';
import '../providers/leader_provider.dart';
import '../services/firebase_service.dart';
import 'master_leader_screen.dart';

class LoginScreenMasterLeader extends StatefulWidget {
  static const String routeName = "LoginScreenLeader";

  @override
  _LoginScreenMasterLeaderState createState() =>
      _LoginScreenMasterLeaderState();
}

class _LoginScreenMasterLeaderState extends State<LoginScreenMasterLeader> {
  final TextEditingController _codeController = TextEditingController();
  bool _checkingSavedCode = true;

  @override
  void initState() {
    super.initState();
    _checkSavedCode();
  }

  Future<void> _checkSavedCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString("code");

    if (savedCode != null && savedCode.isNotEmpty) {
      // ✅ فيه كود محفوظ، جيب بياناته وروح للصفحة الرئيسية
      await _handleLogin(savedCode);
    } else {
      setState(() {
        _checkingSavedCode = false;
      });
    }
  }

  Future<void> _handleLogin(String code) async {
    try {
      // ✅ دلوقتي بنفك الكود مباشرة
      Map<String, dynamic> codeData = FirebaseService.codeDetails(
        code,
        code.substring(0),
      );

      final auth = Provider.of<AuthProviders>(context, listen: false);
      final leaderProvider =
          Provider.of<LeaderProvider>(context, listen: false);

      if (code.startsWith('Mr')) {
        final snapshot = await FirebaseFirestore.instance
            .collection("center")
            .doc(codeData["churchCode"])
            .collection('Mr')
            .doc(code)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final leader = LeaderModel.fromMap(data);

          leaderProvider.setCurrentLeader(leader);

          await auth.setDataForMaster(
            code: code,
            church_code: codeData["churchCode"],
            governorateName: data["governorateName"] ?? "",
          );

          Navigator.pushReplacementNamed(context, MasterLeaderScreen.routeName);
        } else {
          _showError("الكود غير موجود");
        }
      } else {
        _showError("كود غير صحيح");
      }
    } catch (e) {
      print("🔥 Error: $e");
      _showError("حصل خطأ أثناء تسجيل الدخول");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );

    setState(() {
      _checkingSavedCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaderProvider = Provider.of<LeaderProvider>(context);

    if (_checkingSavedCode) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('تسجيل الدخول'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade900,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'أدخل كود الليدر',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
              decoration: InputDecoration(
                hintText: 'مثال: M_SUEZ_102_P3',
                hintStyle:
                    TextStyle(color: Colors.blue.shade700.withOpacity(0.6)),
                prefixIcon:
                    Icon(Icons.lock_outline, color: Colors.blue.shade900),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.blue.shade200, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final code = _codeController.text.trim();
                await _handleLogin(code);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 10),
                  Text('دخول'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
