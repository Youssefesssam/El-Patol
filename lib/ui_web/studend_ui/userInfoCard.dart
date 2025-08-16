import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

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
          Text(
            "يوسف عصام نعيم ميخائيل",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text("01279179585", style: GoogleFonts.cairo(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.phone_android, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text("رقم ولي الأمر - 01279584257",
                  style: GoogleFonts.cairo(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text("القاهرة", style: GoogleFonts.cairo(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.school, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text("عام", style: GoogleFonts.cairo(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.class_, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text("الصف الثالث الثانوي",
                  style: GoogleFonts.cairo(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("أونلاين",
                      style: GoogleFonts.cairo(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text("تحويل سنتر",
                      style: GoogleFonts.cairo(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
