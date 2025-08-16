import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/event.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/sweetTalk.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/task.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/week.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/word.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// Firebase
import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/dataProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';

// Screens

import '../../../homeScreen/screenUser/mainComponent/generalWidget/general/idea/ideasUser.dart';
import '../../../utilites/appAssets.dart';
import '../../../utilites/consts.dart';
import 'absent/absent.dart';
import 'opnion.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int? lastSelectedWeek;
  bool _isFirstRun = true;
  String? governorate, churchCode, stage;
  bool _isLoading = true;
  Map<String, dynamic>? weekData;
  int count = 0;


  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    loadLeaderData();
  }

  Future<void> loadLeaderData() async {
    setState(() => _isLoading = true);
    governorate = await Consts.getGovernorateName();
    churchCode = await Consts.getChurchCodeLeader();
    stage = await Consts.getStage_codeLeader();
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    await authProviders.saveDataForLeader();
    if (mounted) setState(() => _isLoading = false);
    await New_fire_base_get_data_for_leader.saveWeekDataInProvider(
      context: context,
      governorate: governorate!,
      church: churchCode!,
      stage: stage!,
    );
  }

  bool _loadedAttendCount = false; // أضف دي في الأعلى ضمن state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedAttendCount) {
      _loadedAttendCount = true;

      final authProviders = Provider.of<AuthProviders>(context, listen: false);

      // تحميل عدد الحضور من الشيرد
      authProviders.loadUserAttendCountFromPrefs();

      // تحميل بيانات القائد الأسبوعية (أنت فعلًا عاملها هنا بالفعل)
      Future.microtask(() async {
        await authProviders.saveDataForLeader();

        final data = await New_fire_base_get_data_for_leader.getWeekData(
          numWeek: authProviders.weekUse!,
          governorate: authProviders.governorate!,
          church: authProviders.churchCodeL!,
          stage: authProviders.stageCode!,
        );
        setState(() {
          weekData = data;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() => _controller.forward().then((_) => _controller.reverse());

  void _showCustomBottomSheet(Widget widget) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: widget,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final authProviders = Provider.of<AuthProviders>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) return _buildShimmerLoading();
    DateTime? expireDate;
    DateTime? date;
    bool isSameOrAfter = false;
    String? dayOfRegistration;

    if (weekData != null &&
        weekData!["expireAt"] != null &&
        weekData!["date"] != null &&
        weekData!["dayOfRegistration"] != null) {
      expireDate = weekData!["expireAt"];
      date = weekData!["date"];
      dayOfRegistration = weekData!["dayOfRegistration"];
      final now = DateTime.now();

       isSameOrAfter = !DateTime.now().isBefore(expireDate!);

    }
    if (expireDate != null) {
      print("🕓 now: ${DateTime.now()}");
      print("📅 expireDate: $expireDate");
      print("✅ isSameOrAfter: $isSameOrAfter");
      print("✅ date: $date");
      print("✅ dayOfRegistration: $dayOfRegistration");
    }

    return WillPopScope(
        onWillPop: () async {
      if (authProviders.countUserAttend != 0) {
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                  const SizedBox(height: 15),
                  Text(
                    "تنبيه",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "لم يتم رفع الحضور بعد.\nهل تريد رفع الحضور الآن؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("إلغاء", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            authProviders.countUserAttendFun(count);
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("رفع الحضور"),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
        return shouldLeave ?? false;
      }
      return true;
    },

    child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.withOpacity(0.4),
              Colors.blueGrey.withOpacity(0.4),
              Colors.blue.withOpacity(0.4)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                // Profile Header
                Row(
                  children: [
                    Image.asset(AppAssets.user, height: screenWidth * 0.12),
                    SizedBox(width: 10),
                    Text(
                      authProviders.nameL ?? "Guest",
                      style: GoogleFonts.abhayaLibre(
                        color: Colors.white,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
               /* isSameOrAfter
                    ? Row(
                        children: [
                          Text(
                            weekData!["date"]??'',
                            style: GoogleFonts.abhayaLibre(
                              color: Colors.white,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weekData!["dayOfRegistration"]??'' ,
                            style: GoogleFonts.abhayaLibre(
                              color: Colors.white,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
*/
                SizedBox(
                    height: MediaQuery.of(context).size.height > 700
                        ? MediaQuery.of(context).size.height / 7
                        : MediaQuery.of(context).size.height / 16),
                // Week Box
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: InkWell(
                    onTap: () async {
                      final selectedIndex = await showModalBottomSheet<int>(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) =>
                            Week(currentSelectedWeek: lastSelectedWeek ?? 1),
                      );
                    },
                    child: Container(
                      height: screenWidth * 0.25,
                      width: screenWidth * 0.25,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: isSameOrAfter
                            ? LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade800,
                                  Colors.blue,
                                  Colors.indigo.shade600
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.green,
                                  Colors.greenAccent.shade400,
                                  Colors.green.shade600
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 15,
                              offset: Offset(0, 5))
                        ],
                      ),
                      child: StreamBuilder<int>(
                        stream: New_fire_base_get_data_for_leader.currentWeek(
                          governorate: governorate!,
                          church: churchCode!,
                          stage: stage!,
                        ),
                        builder: (context, snapshot) {
                          int weekNumber =
                              snapshot.data ?? (lastSelectedWeek ?? 0);
                          dataProvider.currentWeekNum = weekNumber;
                          lastSelectedWeek = weekNumber;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$weekNumber",
                                style: GoogleFonts.aclonica(
                                    fontSize: screenWidth * 0.08,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Week",
                                style: GoogleFonts.abyssinicaSil(
                                    fontSize: screenWidth * 0.05,
                                    color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Options Grid
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildOption("Ideas", Icons.lightbulb_outline,
                            () => _showCustomBottomSheet(IdeasUser())),
                        _buildOption("Opinion", Icons.comment,
                            () => _showCustomBottomSheet(Opinion())),
                        _buildOption("Talent", Icons.group,
                            () => Navigator.pushNamed(context, Team.routeName)),
                        _buildOption("Sweet", Icons.favorite_border,
                            () => _showCustomBottomSheet(SweetTalk())),
                        _buildOption("Word", Icons.text_fields,
                            () => _showCustomBottomSheet(Word())),
                        _buildOption(
                            "Absent",
                            Icons.notification_important_sharp,
                            () => _showCustomBottomSheet(Absent())),
                        _buildOption("Task", Icons.assignment,
                            () => _showCustomBottomSheet(Task())),
                        _buildOption("Event", Icons.event,
                            () => _showCustomBottomSheet(Event())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),)
    );
  }

  Widget _buildOption(String title, IconData icon, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth * 0.23;

    return InkWell(
      onTap: () {
        _onTap();
        onTap();
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: size * 0.4, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.abyssinicaSil(
                fontSize: size * 0.15,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
