import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../firebase/authProvider.dart';
import '../services/churchService.dart';
import '../services/firebase_service.dart';
import '../services/governorateserveces.dart';

class AddSubLeaderScreen extends StatefulWidget {
  static const String routeName = '/add_sub_leader';
  const AddSubLeaderScreen({Key? key}) : super(key: key);

  @override
  _AddSubLeaderScreenState createState() => _AddSubLeaderScreenState();
}

class _AddSubLeaderScreenState extends State<AddSubLeaderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _specialty;
  late String governorateCode;
  late String churchCode;
  bool _isInit = false;
  bool _isLoading = false;

  final List<String> specialties = ['عام', 'مسرح', 'كورال', 'إنشاد', 'تعليم'];

  void sendLeaderCodeInWhatsapp({
    required String whatsapp,
    required String code,
    required String subName,
  }) async {
    await launchUrl(Uri.parse(
        "https://wa.me/+2$whatsapp?text=${Uri.encodeComponent(
            "Hi $subName 👋😊,\n"
                "You are now in *✦ SAY WIN ✦* as a sub leader.\n"
                "Your code to join is: *$code*\n"
                "اهلا $subName 👋😊,\n"
                "انت الان فى *✦ SAY WIN ✦* كخادم.\n"
                "كودك للأنضمام هو: *$code*"
        )}"
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthProviders authProviders = Provider.of(context, listen: false);
    if (!_isInit) {
      String _masterLeaderCode = authProviders.codeMaster!;
      if (_masterLeaderCode.length >= 6) {
        governorateCode = _masterLeaderCode.substring(1, 3);
        churchCode = _masterLeaderCode.substring(3, 6);
      } else {
        Future.microtask(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('كود الليدر العام غير صحيح')),
          );
        });
        governorateCode = 'XX';
        churchCode = 'XXX';
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.shade700,
              Colors.blue,
              Colors.blueAccent.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'إنشاء ليديـر فرعي',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 10),

              // Governorate & Church Info
              Container(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_city, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'المحافظة :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            GovernorateService.getName(governorateCode, 'ar'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(Icons.church, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'الكنيسة :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          FutureBuilder<String>(
                            future: ChurchService.getChurchName(
                                GovernorateService.getName(governorateCode, 'en'), churchCode),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'جاري التحميل...',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'خطأ',
                                  style: TextStyle(color: Colors.red),
                                );
                              } else {
                                return Text(
                                  snapshot.data ?? 'كنيسة غير معروفة',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.white,
                  labelText: 'اسم المستخدم',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'من فضلك أدخل اسم الليدر';
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  prefixIconColor: Colors.white,
                  labelText: 'الفون',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'من فضلك أدخل رقم الهاتف';
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Specialty Dropdown
              DropdownButtonFormField<String>(
                value: _specialty,
                items: specialties.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.edit_note, color: Colors.white),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _specialty = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'اختر التخصص',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              ),

              SizedBox(height: 30),

              // Submit Button
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : InkWell(
                onTap: () async {
                  if (_specialty != null &&
                      _nameController.text.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });

                    final leaderName = _nameController.text.trim();

                    // إضافة الليدر مباشرة بدون مرحلة
                    final leaderCode = await FirebaseService.addNewSubLeader(
                      governorateCode,
                      churchCode,
                      _specialty!,
                      leaderName,
                    );

                    sendLeaderCodeInWhatsapp(
                      whatsapp: _phoneController.text,
                      code: leaderCode,
                      subName: leaderName,
                    );

                    setState(() {
                      _isLoading = false;
                    });

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('من فضلك املأ كل الحقول'),
                      backgroundColor: Colors.red,
                    ));
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
                  child: Center(
                    child: Text(
                      'انشاء الكود',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
