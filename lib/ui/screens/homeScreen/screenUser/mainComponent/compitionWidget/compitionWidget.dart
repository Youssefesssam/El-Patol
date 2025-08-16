// competition_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';


import '../../../../../../l10n/app_localizations.dart';
import '../../../../features/featuresHomeScreenUsers/Contents/shimaa/shimmerCard.dart';
import '../../../../features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import '../../../../utilites/appColors.dart';
import '../generalWidget/general/opnionUser.dart';
import 'compettion/attendUser.dart';
import 'compettion/natification/natification.dart';
import 'compettion/prize/prizeScreen.dart';
import 'compettion/score.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
          const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 0),
          child: Text(
            AppLocalizations.of(context)!.competition,
            style: GoogleFonts.acme(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                fontSize: MediaQuery.sizeOf(context).width * 0.09),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optioncompetition('Prize', Icons.military_tech_outlined, () {
                      _onTap();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: PrizeScreen(),
                        ),
                      );
                    }),
                    Notifications(
                      color: Colors.red,
                      num: 1,
                      appear: true,
                      appearIcon: true,
                    )
                  ],
                )),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Score(
                numNatification: 5,
                appearNatification: false,
                colorNatification: Colors.grey,
                selectedMonth: '',
              ),
            ),
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optioncompetition('mission', Icons.minor_crash_sharp, () {
                      _onTap();
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: OpinionUser(),
                        ),
                      );
                    }),
                    Notifications(
                      color: Colors.red,
                      num: 1,
                      appear: true,
                      appearIcon: true,
                    )
                  ],
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Optioncompetition("Rank", Icons.numbers_outlined, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => RankPage(),
                );
              }),
            ),
            Flexible(
              child: Optioncompetition("Attend", Icons.battery_charging_full,
                      () {
                    _onTap();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => AttendUser(),
                    );
                  }),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget Optioncompetition(
      String optionName, IconData icon, VoidCallback onTap) {
    final size = MediaQuery.of(context).size.width * 0.25;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ShimmerCard(
        size: size,
        isLoading: false,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: size * 0.4,
                  color: AppColors.white,
                ),
                SizedBox(height: size * 0.07),
                Text(
                  optionName,
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: size * 0.15,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}