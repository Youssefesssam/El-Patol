import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
class TeatchCard extends StatelessWidget {
  final String image;
  final String name;
  final String subject;
  final int studentsCount;
  final int attended;
  final int totalClasses;

  const TeatchCard({
    super.key,
    required this.image,
    required this.name,
    required this.subject,
    required this.studentsCount,
    required this.attended,
    required this.totalClasses,
  });

  @override
  Widget build(BuildContext context) {
    double percent = totalClasses > 0 ? (attended / totalClasses) : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subject,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Text(
                "$studentsCount طالب",
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                "نسبة الحضور: ${(percent * 100).toStringAsFixed(1)}%",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
