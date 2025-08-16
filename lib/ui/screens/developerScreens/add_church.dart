import 'package:flutter/material.dart';

import '../../../services/churchService.dart';
import '../../../services/firebase_service.dart';
import '../../../services/governorateserveces.dart';

class AddChurch extends StatefulWidget {
  static const String routeName = "church";
  const AddChurch({super.key});

  @override
  State<AddChurch> createState() => _AddChurchState();
}

class _AddChurchState extends State<AddChurch> {
  String? _governorate;
  String? _specialty;

  TextEditingController churchNameController = TextEditingController();

  final List<String> specialties = ['عام', 'مسرح', 'كورال', 'إنشاد', 'تعليم'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء كود الكنيسة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // اختيار المحافظة
            DropdownButtonFormField<String>(
              value: _governorate,
              items: GovernorateService.governorates.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key, // الكود
                  child: Text(entry.value['ar']!), // الاسم
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _governorate = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر المحافظة'),
            ),
            SizedBox(height: 20),

            // اسم الكنيسة
            TextFormField(
              controller: churchNameController,
              decoration: InputDecoration(labelText: 'اسم الكنيسة'),
            ),
            SizedBox(height: 20),

            // اختيار التخصص
            DropdownButtonFormField<String>(
              value: _specialty,
              items: specialties.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _specialty = value;
                });
              },
              decoration: InputDecoration(labelText: 'اختر التخصص'),
            ),
            SizedBox(height: 20),

            // زر إنشاء الكود
            ElevatedButton(
              onPressed: () async {
                if (_governorate != null &&
                    _specialty != null &&
                    churchNameController.text.trim().isNotEmpty) {
                  String governorate=GovernorateService.getEnglishName(_governorate!);
                  // ✅ توليد كود الكنيسة من Firebase
                  final churchCode = await ChurchService.generateNextChurchCode(governorate);

                  // تحديث الخريطة المحلية (اختياري لو هتستخدمها في الواجهة)

                  // ✅ رفع البيانات إلى Firebase
                  await FirebaseService.addChurchCode(churchCode: churchCode, governorate:governorate,churchName:churchNameController.text);
                  await FirebaseService.addNewMasterLeader(
                    _governorate!, churchCode, _specialty!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إنشاء الكود بنجاح')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('من فضلك املأ كل الحقول المطلوبة')),
                  );
                }
              },
              child: Text('إنشاء الكود'),
            )
          ],
        ),
      ),
    );
  }
}
