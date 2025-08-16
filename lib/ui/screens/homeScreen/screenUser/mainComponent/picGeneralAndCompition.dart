import 'package:el_patol/ui/screens/homeScreen/screenUser/mainComponent/selectEmoji/selectEmoji.dart';
import 'package:flutter/material.dart';


import 'compitionWidget/compitionWidget.dart';
import 'generalWidget/generalWidget.dart';

 abstract class PicGeneralAndCompition{

 static final List<Widget> pic = [
   const GeneralScreen(),
    const CompetitionScreen(),
   SelectEmoji(),

 ];
}