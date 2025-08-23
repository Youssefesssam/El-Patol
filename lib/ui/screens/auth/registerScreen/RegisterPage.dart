import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = 'RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isLoading = false;
  String? selectedProvince;
  String? selectedYear;
  String? selectedEducationLevel;

  List<String> provinces = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'المنوفية',
    'الدقهلية',
  ];

  List<String> educationLevels = [
    'ابتدائي',
    'إعدادي',
    'ثانوي',
    'جامعي',
  ];

  List<String> academicYears = [
    '2023/2024',
    '2022/2023',
    '2021/2022',
  ];

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // محاكاة عملية تسجيل تستغرق بعض الوقت
      await Future.delayed(const Duration(seconds: 2));

      final userData = {
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'province': selectedProvince,
        'educationLevel': selectedEducationLevel,
        'academicYear': selectedYear,
      };

      print('بيانات المستخدم المسجلة: $userData');

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
      );

      // يمكنك توجيه المستخدم لصفحة أخرى هنا
      // Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0EA4E7),
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // الصورة كخلفية تغطي الشاشة كلها
          Positioned.fill(
            child: Image.asset(
              'assets/Main.png',
              fit: BoxFit.cover,
            ),
          ),

          // لون شفاف (اختياري) عشان تخفف الإضاءة على الصورة وتبرز الفورم أكتر
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2), // شفافية لون أسود خفيف
            ),
          ),

          // الفورم داخل كونتينر شفاف فوق الصورة
          Center(
            child: Container(
              width: screenWidth * 0.9, // عشان يكون مناسب في معظم الشاشات
              height: screenWidth * 0.4, // عشان يكون مناسب في معظم الشاشات
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // شفافية خلفية الفورم
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                    BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم بالكامل رباعي باللغة العربية',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم بالكامل';
                        }
                        return null;
                      },
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم موبايل ولي الأمر',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        prefixText: '+2 ',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الموبايل';
                        }
                        if (value.length != 10) {
                          return 'يجب أن يتكون الرقم من 10 أرقام';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'اختر محافظتك',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedProvince,
                      items: provinces.map((String province) {
                        return DropdownMenuItem<String>(
                          value: province,
                          child: Text(province),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedProvince = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء اختيار المحافظة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'مرحلة التعليم',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedEducationLevel,
                      items: educationLevels.map((String level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEducationLevel = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء اختيار مرحلة التعليم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة السر';
                        }
                        if (value.length < 6) {
                          return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة السر',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'كلمة السر غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'السنة الدراسية',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedYear,
                      items: academicYears.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء اختيار السنة الدراسية';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _registerUser,
                      child:   Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('إنشاء حساب'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
    );
  }
}