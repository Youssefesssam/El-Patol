import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utilites/appColors.dart';

class CardAbsent extends StatelessWidget {
  final int validAbsentWeeks;
  final bool isAbsent;

  const CardAbsent({
    super.key,
    required this.validAbsentWeeks,
    required this.isAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 25),
      height: MediaQuery.of(context).size.height * .075,
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isAbsent
              ? AppColors.smoothColorTeal
              : [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 2,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isAbsent
                ? "Absent in Week $validAbsentWeeks"
                : "Present in Week $validAbsentWeeks",
            style: GoogleFonts.abhayaLibre(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
