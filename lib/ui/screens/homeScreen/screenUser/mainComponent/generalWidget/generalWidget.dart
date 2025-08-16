// general_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../model/modelEvent.dart';
import '../../../../../../model/modelSweetTalk.dart';

import '../../../../features/featuresHomeScreenUsers/Contents/shimaa/shimmerCard.dart';
import '../../../../utilites/appColors.dart';
import '../../../../utilites/appTexts.dart';
import '../compitionWidget/compettion/natification/natification.dart';
import 'general/eventUser.dart';
import 'general/idea/ideasUser.dart';
import 'general/opnionUser.dart';
import 'general/sweetTalkUser.dart';
import 'general/taskUser.dart';
import 'general/emoji.dart';
import 'general/weekUser.dart';
import 'general/wordUser.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool unSeenSweetTalk = AppTexts.seenSweet;
  bool unSeenWord = AppTexts.seenWord;
  bool unSeenEvent = AppTexts.seenEvent;
  String lastEvent = "";
  String lastWord = "";
  String lastTask = "";
  String lastSweet = "";
  String newEvent = "";
  String newWord = "";
  String newTask = "";
  String newSweet = "";

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

  Future<bool> hasNew(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> keys = {
      "event": "lastEventId",
      "word": "lastWordId",
      "task": "lastTaskId",
      "sweet": "lastSweetId",
    };
    if (!keys.containsKey(type)) return false;
    String lastId = prefs.getString(keys[type]!) ?? "";
    String newId = await hasNotification(type);
    return lastId != newId;
  }

  Future<String> hasNotification(String type) async {
    AuthProviders authProviders=Provider.of(context,listen: false);
    Map<String, String> collections = {
      "event": ModelHiEvent.collection,
      "word": "word",
      "task": "task",
      "sweet": ModelSweetTalk.collection,
    };
    if (!collections.containsKey(type)) return "";
    var fire = await   FirebaseFirestore.instance
        .collection("governorate")
        .doc(authProviders.governorateUs)
        .collection('church')
        .doc(authProviders.churchCodeUs)
        .collection('activites')
        .doc(authProviders.stageCodeUs)
        .collection(collections[type]!)
        .limit(1)
        .get();
    return fire.docs.isNotEmpty ? fire.docs.first.id : "";
  }

 /* Future<void> saveUserIdInProvider(BuildContext context) async {
    String? userId = await Consts.getUserId();
    String? profile = await Consts.getProfile();
    var snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('currentWeek')
        .get();
    if (snapshot.exists &&
        snapshot.data() != null &&
        snapshot.data()!.containsKey("weekNumber")) {
      Provider.of<AuthProviders>(context, listen: false)
          .setCurrentWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(context, listen: false)
          .setWeek(snapshot["weekNumber"]);
      Provider.of<AuthProviders>(context, listen: false)
          .setCurrentMonth(snapshot["weekNumber"]);
    }
    if (userId != null) {
      Provider.of<AuthProviders>(context, listen: false).setUserId(userId);
      Provider.of<AuthProviders>(context, listen: false)
          .setUserProfile(profile!);
    }
  }*/

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {

    _controller.forward().then((_) {});
  }

  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            AppLocalizations.of(context)!.general,
            style: GoogleFonts.acme(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.sizeOf(context).width * 0.09,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Optiongeneral('IDeas', Icons.lightbulb_outline, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => IdeasUser(),
                );
              }),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: InkWell(
                onTap: () async {
                  WeekUser();
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.width * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: AppColors.smoothColorTeal,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream:   FirebaseFirestore.instance
                        .collection("governorate")
                        .doc(authProviders.governorateUs)
                        .collection('church')
                        .doc(authProviders.churchCodeUs)
                        .collection('activites')
                        .doc(authProviders.stageCodeUs)
                        .collection('settings')
                        .doc('currentWeek')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            authProviders.weekUse!=null ?Text(
                              "${authProviders.weekUse}",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.09,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ):Text(
                              " ",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.03,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  0.005,
                            ),
                            Text(
                              "week",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.03,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${authProviders.weekUse??"week"}",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.09,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  0.005,
                            ),
                            Text(
                              "week",
                              style: GoogleFonts.aclonica(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.03,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                      final weekNumber =
                      snapshot.data!['weekNumber'] as int?;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$weekNumber",
                            style: GoogleFonts.aclonica(
                              fontSize:
                              MediaQuery.of(context).size.width * 0.09,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.005,
                          ),
                          Text(
                            "week",
                            style: GoogleFonts.aclonica(
                              fontSize:
                              MediaQuery.of(context).size.width * 0.03,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              child: Optiongeneral('Opinion', Icons.comment, () {
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
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optiongeneral(
                      "Sweet",
                      Icons.favorite_border,
                          () async {
                        _onTap();
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        String newSweetId =
                        await hasNotification("sweet");
                        await prefs.setString("lastSweetId", newSweetId);
                        setState(() {
                          unSeenSweetTalk = false;
                        });
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => SweetTalkUser(),
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: hasNew("sweet"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: false,
                            appearIcon: true,
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: snapshot.data ?? false,
                            appearIcon: false,
                          );
                        }
                      },
                    ),
                  ],
                )),
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optiongeneral(
                      "Word",
                      Icons.text_fields,
                          () async {
                        _onTap();
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        String newWordId =
                        await hasNotification("word");
                        await prefs.setString("lastWordId", newWordId);
                        setState(() {
                          unSeenWord = false;
                        });
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => WordUser(),
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: hasNew("word"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: false,
                            appearIcon: false,
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: snapshot.data ?? false,
                            appearIcon: false,
                          );
                        }
                      },
                    ),
                  ],
                )),
            Flexible(
              child: Optiongeneral("EMOJI", Icons.emoji_emotions_sharp, () {
                _onTap();
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) =>
                      _buildDraggableScrollableSheet( MyEmoji()),
                );
              }),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optiongeneral(
                      "Taskoo",
                      Icons.assignment,
                          () async {
                        _onTap();
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        String newTaskId =
                        await hasNotification("task");
                        await prefs.setString("lastTaskId", newTaskId);
                        setState(() {
                          unSeenEvent = false;
                        });
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Taskuser(),
                          ),
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: hasNew("task"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: false,
                            appearIcon: false,
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Notifications(
                            color: Colors.red,
                            num: 1,
                            appear: snapshot.data ?? false,
                            appearIcon: false,
                          );
                        }
                      },
                    ),
                  ],
                )),
            Flexible(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Optiongeneral(
                    "Hi.Event",
                    Icons.event,
                        () async {
                      _onTap();
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      String newEventId =
                      await hasNotification("event");
                      await prefs.setString("lastEventId", newEventId);
                      setState(() {
                        lastEvent = newEventId;
                      });
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => EventUser(),
                      );
                    },
                  ),
                  FutureBuilder<bool>(
                    future: hasNew("event"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Notifications(
                          color: Colors.red,
                          num: 1,
                          appear: false,
                          appearIcon: false,
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Notifications(
                          color: Colors.red,
                          num: 1,
                          appear: snapshot.data ?? false,
                          appearIcon: false,
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
  double getResponsiveSize(double screenWidth) {
    if (screenWidth <= 320) {
      // شاشات صغيرة جدًا (iPhone SE وما شابه)
      return screenWidth * 0.16;
    } else if (screenWidth <= 375) {
      // الحجم اللي انت شغال عليه (iPhone 11 Pro مثلاً)
      return screenWidth * 0.18;
    } else if (screenWidth <= 425) {
      // شاشات متوسطة (أغلب الهواتف الحديثة)
      return screenWidth * 0.18;
    } else if (screenWidth <= 600) {
      // فابلت أو أجهزة طويلة
      return screenWidth * 0.18;
    } else if (screenWidth <= 900) {
      // تابلت
      return screenWidth * 0.20;
    } else {
      // شاشات كبيرة جدًا (لابتوب أو landscape كبير)
      return screenWidth * 0.20;
    }
  }

  Widget Optiongeneral(String optionName, IconData icon, VoidCallback onTap) {
    final size = MediaQuery.of(context).size.width * 0.20;
    final screenWidth = MediaQuery.of(context).size.width;

    // الحجم المناسب حسب العرض والارتفاع
    final baseSize = getResponsiveSize(screenWidth);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ShimmerCard(
        size: baseSize,
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

  DraggableScrollableSheet _buildDraggableScrollableSheet(Widget nameWidget) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.4, 0.6, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [

                nameWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}