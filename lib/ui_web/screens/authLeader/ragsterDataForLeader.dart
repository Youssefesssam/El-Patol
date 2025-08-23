import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/authProvider.dart';
import '../../../models/leader_model.dart';
import '../../../providers/leader_provider.dart';
import '../../../services/firebase_service.dart';
import '../../../ui/screens/utilites/appColors.dart';
import '../login_sub_leader.dart';

class RagsterDataForLeader extends StatefulWidget {
  static const String routeName = "RagsterDataForLeader";

  const RagsterDataForLeader({super.key});

  @override
  State<RagsterDataForLeader> createState() => _RagsterDataForLeaderState();
}

class _RagsterDataForLeaderState extends State<RagsterDataForLeader> {
  final TextEditingController _codeMrController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedGender;
  final List<String> genders = ['ذكر', 'أنثى'];

  late String governorateCode;
  late String centerCode;
  String? governorate;

  @override
  void dispose() {
    _codeMrController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> registerLeader() async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() => _isLoading = true);

      final codeMr = _codeMrController.text.trim();
      final code = _codeController.text.trim();
      final name = _nameController.text.trim();
      final specialty = _specialtyController.text.trim();
      final age = _ageController.text.trim();
      final phone = _phoneController.text.trim();

      // تحقق من صحة رقم الهاتف
      if (!RegExp(r'^01[0-9]{9}$').hasMatch(phone)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 01 ويتكون من 11 رقم.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // التحقق من صحة كود الليدر
      if (code.length >= 7 && code.startsWith('L')) {

        if (!mounted) return;


        centerCode = code.substring(1, 4);
        print("pppppppppppppppppppppppppppppp$centerCode");
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('كود الليدر غير صحيح')));
        setState(() => _isLoading = false);
        return;
      }

      try {
        final DocumentReference leaderRef = FirebaseFirestore.instance
            .collection("center")
            .doc(centerCode)
            .collection('Mr')
            .doc(codeMr)
            .collection("assistant")
            .doc(code);

        final snapshot = await leaderRef.get();

        print('Snapshot exists: ${snapshot.exists}');
        print('Snapshot data: ${snapshot.data()}');

        if (snapshot.exists) {
          await leaderRef.update({
            "name": name,
            "phone": phone,
            "specialty": specialty,
            "gender": _selectedGender,
            "age": age,
          });

          final leaderData = snapshot.data() as Map<String, dynamic>;
          final leader = LeaderModel.fromMap(leaderData);

          if (!mounted) return;
          Provider.of<LeaderProvider>(
            context,
            listen: false,
          ).setCurrentLeader(leader);

          final leadercode = await FirebaseService.getCodeSubLeader(
            centerCode,
            code,
            codeMr
          );

          if (leadercode != null) {
            final authProviders = Provider.of<AuthProviders>(
              context,
              listen: false,
            );
            authProviders.setCodeLeader(leadercode.code ?? '');
            authProviders.setDataForSubLeader(
              name: leadercode.name ?? '',
              code: leadercode.code ?? '',
              gender: leadercode.gender ?? '',
              phone: leadercode.phone ?? '',
              specialty: leadercode.specialty ?? '',
              role: leadercode.role ?? '',
              age: leadercode.age ?? '',
              image: leadercode.image ?? '',  // بدل !
              governorateNameL: leadercode.governorateName ?? '',
              governorateCodeL: leadercode.governorateCode ?? '',
              church_code: leadercode.churchCode ?? '',
              church: leadercode.church ?? '',
            );


            await authProviders.saveDataForLeader();
          }

          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            LoginSubLeaderScreen.routeName,
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الكود غير موجود في قاعدة البيانات')),
          );
        }
      } catch (e, stackTrace) {
        if (!mounted) return;
        print("Error registering leader: $e");
        print(stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في التسجيل: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
                colors: [
                  Colors.indigo.withOpacity(0.4),
                  Colors.blueGrey.withOpacity(0.4),
                  Colors.blue.withOpacity(0.4),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 30, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: const BorderRadius.only(
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
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تسجيل بيانات الليدر",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextFieldWithIcon(
                              "كود المستر", Icons.badge_outlined, _codeMrController,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال الكود' : null),
                          const SizedBox(height: 20),
                          _buildTextFieldWithIcon(
                              "كود الاسيست", Icons.badge_outlined, _codeController,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال الكود' : null),
                          const SizedBox(height: 20),
                          _buildTextFieldWithIcon(
                              "اسم الليدر", Icons.person_outline, _nameController,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null),
                          const SizedBox(height: 20),
                          _buildTextFieldWithIcon(
                              "رقم الهاتف", Icons.phone, _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال رقم الهاتف' : null),
                          const SizedBox(height: 20),
                          _buildTextFieldWithIcon(
                              "التخصص", Icons.school_outlined, _specialtyController,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال التخصص' : null),
                          const SizedBox(height: 20),
                          _buildGenderDropdown(),
                          const SizedBox(height: 20),
                          _buildTextFieldWithIcon(
                              "السن", Icons.calendar_today_outlined, _ageController,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                              value == null || value.isEmpty ? 'يرجى إدخال السن' : null),
                          const SizedBox(height: 40),
                          _isLoading
                              ? CircularProgressIndicator(color: AppColors.mainColor)
                              : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerLeader();
                              }
                            },
                            child: const Text("تسجيل",
                                style: TextStyle(fontSize: 18, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: AppColors.mainColor,
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
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.mainColor),
        floatingLabelStyle: TextStyle(color: AppColors.mainColor),
        prefixIcon: Icon(icon, color: AppColors.mainColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
    );
  }

  Widget _buildGenderDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'النوع',
        labelStyle: TextStyle(color: AppColors.mainColor),
        floatingLabelStyle: TextStyle(color: AppColors.mainColor),
        prefixIcon: Icon(Icons.transgender, color: AppColors.mainColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.mainColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedGender,
          hint: const Text('اختر النوع', style: TextStyle(color: Colors.grey)),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.mainColor),
          items: genders.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }
}
