import 'dart:ui';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:el_patol/ui_web/consts_web.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../models_web/model_student.dart';
import '../loginScreen/loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _codeController = TextEditingController();

  // ✅ الحقول الإضافية
  final _phoneParentController = TextEditingController();
  final _phoneStudentController = TextEditingController();
  final _locationController = TextEditingController();

  bool isLoading = false;

  String centerCode = "";
  String stageCode = "";
  String stageType = "";
  String stageYear = "";
  String userId = "";

  /// ✅ التحقق من الكود
  Future<bool> checkCode(String code) async {
    if (code.isNotEmpty && code.length >= 7 && code.startsWith('S')) {
      centerCode = code.substring(3, 6);
      stageType = code[1];
      stageYear = code.length > 7 ? code.substring(2, 3) : 'X';
    } else {
      return false;
    }
    stageCode = '${stageType}_$stageYear';

    var snapshot = await FirebaseFirestore.instance
        .collection('center')
        .doc(centerCode)
        .collection('Student')
        .doc(stageCode)
        .collection('users')
        .doc(code)
        .get();

    return snapshot.exists;
  }

  String getStageName(String stageCode) {
    switch (stageCode) {
      case "P_1":
        return "أولى إعدادي";
      case "P_2":
        return "تانية إعدادي";
      case "P_3":
        return "تالتة إعدادي";
      default:
        return "غير معروف";
    }
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    String code = _codeController.text.trim();
    bool codeValid = await checkCode(code);

    if (!codeValid) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("❌ الكود غير صحيح")));
      return;
    }
    final stageName = getStageName(stageCode);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      userId = userCredential.user!.uid;

      final student = Student(
        id: userId,
        name: "${_firstNameController.text} ${_lastNameController.text}",
        stage: stageName,
        paidModules: {},
        watchedVideos: {},
        assignments: {},
        code: code,
        email: _emailController.text,
        centerCode: centerCode,
        stageCode: stageCode,
        stageType: stageType,
        stageYear: stageYear,
        role: 'student',
        isRegistered: true,
        createdAt: DateTime.now(),
        // ✅ القيم المضافة من اليوزر
        teachers: {},
        phoneParent: _phoneParentController.text,
        phoneStudent: _phoneStudentController.text,
        location: _locationController.text,
      );

      await addUserToFirestore(
        centerCode: centerCode,
        stageCode: stageCode,
        userCode: code,
        student: student,
      );

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } catch (e) {
      debugPrint("Registration error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("⚠ حدث خطأ أثناء التسجيل")));
    } finally {
      setState(() => isLoading = false);
    }
    await ConstsWeb.setStudentData(
      key: "name",
      value: "${_firstNameController.text} ${_lastNameController.text}",
    );

    await ConstsWeb.setStudentData(
      key: "centerCode",
      value: centerCode,
    );

    await ConstsWeb.setStudentData(
      key: "stageCode",
      value: stageCode,
    );

    await ConstsWeb.setStudentData(
      key: "phoneParent",
      value: _phoneParentController.text,
    );

    await ConstsWeb.setStudentData(
      key: "phoneStudent",
      value: _phoneStudentController.text,
    );

    await ConstsWeb.setStudentData(
      key: "codeStudent",
      value: code,
    );

    await ConstsWeb.setStudentData(
      key: "location",
      value: _locationController.text,
    );

    await ConstsWeb.setStudentData(
      key: "stageName",
      value: stageName,
    );

  }

  Future<void> addUserToFirestore({
    required String centerCode,
    required String stageCode,
    required String userCode,
    required Student student,
  }) async {
    await FirebaseFirestore.instance
        .collection("center")
        .doc(centerCode)
        .collection("Student")
        .doc('${stageType}_$stageYear')
        .collection('users')
        .doc(userCode)
        .set(student.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.main1),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school_rounded,
                            size: 80, color: Colors.blue.shade200),
                        const SizedBox(height: 16),
                        Text(
                          "إنشاء حساب جديد",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ✅ الاسم الأول + العائلة جنب بعض
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(_firstNameController,
                                  "الاسم الأول", Icons.person_outline),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: _buildTextField(_lastNameController,
                                  "اسم العائلة", Icons.person_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ الإيميل (صف لوحده)
                        _buildTextField(
                            _emailController, "البريد الإلكتروني", Icons.email),
                        const SizedBox(height: 16),

                        // ✅ الباسورد + الكود جنب بعض
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(_passwordController,
                                  "كلمة المرور", Icons.lock_outline,
                                  isPassword: true),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                  _codeController, "كود المستخدم", Icons.code),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ تليفون ولي الأمر + الطالب جنب بعض
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(_phoneParentController,
                                  "تليفون ولي الأمر", Icons.phone),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(_phoneStudentController,
                                  "تليفون الطالب", Icons.phone_android),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ✅ العنوان صف كامل
                        _buildTextField(_locationController, "المكان / العنوان",
                            Icons.location_on),
                        const SizedBox(height: 30),

                        // ✅ زر التسجيل
                        SizedBox(
                          width: double.infinity,
                          child: InkWell(
                            onTap: isLoading ? null : registerUser,
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 2),
                              curve: Curves.linear,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade900,
                                    Colors.blue.shade600,
                                    Colors.purple.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        "تسجيل",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      validator: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }
}
