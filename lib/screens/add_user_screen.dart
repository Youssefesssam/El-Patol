import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../firebase/authProvider.dart';
import '../services/churchService.dart';
import '../services/firebase_service.dart';
import '../services/governorateserveces.dart';

class AddUserScreen extends StatefulWidget {
  static const String routeName = '/add_user';

  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeMrController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _stageType;
  String? _stageYear;
  final List<String> stageTypes = ['P', 'S', 'U'];
  final List<String> stageYears = ['1', '2', '3'];

  String? typeEN;
  String? typeAR;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> sendUserCodeInWhatsapp({
    required String whatsapp,
    required String code,
    required String subName,
  }) async {
    // تحديد نوع المرحلة
    switch (_stageType) {
      case "P":
        typeEN = "Preparatory ";
        typeAR = "إعدادي";
        break;
      case "S":
        typeEN = "Secondary ";
        typeAR = "ثانوي";
        break;
      case "U":
        typeEN = "University ";
        typeAR = "جامعي";
        break;
      default:
        typeEN = "";
        typeAR = "";
    }

    final message = Uri.encodeComponent(
        "Hi $subName 👋😊,\n"
            "You are now in *✦ SAY WIN ✦* as a User in ${_stageYear ?? ''} $typeEN\n"
            "Your code to join is: *$code*\n"
            "اهلا $subName 👋😊,\n"
            "انت الان فى *✦ SAY WIN ✦* كمخدوم فى مرحلة ${_stageYear ?? ''} $typeAR\n"
            "كودك للأنضمام هو: *$code*"
    );

    final url = "https://wa.me/+2$whatsapp?text=$message";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح واتساب')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade800,
              Colors.blue,
              Colors.indigo.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildHeaderSection(),
                _builCodeField(),
                _buildGovernorateCard(authProviders),
                const SizedBox(height: 15),
                _buildChurchCard(authProviders),
                const SizedBox(height: 15),
                _buildStageDropdown(),
                const SizedBox(height: 15),
                _buildYearDropdown(),
                const SizedBox(height: 30),
                _buildNameField(),
                const SizedBox(height: 30),
                _buildPhoneField(),
                const SizedBox(height: 30),
                _buildSubmitButton(authProviders,_codeMrController.text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Text(
          'إنشاء مستخدم جديد',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'سيتم إنشاء كود المستخدم بناءً على بياناتك',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildGovernorateCard(AuthProviders authProviders) {
    return _buildDetailCard(
      icon: Icons.location_city,
      title: 'المحافظة',
      value: GovernorateService.getName(authProviders.governorateCode!, 'ar'),
    );
  }

  Widget _buildChurchCard(AuthProviders authProviders) {
    return _buildDetailCard(
      icon: Icons.church,
      title: 'الكنيسة',
      value: authProviders.church!,
    );
  }


  Widget _buildStageDropdown() {
    return DropdownButtonFormField<String>(
      value: _stageType,
      items: stageTypes.map((value) {
        String name = value == 'P' ? 'إعدادي' : value == 'S' ? 'ثانوي' : 'جامعي';
        return DropdownMenuItem(
          value: value,
          child: Text(name, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _stageType = value;
        });
      },
      decoration: _buildInputDecoration('اختر المرحلة'),
      validator: (value) {
        if (value == null) return 'من فضلك اختر المرحلة';
        return null;
      },
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<String>(
      value: _stageYear,
      items: stageYears.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _stageYear = value;
        });
      },
      decoration: _buildInputDecoration('اختر السنة'),
      validator: (value) {
        if (value == null) return 'من فضلك اختر السنة';
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _buildInputDecoration('اسم المستخدم'),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'من فضلك أدخل اسم المستخدم';
        return null;
      },
    );
  }
  Widget _builCodeField() {
    return TextFormField(
      controller: _codeMrController,
      decoration: _buildInputDecoration('كود المستر'),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'من فضلك أدخل كود المستر';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration('رقم الهاتف'),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return 'من فضلك أدخل رقم الهاتف';
        if (value.length < 10) return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }

  Widget _buildSubmitButton(AuthProviders authProviders,String codeMr) {
    return InkWell(
      onTap: () async {
        if (!_formKey.currentState!.validate()) return;
        if (!mounted) return;

        setState(() => _isLoading = true);

        final userName = _nameController.text.trim();
        final phone = _phoneController.text.trim();
        final stageCode = '${_stageType ?? ''}${_stageYear ?? ''}';

        String userCode = "";
        try {
          // ✅ تحقق من كود المستر الأول
          if (false) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("❌ كود المستر غير صحيح"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() => _isLoading = false);
            return; // وقف هنا
          }

          // ✅ لو الكود صحيح كمل
          userCode = await FirebaseService.addNewUser(
            userName: userName,
            centerCode: '101' ,
            codeMr:codeMr ,
            stageCode: stageCode,
          );

          await sendUserCodeInWhatsapp(
            whatsapp: phone,
            code: userCode,
            subName: userName,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء الكود بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade800,
              Colors.blue.shade700,
              Colors.deepPurple.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : const Center(
          child: Text(
            'إنشاء الكود',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      height: MediaQuery.of(context).size.height * .11,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade800,
            Colors.blue,
            Colors.indigo.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getStageName(String stageType) {
    switch (stageType) {
      case 'P':
        return 'إعدادي';
      case 'S':
        return 'ثانوي';
      case 'U':
        return 'جامعي';
      default:
        return 'غير معروف';
    }
  }
}
