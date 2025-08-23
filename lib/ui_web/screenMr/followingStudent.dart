import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingStudent extends StatefulWidget {
  final String centerCode;
  final String teacherCode;

  const FollowingStudent({
    super.key,
    required this.centerCode,
    required this.teacherCode,
  });

  @override
  State<FollowingStudent> createState() => _FollowingStudentState();
}

class _FollowingStudentState extends State<FollowingStudent> {
  String selectedStage = "P_1"; // المرحلة الافتراضية

  // خريطة المراحل للأسماء المفهومة
  final Map<String, String> stageNames = {
    "P_1": "الصف الأول الإعدادي",
    "P_2": "الصف الثاني الإعدادي",
    "P_3": "الصف الثالث الإعدادي",
  };

  Future<List<Map<String, dynamic>>> _getStudents(String stage) async {
    final teacherDoc = await FirebaseFirestore.instance
        .collection("center")
        .doc(widget.centerCode)
        .collection("Mr")
        .doc(widget.teacherCode)
        .get();

    List<dynamic> studentIds = teacherDoc['students'] ?? [];
    List<Map<String, dynamic>> studentsData = [];

    for (String studentId in studentIds) {
      final studentDoc = await FirebaseFirestore.instance
          .collection("center")
          .doc(widget.centerCode)
          .collection("Student")
          .doc(stage)
          .collection("users")
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        studentsData.add(studentDoc.data()!..['id'] = studentId);
      }
    }

    return studentsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("طلاب المستر")),
      body: Column(
        children: [
          // Dropdown لاختيار المرحلة (لكن الاسم يظهر بالعربي)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedStage,
              items: stageNames.keys.map((stageKey) {
                return DropdownMenuItem(
                  value: stageKey,
                  child: Text(stageNames[stageKey]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStage = value!;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getStudents(selectedStage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("لا يوجد طلاب"));
                }

                final students = snapshot.data!;

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      child: ListTile(
                        title: Text(student['name'] ?? "بدون اسم"),
                        subtitle: Text(
                          "ID: ${student['id']} - ${stageNames[selectedStage]}",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
