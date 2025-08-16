import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../firebase/authProvider.dart';
import '../../../../firebase/dataProvider.dart';
import '../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../model/modelUser.dart';
import '../../../../services/churchService.dart';
import '../../../../services/governorateserveces.dart';
import '../../homeScreen/screenUser/homeScreenUsers.dart';
import '../../utilites/appColors.dart';
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
  String? governateCode, governateUserName, churchCode;
  String? stageType, stageYear, stageCode, church;

  void signIn(BuildContext context) async {
    if (codeController.text.length >= 7 && codeController.text.startsWith('U')) {
      governateCode = codeController.text.substring(1, 3);
      churchCode = codeController.text.substring(3, 6);
      governateUserName = GovernorateService.getName(governateCode!, 'en');
      church = await ChurchService.getChurchName(governateUserName!, churchCode!);
      stageType = codeController.text[6];
      stageYear = codeController.text.length > 7 ? codeController.text.substring(7, 8) : 'X';
    } else {
      churchCode = 'XXX';
      stageType = 'X';
      stageYear = 'X';
    }

    stageCode = '${stageType}_$stageYear';
    try {
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

        MyUser? myUser = await New_fire_base_set_data_for_user.readUserData2(
          governorate: governateUserName!,
          churchCode: churchCode!,
          stageCode: stageCode!,
          code: codeController.text,
          userId: userId,
        );

        await AuthProviders().setDataForUser(
          nameU: myUser!.name,
          emailU: myUser.email,
          talentU: myUser.talent,
          universityU: myUser.university,
          phoneU: myUser.phone,
          genderU: myUser.gender,
          profileU: myUser.profileUrl,
          codeU: myUser.code,
          addressU: myUser.address,
          churchCodeU: churchCode!,
          governateCodeU: governateCode!,
          stageCodeUser: stageCode!,
          stageTypeUser: stageType!,
          stageYearUser: stageYear!,
          idForUser: myUser.id,
          governorateNameForUser: governateUserName!,
          churchU: church!,
          ageU: myUser.birthDay,
          whatsapp: myUser.whatsapp,
          facebook: myUser.facebook,
        );

        Provider.of<DataProvider>(context, listen: false).uid = userId;
        AuthProviders().setUserData();
        Navigator.pushReplacementNamed(context, HomeScreenUsers.routeName);
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade800.withOpacity(0.2),
                  Colors.blue.shade200.withOpacity(0.1),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 30, left: 16, right: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.appBarColor,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.shade800.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.loginScreen,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
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
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'كود المستخدم مطلوب';
                              }
                              if (!value.startsWith('U') || value.length < 7) {
                                return 'صيغة الكود غير صحيحة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signIn(context);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(fontSize: 18, color: AppColors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.blue.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, RegisterScreen.routeName),
                            child: Text(
                              AppLocalizations.of(context)!.createAccount,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade600),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(icon, color: Colors.blue.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: TextStyle(color: Colors.black87, fontSize: 16),
    );
  }
}
