import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/authProvider.dart';
import '../../models/leader_model.dart';
import '../../providers/leader_provider.dart';
import 'add_user_screen.dart';



class LoginSubLeaderScreen extends StatefulWidget {
  static const String routeName = '/login_sub_leader';

  @override
  _LoginSubLeaderScreenState createState() => _LoginSubLeaderScreenState();
}

class _LoginSubLeaderScreenState extends State<LoginSubLeaderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _codeMrController = TextEditingController();
  bool _isLoading = false;

  late String centerCode;

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String code = _codeController.text.trim();
      if (code.length >= 6 && code.startsWith('L')) {
        centerCode = code.substring(1, 4);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كود الليدر غير صحيح')),
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("center")
            .doc(centerCode)
            .collection('Mr')
            .doc(_codeMrController.text)
            .collection("assistant")
            .doc(code)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final leader = LeaderModel.fromMap(data);

          final provider = Provider.of<LeaderProvider>(context, listen: false);
          final authProviders = Provider.of<AuthProviders>(context, listen: false);

          provider.setCurrentLeader(leader);

          await authProviders.setDataForSubLeader(
            name: leader.name ?? '',
            code: leader.code ?? '',
            gender: leader.gender ?? '',
            phone: leader.phone ?? '',
            specialty: leader.specialty ?? '',
            role: leader.role ?? '',
            age: leader.age ?? '',
            image: leader.image ?? '',
            governorateNameL: leader.governorateName ?? '',
            governorateCodeL: leader.governorateCode ?? '',
            church_code: leader.churchCode ?? '',
            church: leader.church ?? '',
          );

          await authProviders.saveDataForLeader();

          Navigator.pushReplacementNamed(context, AddUserScreen.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('كود غير صحيح أو ليس كود ليدر')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في التحقق من الكود')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            Icons.lock_outline,
                            size: 100,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تسجيل دخول الليدر',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'من فضلك أدخل الكود الخاص بك',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        TextFormField(
                          controller: _codeMrController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 5,
                            color: Colors.blue.shade900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'L123456',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[400],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.blue.shade600,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.blue.shade800,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.qr_code,
                              color: Colors.blue.shade700,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل الكود';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _codeController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 5,
                            color: Colors.blue.shade900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'L123456',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[400],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.blue.shade600,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.blue.shade800,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.qr_code,
                              color: Colors.blue.shade700,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل الكود';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        _isLoading
                            ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade900,
                          ),
                        )
                            : ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'دخول',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade700,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
