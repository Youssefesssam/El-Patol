import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/ui_web/studend_ui/statCard.dart';
import 'package:el_patol/ui_web/studend_ui/teacherModulesScreen.dart';
import 'package:el_patol/ui_web/studend_ui/teatchCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models_web/model_student.dart';
import '../../ui/screens/utilites/appAssets.dart';
import '../consts_web.dart';

class StudentStatsSection extends StatefulWidget {
  const StudentStatsSection({super.key});

  @override
  State<StudentStatsSection> createState() => _StudentStatsSectionState();
}

class _StudentStatsSectionState extends State<StudentStatsSection> {
  late Future<Map<String, dynamic>> _studentDataFuture;

  String? centerCode;
  String? codeStudent;
  String? stageCode;

  @override
  void initState() {
    super.initState();
    _studentDataFuture = _prepareStudentData(); // تهيئة مرة واحدة
  }

  Future<Map<String, dynamic>> _prepareStudentData() async {
    // تحميل الأكواد
    codeStudent = await ConstsWeb.getStudentData(key: ConstsWeb.codeStudent);
    centerCode = await ConstsWeb.getStudentData(key: ConstsWeb.centerCode);
    stageCode = await ConstsWeb.getStudentData(key: ConstsWeb.stageCode);

    print("✔ البيانات المحملة: $codeStudent, $centerCode, $stageCode");

    // بعد ما البيانات تجهز، نكمل ونجيب بيانات الطالب
    return _fetchStudentData();
  }

  Future<Map<String, dynamic>> _fetchStudentData() async {
    print("🔥 READ users");

    final doc = await FirebaseFirestore.instance
        .collection('center')
        .doc(centerCode)
        .collection('Student')
        .doc(stageCode)
        .collection('users')
        .doc(codeStudent)
        .get();

    if (!doc.exists) {
      throw Exception("لا توجد بيانات للطالب");
    }

    final data = doc.data()!;
    List<String> teacherCodes = [];
    if (data['teachers'] != null && data['teachers'] is List) {
      teacherCodes = List<String>.from(data['teachers']);
    }

    // تحميل بيانات كل المدرسين مرة واحدة
    final teacherDocs = await Future.wait(
      teacherCodes.map((code) async {
        final tDoc = await FirebaseFirestore.instance
            .collection('center')
            .doc(centerCode)
            .collection('Mr')
            .doc(code)
            .get();

        final teacherData = tDoc.data();
        int studentsCount = 0;

        if (teacherData != null && teacherData['students'] != null) {
          if (teacherData['students'] is List) {
            studentsCount = (teacherData['students'] as List).length;
          }
        }

        return {
          "id": code,
          "data": teacherData,
          "studentsCount": studentsCount,
        };
      }),
    );

    return {
      "studentId": doc.id,
      "studentData": data,
      "teachers": teacherDocs,
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeachersSection(isSmallScreen),
          const SizedBox(height: 20),

          // FutureBuilder بيستنى _studentDataFuture
          FutureBuilder<Map<String, dynamic>>(
            future: _studentDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "خطأ: ${snapshot.error}",
                    style: GoogleFonts.cairo(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Text("لا توجد بيانات");
              }

              final data = snapshot.data!;
              final studentId = data["studentId"];
              final studentData = data["studentData"];
              final teachers = data["teachers"] as List;

              if (teachers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "لم يتم التسجيل مع أي مدرس بعد",
                    style: GoogleFonts.cairo(color: Colors.grey[600]),
                  ),
                );
              }

              return Container(
                height: isSmallScreen ? 160 : 180,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;
                    final cardWidth = isSmallScreen ? 200.0 : 240.0;
                    final cardHeight = isSmallScreen ? 160.0 : 180.0;

                    return Container(
                      height: cardHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: teachers.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final teacher = teachers[index];
                          final teacherData = teacher["data"] as Map<String, dynamic>?;

                          final teacherName = teacherData?['name'] ?? "مستر";
                          final teacherSpecialty = teacherData?['specialty'] ?? "مادة غير معروفة";
                          final teacherImage = AppAssets.man;

                          final tempStudent = Student.fromMap(studentId, {
                            ...studentData,
                            'teachers': {teacher["id"]: teacherSpecialty}
                          });

                          return SizedBox(
                            width: cardWidth,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TeacherModulesScreen(
                                      teacherId: teacher["id"],
                                      student: tempStudent,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      teacherImage,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.6),
                                            Colors.black.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            teacherName,
                                            style: GoogleFonts.cairo(
                                              fontSize: isSmallScreen ? 12 : 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black.withOpacity(0.7),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            teacherSpecialty,
                                            style: GoogleFonts.cairo(
                                              fontSize: isSmallScreen ? 10 : 12,
                                              color: Colors.orange.shade200,
                                              fontWeight: FontWeight.w500,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black.withOpacity(0.7),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 30),
          _buildStatsSection(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildTeachersSection(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isSmallScreen
          ? Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(AppAssets.officerWomen, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(
            "المدرسين الذي اشتركت معهم",
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      )
          : Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Image.asset(AppAssets.officerWomen, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "المدرسين الذي اشتركت معهم",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: isSmallScreen
              ? Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(AppAssets.officer, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                "الاحصائيات",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          )
              : Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(AppAssets.officer, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "الاحصائيات",
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          child: isSmallScreen
              ? const Column(
            children: [
              StatCard(
                icon: Icons.edit,
                title: "عدد الاختبارات اللي خلصتها",
                value: 0,
                max: 0,
              ),
              SizedBox(height: 12),
              StatCard(
                icon: Icons.videocam,
                title: "عدد مرات مشاهدة الفيديوهات",
                value: 0,
                max: 0,
              ),
              SizedBox(height: 12),
              StatCard(
                icon: Icons.check_circle_outline,
                title: "الدرجات اللي حصلت عليها",
                value: 0,
                max: 0,
              ),
            ],
          )
              : const Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.edit,
                  title: "عدد الاختبارات اللي خلصتها",
                  value: 0,
                  max: 0,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.videocam,
                  title: "عدد مرات مشاهدة الفيديوهات",
                  value: 0,
                  max: 0,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle_outline,
                  title: "الدرجات اللي حصلت عليها",
                  value: 0,
                  max: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }}
