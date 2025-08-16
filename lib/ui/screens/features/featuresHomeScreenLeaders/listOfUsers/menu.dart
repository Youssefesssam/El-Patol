import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseGetDataForeLeader.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../model/modelUser.dart';
import '../../../../../services/governorateserveces.dart';

class Menu extends StatefulWidget {
  final String userId;
  final String userCode;
  final MyUser user;
  final VoidCallback onCloseMenu;

  const Menu({
    super.key,
    required this.onCloseMenu,
    required this.userId,
    required this.user,
    required this.userCode,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int totalScore = 0;
  bool isMassActive = false;
  int massScore = 0;
  bool isCommunionActive = false;
  int communionScore = 0;
  bool isConfessionActive = false;
  int confessionScore = 0;
  bool isMeetingActive = false;
  int meetingScore = 0;
  bool isWaiting = false;
  bool isDone = false;
  late String stageYear;
  late String stageType;
  String? stageCode;
  late String churchCode;
  late String governateCode;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600; // تحديد إذا كانت الشاشة صغيرة

    AuthProviders authProviders = Provider.of(context);
    New_fire_base_get_data_for_leader.getCurrentWeek(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
    );

    if (widget.userCode.length >= 7 && widget.userCode.startsWith('U')) {
      governateCode = widget.userCode.substring(1, 3);
      governateCode = GovernorateService.getName(governateCode, 'en');
      churchCode = widget.userCode.substring(3, 6);
      stageType = widget.userCode[6];
      stageYear =
          widget.userCode.length > 7 ? widget.userCode.substring(7, 8) : 'X';
      stageCode = '$stageType' '_' '$stageYear';
    } else {
      churchCode = 'XXX';
      stageType = 'X';
      stageYear = 'X';
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 35 : 40),
      decoration: BoxDecoration(
        color: Color(0xd0777676),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.blue[800]!.withOpacity(0.5), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow(
            "القداس",
            isMassActive,
            massScore,
            () => toggleState("mass"),
            isSmallScreen,
          ),
          const Divider(thickness: 1, color: Colors.white),
          buildRow(
            "التناول",
            isCommunionActive,
            communionScore,
            () => toggleState("communion"),
            isSmallScreen,
          ),
          const Divider(thickness: 1, color: Colors.white),
          buildRow(
            "الاعتراف",
            isConfessionActive,
            confessionScore,
            () => toggleState("confession"),
            isSmallScreen,
          ),
          const Divider(thickness: 1, color: Colors.white),
          buildRow(
            "الاجتماع",
            isMeetingActive,
            meetingScore,
            () => toggleState("meeting"),
            isSmallScreen,
          ),
          const Divider(thickness: 1, color: Colors.white),
          Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: isSmallScreen ? 10 : 20),
                        InkWell(
                          onTap: resetScores,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 15 : 20,
                              vertical: isSmallScreen ? 8 : 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.reset,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 10 : 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                            return AnimatedBuilder(
                              animation: rotate,
                              child: child,
                              builder: (context, child) {
                                final angle = rotate.value;
                                final isUnder = (angle > pi / 2);
                                return Transform(
                                  transform: Matrix4.rotationY(angle),
                                  alignment: Alignment.center,
                                  child: isUnder
                                      ? Opacity(opacity: 0, child: child)
                                      : child,
                                );
                              },
                            );
                          },
                          child: isDone
                              ? Icon(
                            Icons.done,
                            key: const ValueKey("doneButton"),
                            color: Colors.green,
                            size: isSmallScreen ? 30 : 35,
                          )
                              : InkWell(
                            key: const ValueKey("confirmButton"),
                            onTap: () async {
                              setState(() {
                                isDone = true;
                                isWaiting = false;
                              });

                              await Future.delayed(const Duration(milliseconds: 800));

                              if (!mounted) return;

                              widget.onCloseMenu();

                              setState(() => isDone = false);

                              Future.microtask(() {
                                addScoreUser(
                                  score: totalScore,
                                  meetingScoreDB: meetingScore,
                                  communionScoreDB: communionScore,
                                  confessionScoreDB: confessionScore,
                                  massScoreDB: massScore,
                                  churchCode: authProviders.churchCodeL!,
                                  userCode: widget.userCode,
                                  stage: authProviders.stageCode!,
                                  governorate: authProviders.governorate!,
                                );

                                if (isMeetingActive) {
                                  count++;
                                  New_fire_base_set_data_for_leader.UsersAlreadyAttend(
                                    weekNum: authProviders.weekUse!,
                                    user: widget.user,
                                    totalScore: totalScore,
                                    massScore: massScore,
                                    communionScore: communionScore,
                                    confessionScore: confessionScore,
                                    meetingScore: meetingScore,
                                    governorate: authProviders.governorate!,
                                    church: authProviders.churchCodeL!,
                                    stage: authProviders.stageCode!,
                                    profileUrl: widget.user.profileUrl,
                                  );
                                }

                                authProviders.countUserAttendFun(count);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 40 : 50,
                                vertical: isSmallScreen ? 8 : 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.confirm,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(String label, bool isActive, int score, VoidCallback toggle,
      bool isSmallScreen) {
    return Row(children: [
      Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
        child: Text(
          label,
          style:
              TextStyle(fontSize: isSmallScreen ? 18 : 25, color: Colors.white),
        ),
      ),
      const Spacer(),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isActive
            ? Text(
                "+$score",
                key: ValueKey(label),
                style: TextStyle(
                    color: Colors.blue, fontSize: isSmallScreen ? 18 : 20),
              )
            : const SizedBox(key: ValueKey("hidden")),
      ),
      const SizedBox(width: 10),
      InkWell(
        onTap: toggle,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isActive ? Icons.check_box : Icons.check_box_outline_blank_outlined,
            key: ValueKey(isActive),
            color: Colors.white,
            size: isSmallScreen ? 25 : 30,
          ),
        ),
      ),
    ]);
  }

  void toggleState(String key) {
    setState(() {
      switch (key) {
        case "mass":
          isMassActive = !isMassActive;
          massScore = isMassActive ? 25 : 0;
          break;
        case "communion":
          isCommunionActive = !isCommunionActive;
          communionScore = isCommunionActive ? 25 : 0;
          break;
        case "confession":
          isConfessionActive = !isConfessionActive;
          confessionScore = isConfessionActive ? 25 : 0;
          break;
        case "meeting":
          isMeetingActive = !isMeetingActive;
          meetingScore = isMeetingActive ? 25 : 0;
          break;
      }
      totalScore = massScore + communionScore + confessionScore + meetingScore;
    });
  }

  void resetScores() {
    setState(() {
      totalScore = 0;
      isMassActive =
          isCommunionActive = isConfessionActive = isMeetingActive = false;
      massScore = communionScore = confessionScore = meetingScore = 0;
      isWaiting = false;
      isDone = false;
    });
  }

  void addScoreUser({
    required int score,
    required int meetingScoreDB,
    required int communionScoreDB,
    required int confessionScoreDB,
    required int massScoreDB,
    required String churchCode,
    required String userCode,
    required String stage,
    required String governorate,
  }) async {
    setState(() {
      isWaiting = false;
      isDone = true;
    });

    AuthProviders authProviders = Provider.of(context, listen: false);
    String userId = widget.userId;

    if (userId.isEmpty) {
      setState(() => isWaiting = false);
      return;
    }

    final WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      print("week: ${authProviders.week}");
      print("month: ${authProviders.currentMonth}");
      print("weekUse: ${authProviders.weekUse}");
      print("stageCode: ${authProviders.stageCode}");
      print("governorate: ${authProviders.governorate}");
      print("churchCodeL: ${authProviders.churchCodeL}");
      print("code: ${userCode}");

      print("=== DEBUG: Sending to Firebase ===");
      print("Mass: $massScoreDB");
      print("Communion: $communionScoreDB");
      print("Confession: $confessionScoreDB");
      print("Meeting: $meetingScoreDB");
      print("Total: $score");
      print('month number: ${authProviders.currentMonth!}');
      print('week number: ${authProviders.weekUse}');

      await New_fire_base_set_data_for_leader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: score,
        scoreType: 'leaderScore',
        userId: userId,
        stage: stage,
        governorate: governorate,
        church: churchCode,
        code: userCode,
      );

      await New_fire_base_set_data_for_leader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: massScoreDB,
        scoreType: 'massScoreDB',
        userId: userId,
        stage: stage,
        governorate: governorate,
        church: churchCode,
        code: userCode,
      );

      await New_fire_base_set_data_for_leader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: communionScoreDB,
        scoreType: 'communionScoreDB',
        userId: userId,
        stage: stage,
        governorate: governorate,
        church: churchCode,
        code: userCode,
      );

      await New_fire_base_set_data_for_leader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: confessionScoreDB,
        scoreType: 'confessionScoreDB',
        userId: userId,
        stage: stage,
        governorate: governorate,
        church: churchCode,
        code: userCode,
      );

      await New_fire_base_set_data_for_leader.updateScore(
        yearId: '1',
        weekId: authProviders.week.toString(),
        monthId: authProviders.currentMonth!,
        newValue: meetingScoreDB,
        scoreType: 'meetingScoreDB',
        userId: userId,
        stage: stage,
        governorate: governorate,
        church: churchCode,
        code: userCode,
      );

      New_fire_base_set_data_for_leader.getThisDetalsWeek(
        userId: userId,
        numWeek: authProviders.week!,
        monthId: authProviders.currentMonth!,
        numWeekUse: authProviders.weekUse!,
        stage: authProviders.stageCode!,
        governorate: authProviders.governorate!,
        church: authProviders.churchCodeL!,
        code: userCode,
      );

      DocumentReference massRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(userCode)
          .collection('user')
          .doc(userId)
          .collection('scores')
          .doc('massScoreDB');

      DocumentReference communionRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(userCode)
          .collection('user')
          .doc(userId)
          .collection('scores')
          .doc('communionScoreDB');

      DocumentReference confessionRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(userCode)
          .collection('user')
          .doc(userId)
          .collection('scores')
          .doc('confessionScoreDB');

      DocumentReference meetingRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(userCode)
          .collection('user')
          .doc(userId)
          .collection('scores')
          .doc('meetingScoreDB');

      DocumentReference leaderRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc(governorate)
          .collection('church')
          .doc(churchCode)
          .collection("users_church")
          .doc(stage)
          .collection("users")
          .doc(userCode)
          .collection('user')
          .doc(userId);

      batch.set(massRef, {'value': massScoreDB});
      batch.set(communionRef, {'value': communionScoreDB});
      batch.set(confessionRef, {'value': confessionScoreDB});
      batch.set(meetingRef, {'value': meetingScoreDB});
      batch.set(leaderRef, {'leaderScore': score}, SetOptions(merge: true));

      await batch.commit();

      if (!mounted) return;
      setState(() {
        isWaiting = false;
        isDone = true;
      });
    } catch (error) {
      print("Error adding data: $error");
      setState(() {
        isWaiting = false;
        isDone = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding data: $error")));
    }
  }
}
