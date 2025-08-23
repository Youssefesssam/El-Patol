import 'dart:ui';

import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../firebase/authProvider.dart';
import '../../../../firebase/dataProvider.dart';
import '../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../model/modelUser.dart';
import '../../../../services/churchService.dart';
import '../../../../services/governorateserveces.dart';
import '../../../../ui_web/studend_ui/studentProfilePage.dart';
import '../../utilites/appColors.dart';
import '../registerScreen/RegisterPage.dart';
import '../registerScreen/regsterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  String? centerCode;
  String? stageType, stageYear, stageCode, church;
  bool _isLoading = false;

  void signIn(BuildContext context) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      if (codeController.text.isNotEmpty &&
          codeController.text.length >= 7 &&
          codeController.text.startsWith('S')) {
        centerCode = codeController.text.substring(3, 6);
        stageType = codeController.text[1];
        stageYear =
        codeController.text.length > 7 ? codeController.text.substring(2, 3) : 'X';
      } else {
        centerCode = 'XXX';
        stageType = 'X';
        stageYear = 'X';
      }

      stageCode = '${stageType}_$stageYear';

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        String userId = firebaseUser.uid;
        String? email = firebaseUser.email;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('email', email ?? "");
        await prefs.setString('centerCode', centerCode ?? '');
        await prefs.setString('stageType', stageType ?? '');
        await prefs.setString('stageYear', stageYear ?? '');
        await prefs.setString('stageCode', stageCode ?? '');

        if (mounted) {
          final dataProvider = Provider.of<DataProvider>(context, listen: false);
          dataProvider.uid = userId;

          final authProvider = AuthProviders();
          await authProvider.setUserData();

          Navigator.pushReplacementNamed(context, StudentProfilePage.routeName);
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ في تسجيل الدخول';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'لا يوجد مستخدم بهذا البريد الإلكتروني';
          break;
        case 'wrong-password':
          errorMessage = 'كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          errorMessage = 'صيغة البريد الإلكتروني غير صحيحة';
          break;
        case 'too-many-requests':
          errorMessage = 'تم تجاوز عدد المحاولات المسموحة، حاول لاحقاً';
          break;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع، حاول مرة أخرى'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.main1), // صورتك
            fit: BoxFit.cover,
          ),
        ),

          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // البلور
                  child: Container(
                    width: 450,
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15), // خلفية زجاجية شفافة
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3), // Border خفيف
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded,
                              size: 80, color: Colors.white),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)?.loginScreen ??
                                'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 40),

                          _buildTextFieldWithIcon(
                            "Email",
                            Icons.email_outlined,
                            emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'البريد الإلكتروني مطلوب';
                              }
                              if (!value.contains('@')) {
                                return 'صيغة البريد غير صحيحة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildTextFieldWithIcon(
                            "Password",
                            Icons.lock_outline,
                            passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'كلمة المرور مطلوبة';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildTextFieldWithIcon(
                            "Code",
                            Icons.code_outlined,
                            codeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'كود المستخدم مطلوب';
                              }
                              if (!value.startsWith('S') || value.length < 7) {
                                return 'صيغة الكود غير صحيحة (يجب أن يبدأ بـ S ويكون 7 أحرف على الأقل)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  signIn(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                                shadowColor: Colors.blue.shade900,
                                backgroundColor: Colors.transparent, // مهم علشان نعرض الجريدينت
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient:  LinearGradient(
                                    colors: [
                                      Colors.blue.shade900,
                                      Colors.blue.shade600,
                                      Colors.purple.shade600,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, RegisterScreen.routeName),
                            child: Text(
                              AppLocalizations.of(context)?.createAccount ??
                                  'إنشاء حساب جديد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
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

  Widget _buildTextFieldWithIcon(
      String label,
      IconData icon,
      TextEditingController controller, {
        bool obscureText = false,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white), // النص أبيض
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05), // خلفية شفافة
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)), // بوردر فاتح
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
