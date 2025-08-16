import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../../../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../../../utilites/appColors.dart';

class RankInterFace extends StatelessWidget {
  const RankInterFace({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, RankPage.routeName),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "#1",
            style: GoogleFonts.aclonica(
              fontSize: screenHeight * 0.040, // بدلاً من /20
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
