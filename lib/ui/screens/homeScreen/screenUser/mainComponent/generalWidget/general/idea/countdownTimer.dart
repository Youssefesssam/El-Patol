import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import '../../../../../../../../firebase/authProvider.dart';
import '../../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../../../../../l10n/app_localizations.dart';

class CountdownTimer extends StatefulWidget {
  final int currentWeekNumber;
  final void Function(bool) onTimerFinished; // 👈 الكولباك الجديد

  CountdownTimer({
    required this.currentWeekNumber,
    required this.onTimerFinished,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  int _remainingTime = 0;
  bool _showMessage = true;

  @override
  void initState() {
    super.initState();
    initializeWeekData(widget.currentWeekNumber).then((_) {
      _fetchRemainingTime(widget.currentWeekNumber);
    });
  }

  Future<void> initializeWeekData(int currentWeekNumber) async {
    try {
      AuthProviders authProviders = Provider.of(context, listen: false);
      final weekDataDoc =   FirebaseFirestore.instance
          .collection("governorate")
          .doc(authProviders.governorateUs??authProviders.governorate!)
          .collection('church')
          .doc(authProviders.churchCodeUs??authProviders.churchCodeL!)
          .collection('activites')
          .doc(authProviders.stageCodeUs??authProviders.stageCode!).collection('settings').doc(
          'weekData');
      final snapshot = await weekDataDoc.get();

      int? storedWeekNumber = snapshot.data()?['weekNumber'] as int?;
      Timestamp? storedWeekStartTime = snapshot
          .data()?['weekStartTime'] as Timestamp?;

      if (storedWeekNumber == null || storedWeekNumber != currentWeekNumber) {

        await weekDataDoc.set({
          'weekStartTime': FieldValue.serverTimestamp(),
          'weekNumber': currentWeekNumber,
        }, SetOptions(merge: true));

        print(
            "تم تعيين وقت بداية الأسبوع الجديد! الأسبوع رقم: $currentWeekNumber");
        New_fire_base_set_data_for_user.deleteOpinion(
            governorate: authProviders.governorateUs ??
                authProviders.governorate!,
            church: authProviders.churchCodeUs ?? authProviders.churchCodeL!,
            stage: authProviders.stageCode ?? authProviders.stageCode!);
      } else {
        print("الأسبوع رقم $storedWeekNumber مستمر ولم يتغير.");
      }
    } catch (e) {
      print("خطأ أثناء تحديث بيانات الأسبوع: $e");
    }
  }

  void _fetchRemainingTime(int currentWeekNumber) async {
    AuthProviders authProviders = Provider.of(context, listen: false);
    final snapshot = await   FirebaseFirestore.instance
        .collection("governorate")
        .doc(authProviders.governorateUs??authProviders.governorate!)
        .collection('church')
        .doc(authProviders.churchCodeUs??authProviders.churchCodeL!)
        .collection('activites')
        .doc(authProviders.stageCodeUs??authProviders.stageCode!).collection('settings')
        .doc('weekData')
        .get();
    int? storedWeekNumber = snapshot.data()?['weekNumber'] as int?;
    Timestamp? startTime = snapshot.data()?['weekStartTime'] as Timestamp?;

    if (storedWeekNumber == null || storedWeekNumber != currentWeekNumber) {
      print("يتم إعادة ضبط الأسبوع لأن رقم الأسبوع تغيّر.");
      await initializeWeekData(currentWeekNumber);
      return;
    }

    DateTime endTime = startTime!.toDate().add(const Duration(days: 3));
    setState(() {
      _remainingTime = endTime
          .difference(DateTime.now())
          .inSeconds;

      if (_remainingTime <= 0) {
        _executeWinningAction();
      } else {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    if (_remainingTime > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime <= 0) {
          timer.cancel();
          _executeWinningAction();
        } else {
          setState(() {
            _remainingTime--;
            print("Remaining time: $_remainingTime seconds");
          });
        }
      });
    }
  }

  void _executeWinningAction() async {
    AuthProviders authProviders = Provider.of(context, listen: false);

    QuerySnapshot opinionsSnapshot = await   FirebaseFirestore.instance
        .collection("governorate")
        .doc(authProviders.governorateUs??authProviders.governorate!)
        .collection('church')
        .doc(authProviders.churchCodeUs??authProviders.churchCodeL!)
        .collection('activites')
        .doc(authProviders.stageCodeUs??authProviders.stageCode!)
        .collection('opinions')
        .orderBy('votes', descending: true)
        .limit(1)
        .get();
    if (opinionsSnapshot.docs.isNotEmpty) {
      String winningOpinion = opinionsSnapshot.docs.first.id;
      FirebaseFirestore.instance
          .collection("governorate")
          .doc(authProviders.governorateUs??authProviders.governorate!)
          .collection('church')
          .doc(authProviders.churchCodeUs??authProviders.churchCodeL!)
          .collection('activites')
          .doc(authProviders.stageCodeUs??authProviders.stageCode!)          .collection('opinions')
          .doc(winningOpinion)
          .update({'status': 'winner'});
    }

    // 👇 إرسال bool للصفحة الأم
    widget.onTimerFinished(true);

    setState(() {
      _showMessage = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showMessage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime <= 0) {
      return _showMessage
          ? Text(
        AppLocalizations.of(context)!.timesUp,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      )
          : SizedBox();
    }

    int days = _remainingTime ~/ 86400;
    int hours = (_remainingTime % 86400) ~/ 3600;
    int minutes = (_remainingTime % 3600) ~/ 60;
    int seconds = _remainingTime % 60;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[300]!.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeUnit(days, AppLocalizations.of(context)!.days),
          const SizedBox(width: 12),
          _buildTimeUnit(hours, AppLocalizations.of(context)!.hours),
          const SizedBox(width: 12),
          _buildTimeUnit(minutes, AppLocalizations.of(context)!.minutes),
          const SizedBox(width: 12),
          _buildTimeUnit(seconds, AppLocalizations.of(context)!.seconds),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }
}