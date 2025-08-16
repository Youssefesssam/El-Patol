import 'package:el_patol/ui/screens/homeScreen/screenUser/componentScreenUser/rankInterFace.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/componentScreenUser/selectMounthForScoreInChart.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/componentScreenUser/settingInterFace.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/componentScreenUser/statisticsInterFace.dart';
import 'package:flutter/material.dart';


import '../../../features/featuresHomeScreenUsers/Contents/shimaa/animatedAvatar.dart';
import '../../../utilites/appColors.dart';
import 'nameAndEmailInterFace.dart';

class AppBarInterFace extends StatelessWidget {
  const AppBarInterFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.appBarColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 10),

        child: Column(
          children: [
            Row(
              children: [
                AnimatedAvatar(),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                const NameAndEmailInterFace(),
                Spacer(),
                const SettingInterFace(),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RankInterFace(),
                SelectMonthForScoreInChart(),
                StatisticsInterFace()
              ],
            )
          ],
        ),
      ),
    );
  }
}
