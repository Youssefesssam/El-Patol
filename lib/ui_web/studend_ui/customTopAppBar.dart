import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
import 'TeachersPage.dart';

class CustomTopAppBar extends StatelessWidget {
  const CustomTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Image.asset("assets/logo.png", height: 40),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TeachersPage.routeName);
            },
            icon: const Icon(Icons.school, color: Colors.orange),
            tooltip: "جميع المدرسين",
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bar_chart, color: Colors.purple),
            tooltip: "مؤشر المستوى",
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh, color: Colors.black54),
            tooltip: "تحديث",
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            tooltip: "الإشعارات",
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, size: 18),
            label: Text(
              "تسجيل الخروج",
              style:
                  GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
