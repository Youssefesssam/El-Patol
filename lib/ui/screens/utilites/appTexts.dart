import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTexts{
  static  bool seenSweet = false ;
  static  bool seenEvent = false ;
  static  bool seenWord = false ;
  static  TextStyle mainText =GoogleFonts.aboreto(fontSize:20 ,color:Colors.black ,fontWeight:FontWeight.bold );
  static  TextStyle secondText =GoogleFonts.aboreto(fontSize:20 ,color:Colors.black ,fontWeight:FontWeight.bold );
  static void fristSeenSweet(bool seenActive){
    seenSweet = seenActive;
  }
  static void fristSeenEvent(bool seenActive){
    seenEvent = seenActive;
  }

  static void fristSeenWord(bool seenActive){
    seenWord = seenActive;
  }


}