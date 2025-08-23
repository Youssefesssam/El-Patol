import 'package:flutter/material.dart';

import 'modulesListScreen.dart';

class ChooseStageScreen extends StatefulWidget {
  static const String routeName = 'chooseStageScreen';

  @override
  _ChooseStageScreenState createState() => _ChooseStageScreenState();
}

class _ChooseStageScreenState extends State<ChooseStageScreen> {
  String? _selectedStage;

  final List<Map<String, String>> _stages = [
    {"label": "الأول إعدادي", "code": "P_1"},
    {"label": "الثاني إعدادي", "code": "P_2"},
    {"label": "الثالث إعدادي", "code": "P_3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختر المرحلة")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedStage,
              hint: Text("اختر المرحلة"),
              items: _stages.map((stage) {
                return DropdownMenuItem<String>(
                  value: stage["code"],
                  child: Text(stage["label"]!),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedStage = val);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedStage == null
                  ? null
                  : () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ModulesListScreen(stage: _selectedStage!), // 👈 نمرر المرحلة
                  ),
                );
              },
              child: Text("التالي"),
            )
          ],
        ),
      ),
    );
  }
}
