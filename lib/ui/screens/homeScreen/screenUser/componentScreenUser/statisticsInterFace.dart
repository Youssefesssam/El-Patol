import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../../../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import '../../../utilites/appColors.dart';

class StatisticsInterFace extends StatelessWidget {
  const StatisticsInterFace({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, Statistics.routeName),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.08,
            height: screenWidth * 0.08,
            child: CircularProgressIndicator(
              value:  MediaQuery.of(context).size.height/40,
              strokeWidth: 4,
              backgroundColor: AppColors.lightgrey,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
