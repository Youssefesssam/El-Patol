import 'package:el_patol/ui_web/consts_web.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  String? name;
  String? phoneStudent;
  String? phoneParent;
  String? location;
  String? stageName;

  Future<void> getData() async {
    final n = await ConstsWeb.getStudentData(key: ConstsWeb.name);
    final ps = await ConstsWeb.getStudentData(key: ConstsWeb.phoneStudent);
    final pp = await ConstsWeb.getStudentData(key: ConstsWeb.phoneParent);
    final loc = await ConstsWeb.getStudentData(key: ConstsWeb.location);
    final stg = await ConstsWeb.getStudentData(key: ConstsWeb.stageName);

    setState(() {
      name = n;
      phoneStudent = ps;
      phoneParent = pp;
      location = loc;
      stageName = stg;
    });

    print("✔ البيانات المحملة: $name, $phoneStudent, $phoneParent, $location, $stageName");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// الاسم
          Text(
            name ?? "جاري التحميل...",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),

          /// رقم الطالب
          Row(
            children: [
              const Icon(Icons.phone, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                phoneStudent ?? "لا يوجد",
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// رقم ولي الأمر
          Row(
            children: [
              const Icon(Icons.phone_android, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                phoneParent ?? "لا يوجد",
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// العنوان
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                location ?? "غير محدد",
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// المرحلة
          Row(
            children: [
              const Icon(Icons.school, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                stageName ?? "غير محدد",
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    "أونلاين",
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    "تحويل سنتر",
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
