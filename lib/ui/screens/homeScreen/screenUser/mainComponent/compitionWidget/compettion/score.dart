import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_alert/status_alert.dart';

import '../../../../../../../firebase/authProvider.dart';
import '../../../../../../../model/modelUser.dart';
import '../../../../../utilites/appColors.dart';
import 'natification/natification.dart';


class Score extends StatefulWidget {
  final Color colorNatification;
  final bool appearNatification;
  final int numNatification;
  final String selectedMonth;

  const Score({
    super.key,
    required this.numNatification,
    required this.colorNatification,
    required this.appearNatification,
    required this.selectedMonth,
  });

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  String _title = "";
  int? _cachedScore;
  bool _isLoading = false;
  bool _showShimmer = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedScore = prefs.getInt("totalScore");
    if (_cachedScore != null) {
      _updateTitle(_cachedScore!);
    }
  }

  Future<void> _showScoreAlert(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _showShimmer = true;
    });

    try {
      AuthProviders authProviders = Provider.of<AuthProviders>(context, listen: false);
      StatusAlert.show(
        backgroundColor:  Colors.blue.shade900.withOpacity(.8),
        borderRadius: BorderRadius.circular(15),
        context,
        duration: const Duration(seconds: 5),
        configuration: WidgetConfiguration(
          widget:
          Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("governorate")
              .doc(authProviders.governorateUs)
              .collection('church')
              .doc(authProviders.churchCodeUs)
              .collection('users_church')
              .doc(authProviders.stageCodeUs)
              .collection('users')
              .doc(authProviders.codeUs)
              .collection(MyUser.collection)
              .doc(authProviders.userId!)
              .collection("summary")
              .doc("score")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Text('0',
                style:  TextStyle(
                  fontSize: MediaQuery.of(context).size.height*.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),);
            } else {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final totalScore = data['totalScore'] ?? 0;
              print("Totalllll => $totalScore");
              return Center(
                child: Text(
                  '$totalScore',
                  style:  TextStyle(
                    fontSize: MediaQuery.of(context).size.height*.08,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
          ),
              const SizedBox(height: 10),
              const Text(
                "Score",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error showing score: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load score")),
      );
    } finally {
      // تأخير إيقاف الشيمر لمدة 4 ثوانٍ بعد انتهاء العملية
      await Future.delayed(const Duration(seconds:5 ));
      setState(() {
        _isLoading = false;
        _showShimmer = false;
      });
    }
  }


  void _updateTitle(int score) {
    if (score <= 800 && score > 700) {
      _title = "Excellent! Keep it up";
    } else if (score <= 700 && score > 600) {
      _title = "Great job! Keep going";
    } else if (score <= 600 && score > 400) {
      _title = "You can do better!";
    } else if (score <= 400 && score > 200) {
      _title = "Try harder!";
    } else if (score <= 200 && score > 50) {
      _title = "Don't give up!";
    } else if (score == 0) {
      _title = "You can do it!";
    } else {
      _title = "You're the best!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.32;

    return InkWell(
      onTap: _isLoading ? null : () => _showScoreAlert(context),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: AppColors.smoothColorTeal,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (_showShimmer)
                  Shimmer.fromColors(
                    baseColor: Colors.black.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                  ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_score,
                        size: size * 0.4,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Score",
                        style: GoogleFonts.aclonica(
                          fontSize: size * 0.13,
                          color: _showShimmer
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          InkWell(
            onTap: () async {
            },
            child: Notifications(
              color: Colors.green,
              num: 0,
              appear: false,
              appearIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}