import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../firebase/providerTotalScore.dart';
import '../listOfUsers/listOfUsers.dart';

class Week extends StatefulWidget {
  final int currentSelectedWeek;

  const Week({super.key, required this.currentSelectedWeek});

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> with AutomaticKeepAliveClientMixin {
  late FixedExtentScrollController _scrollController;
  late int selectedIndex; // نستخدم index داخليًا (0-based)
  final List<String> weeksList = List.generate(
    48,
    (index) => 'Week ${index + 1}',
  )..add("Hello New Year");

  @override
  void initState() {
    super.initState();
    selectedIndex =
        widget.currentSelectedWeek - 1; // تحويل week number إلى index
    _scrollController = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _confirmSelection(BuildContext context) async {
    final AuthProviders authProviders = Provider.of(context, listen: false);
    final ProviderTotalScore providerTotalScore = Provider.of(
      context,
      listen: false,
    );

    // جلب البيانات مع إعطاء قيم افتراضية إذا كانت null
    int nextWeek = await New_fire_base_get_data_for_leader.getNextWeek(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: "${authProviders.stageTypeL}_${authProviders.stageYearL}",
    ); // الأسبوع التالي = 2 إذا لم يكن موجودًا

    int previousWeek = await New_fire_base_get_data_for_leader.getPreviousWeek(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: "${authProviders.stageTypeL}_${authProviders.stageYearL}",
    ); // لا يوجد أسابيع سابقة

    int selectedWeek = selectedIndex + 1;

    bool isValidSelection = selectedWeek < nextWeek;
    bool isOldSelection = selectedWeek < (previousWeek + 1);
    bool isCurrentSelection = selectedWeek == widget.currentSelectedWeek + 1;
    bool isSameAsCurrent = selectedWeek == widget.currentSelectedWeek;

    // إذا الضغط على نفس الأسبوع الحالي → نختار الأسبوع التالي
    if (isSameAsCurrent) {
      selectedWeek += 1;
      setState(() {
        selectedIndex = selectedWeek - 1;
      });

      // إعادة تقييم الشروط مع القيمة الجديدة
      isValidSelection = selectedWeek < nextWeek;
      isOldSelection = selectedWeek < (previousWeek + 1);
      isCurrentSelection = selectedWeek == widget.currentSelectedWeek + 1;
    }

    // خاص بالرسالة فقط: تجنب عرض "past week" في أول استخدام
    bool showPastWarning = isOldSelection && previousWeek > 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: showPastWarning ? Colors.red[100] : null,
        title: Text(
          'Confirm Selection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: showPastWarning
                ? Colors.red[900]
                : Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Next Week: $nextWeek | Current Week: ${previousWeek + 1}'),
            const SizedBox(height: 15),
            Text(
              'You selected Week $selectedWeek',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isValidSelection
                    ? (showPastWarning ? Colors.red[900] : Colors.black)
                    : Colors.red,
              ),
            ),

            if (isCurrentSelection)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Perfect choice!',
                    style: TextStyle(color: Colors.green),
                  ),
                  Icon(Icons.grade_rounded, color: Colors.green),
                ],
              ),
            if (showPastWarning)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '⚠ You are selecting a past week! Be careful.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            if (!isValidSelection)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '⚠ Cannot select a week greater than Next Week!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isValidSelection
                  ? (showPastWarning ? Colors.red : Colors.blueAccent)
                  : Colors.grey,
            ),
            onPressed: isValidSelection
                ? () async {
                    Navigator.pop(context);
                    providerTotalScore.resetScores();
                    if (selectedIndex == 48) {
                      New_fire_base_get_data_for_leader.newYear(
                        governorate: authProviders.governorate!,
                        church: authProviders.churchCodeL!,
                        stage: authProviders.stageCode!,
                      );
                    }
                    setState(() {});
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('attended_users_codes');
                    // حفظ القيم في Firebase
                    authProviders.setWeek(selectedWeek);
                    authProviders.setCurrentMonth(selectedWeek);
                    print(
                      'week in auth printed in week ===============================${authProviders.week}',
                    );
                    print(
                      'weekUse in auth printed in week===============================${authProviders.weekUse}',
                    );
                    New_fire_base_set_data_for_leader.numWeek(
                      numWeek: selectedWeek,
                      stage: authProviders.stageCode!,
                      church: authProviders.churchCodeL!,
                      governorate: authProviders.governorate!,
                    );

                    New_fire_base_set_data_for_leader.updateCurrentWeek(
                      weekNumber: selectedWeek,
                      governorate: authProviders.governorate!,
                      church: authProviders.churchCodeL!,
                      stage: authProviders.stageCode!,
                    );

                    New_fire_base_set_data_for_leader.updateNextWeek(
                      current: selectedWeek,
                      governorate: authProviders.governorate!,
                      church: authProviders.churchCodeL!,
                      stage: authProviders.stageCode!,
                    );

                    New_fire_base_set_data_for_leader.updatePreviousWeek(
                      current: selectedWeek - 1,
                      governorate: authProviders.governorate!,
                      church: authProviders.churchCodeL!,
                      stage: authProviders.stageCode!,
                    );
                    Navigator.pop(context, selectedWeek);
                  }
                : null,

            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exitAction(BuildContext context) {
    final AuthProviders authProviders = Provider.of(context, listen: false);
    New_fire_base_set_data_for_leader.numWeek(
      numWeek: selectedIndex + 1,
      stage: authProviders.stageCode!,
      church: authProviders.churchCodeL!,
      governorate: authProviders.governorate!,
    );
    Navigator.pop(context, selectedIndex + 1);
  }

  void _updateAction(BuildContext context) {
    final AuthProviders authProviders = Provider.of(context, listen: false);
    Navigator.pushNamed(context, ListOfUsers.routeName);
    New_fire_base_set_data_for_leader.updateWeek(
      weekNumber: selectedIndex + 1,
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 3,
            indent: 150,
            endIndent: 150,
            color: Colors.blue.shade700,
          ),
          Text(
            'Select Week',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 50,
              scrollController: _scrollController,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: weeksList.map((w) {
                return Center(child: Text(w));
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionButton(
                text: 'Exit',
                color: const [Color(0xff9b1010), Colors.red],
                onTap: () => _exitAction(context),
              ),
              ActionButton(
                text: 'Confirm',
                color: [
                  Colors.deepPurple.shade800,
                  Colors.blue,
                  Colors.indigo.shade600,
                ],
                onTap: () => _confirmSelection(context),
              ),
              ActionButton(
                text: 'Update',
                color: [Colors.green, Colors.cyan[700]!],
                onTap: () => _updateAction(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// زر مخصص لإعادة الاستخدام
class ActionButton extends StatelessWidget {
  final String text;
  final List<Color> color;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(colors: color),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
