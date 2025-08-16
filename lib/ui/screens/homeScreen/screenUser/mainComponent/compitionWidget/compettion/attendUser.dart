import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../../../firebase/authProvider.dart';
import '../../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'cardAbsent.dart';

class AttendUser extends StatefulWidget {
  const AttendUser({super.key});

  @override
  State<AttendUser> createState() => _AttendUserState();
}

class _AttendUserState extends State<AttendUser> {
  int? currentMonth;
  Stream<Map<int, bool>>? _weekStatusStream;

  final List<String> month = [
    "",
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    AuthProviders authProviders = Provider.of(context, listen: false);

    New_fire_base_get_data_for_leader.fetchCurrentWeek(
      governorate: authProviders.governorateUs!,
      church: authProviders.churchCodeUs!,
      stage: authProviders.stageCodeUs!,
    ).then((weekNum) {
      int initMonth = ((weekNum - 1) ~/ 4) + 1;
      setState(() {
        currentMonth = initMonth;
        _weekStatusStream = authProviders.streamWeekStatuses(
          governorateName: authProviders.governorateUs!,
          churchCode: authProviders.churchCodeUs!,
          stage: authProviders.stageCodeUs!,
          id: authProviders.userId!,
          monthNum: initMonth,
        );
      });
    });
  }

  void _updateStreamForMonth(AuthProviders authProviders) {
    _weekStatusStream = authProviders.streamWeekStatuses(
      governorateName: authProviders.governorateUs!,
      churchCode: authProviders.churchCodeUs!,
      stage: authProviders.stageCodeUs!,
      id: authProviders.userId!,
      monthNum: currentMonth!,
    );
  }

  List<int> getWeeksForMonth(int monthNum) {
    return List.generate(4, (index) => (monthNum - 1) * 4 + index + 1);
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of<AuthProviders>(context);

    // ✅ لو البيانات لسه ماجهزتش
    if (_weekStatusStream == null || currentMonth == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.didIGo}🧐 ",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal[700],
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.blue),
                          onPressed: () {
                            if (currentMonth! > 1) {
                              setState(() {
                                currentMonth = currentMonth! - 1;
                                _updateStreamForMonth(authProviders);
                              });
                            }
                          },
                        ),
                        Text(
                          'Month $currentMonth - ${month[currentMonth!]}',
                          style: GoogleFonts.cairo(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.blue),
                          onPressed: () {
                            if (currentMonth! < 12) {
                              setState(() {
                                currentMonth = currentMonth! + 1;
                                _updateStreamForMonth(authProviders);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: StreamBuilder<Map<int, bool>>(
                      stream: _weekStatusStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(child: Text("Error loading data"));
                        }

                        Map<int, bool> weekStatuses = snapshot.data!;
                        int consecutiveAbsents = 0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Month : ${month[currentMonth!]}",
                              style: GoogleFonts.abhayaLibre(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...weekStatuses.entries.map((entry) {
                              final weekNumber = (entry.key - 1) % 4 + 1;
                              final isAbsent = entry.value;

                              if (isAbsent) {
                                consecutiveAbsents++;
                              } else {
                                consecutiveAbsents = 0;
                              }

                              return Column(
                                children: [
                                  CardAbsent(
                                    validAbsentWeeks: weekNumber,
                                    isAbsent: isAbsent,
                                  ),
                                  const SizedBox(height: 10),
                                  if (consecutiveAbsents == 2)
                                    const Center(
                                      child: Text(
                                        "send notification for leader",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
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
