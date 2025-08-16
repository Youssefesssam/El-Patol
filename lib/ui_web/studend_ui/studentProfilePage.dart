

import 'package:el_patol/ui_web/studend_ui/customTopAppBar.dart';
import 'package:el_patol/ui_web/studend_ui/levelCard.dart';
import 'package:el_patol/ui_web/studend_ui/studentStatsSection.dart';
import 'package:el_patol/ui_web/studend_ui/userInfoCard.dart';
import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  static const String routeName = "studentProfilePage";

  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: Color(0xfff7f8fa),
      body: SingleChildScrollView(
        child: Column(
          children: [
             CustomTopAppBar(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: StudentStatsSection()),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        UserInfoCard(),
                        SizedBox(height: 16),
                        LevelCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






