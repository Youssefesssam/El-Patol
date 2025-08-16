import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final int max;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    double percent = max > 0 ? (value / max) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            "$percent%",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "$value من $max",
            style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
