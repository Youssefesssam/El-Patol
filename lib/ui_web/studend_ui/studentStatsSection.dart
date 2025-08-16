import 'package:el_patol/ui_web/studend_ui/statCard.dart';
import 'package:el_patol/ui_web/studend_ui/teatchCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
class StudentStatsSection extends StatelessWidget {
  const StudentStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [
            Container(
              width: 150,
              height: 150,
              child: Image.asset(
                AppAssets.officerWomen,
                fit: BoxFit.contain, // الصورة هتصغر وتتملأ بدون تقطيع
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
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
        Container(
          margin: const EdgeInsets.all(5),
          child: const Row(
            children: [
              Expanded(
                child: TeatchCard(
                  image: AppAssets.docwomen,
                  name: "أ. أحمد علي",
                  subject: "رياضيات",
                  studentsCount: 30,
                  attended: 20,
                  totalClasses: 25,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TeatchCard(
                  image: AppAssets.gym,
                  name: "أ. أحمد علي",
                  subject: "رياضيات",
                  studentsCount: 30,
                  attended: 20,
                  totalClasses: 25,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TeatchCard(
                  image: AppAssets.girl1,
                  name: "أ. محمد حسن",
                  subject: "فيزياء",
                  studentsCount: 25,
                  attended: 15,
                  totalClasses: 20,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TeatchCard(
                  image: AppAssets.girl3,
                  name: "أ.  يوسف",
                  subject: "كيمياء",
                  studentsCount: 28,
                  attended: 18,
                  totalClasses: 22,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Image.asset(
              AppAssets.officer,
              fit: BoxFit.cover,
              width: 150,
              height: 150,// عشان تملأ المساحة
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "الاحصائيات",
                style: GoogleFonts.cairo(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: const Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.edit,
                  title: "عدد الاختبارات اللي خلصتها",
                  value: 0,
                  max: 0,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: Icons.videocam,
                  title: "عدد مرات مشاهدة الفيديوهات",
                  value: 0,
                  max: 0,
                ),
              ),
              SizedBox(width: 8),
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
  }
}
