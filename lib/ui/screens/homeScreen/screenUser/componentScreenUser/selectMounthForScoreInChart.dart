import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../../firebase/monthProvider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../utilites/appColors.dart';

class SelectMonthForScoreInChart extends StatefulWidget {
  const SelectMonthForScoreInChart({super.key});

  @override
  State<SelectMonthForScoreInChart> createState() => _SelectMonthForScoreInChartState();
}

class _SelectMonthForScoreInChartState extends State<SelectMonthForScoreInChart> {
  final List<String> monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  final List<String> monthsAr = [
    'يناير', 'فبراير', 'مارس', 'ابريل', 'مايو', 'يونيو',
    'يوليو', 'اغسطس', 'سبتمبر', 'اكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  late int initialMonthIndex;

  @override
  void initState() {
    super.initState();
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    initialMonthIndex = ((authProviders.weekUse ?? 1) - 1) ~/ 4;
  }

  void onMonthSelected(int index) {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    final monthProvider = Provider.of<MonthProvider>(context, listen: false);

    monthProvider.updateMonth(index + 1); // لأن index يبدأ من 0

    FireBaseSetDataForUser.getThisWeek(
      userId: authProviders.userId!,
      numWeek: authProviders.currentWeek!,
      monthId: authProviders.currentMonth!,
      numWeekUse: authProviders.weekUse!,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height/7,
      right: MediaQuery.of(context).size.shortestSide/3,
      left: MediaQuery.of(context).size.shortestSide/3,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height:  MediaQuery.of(context).size.height/15,
          width: MediaQuery.of(context).size.width/20,
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(initialItem: initialMonthIndex),
            onSelectedItemChanged: onMonthSelected,
            children: (AppLocalizations.of(context)!.language == "English"
                ? monthsEn
                : monthsAr
            ).map((month) {
              return Center(
                child: Text(
                  month,
                  style: GoogleFonts.adamina(
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
