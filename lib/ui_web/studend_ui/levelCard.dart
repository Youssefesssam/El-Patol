import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/utilites/appAssets.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(
            AppAssets.man,
            height: 300,
          ),
          const SizedBox(height: 8),
          Text(
            "🔥 مستواك في تصاعد مستمر!\nأحسنت! أضفت 1 نقطة جديدة لرصيدك. لا أحد يستطيع إيقافك! 💪",
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
