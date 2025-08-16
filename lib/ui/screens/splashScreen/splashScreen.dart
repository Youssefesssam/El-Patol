import 'package:el_patol/ui/screens/splashScreen/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/login_sub_leader.dart';
import '../../../screens/master_leader_screen.dart';
import '../auth/loginScreen/loginScreen.dart';
import '../homeScreen/screenUser/homeScreenUsers.dart';
import '../utilites/appAssets.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "Splash screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();

      String? masterCode = prefs.getString('master_code');
      String? subLeaderCode = prefs.getString('code');
      String? userCode = prefs.getString('user_code');

      print("🔹 master_code: $masterCode");
      print("🔹 code: $subLeaderCode");
      print("🔹 user_code: $userCode");

      if (masterCode != null) {
        Navigator.pushReplacementNamed(context, MasterLeaderScreen.routeName);
      } else if (subLeaderCode != null) {
        Navigator.pushReplacementNamed(context, LoginSubLeaderScreen.routeName);
      } else if (userCode != null) {
        Navigator.pushReplacementNamed(context, HomeScreenUsers.routeName);
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(AppAssets.splashScreen, fit: BoxFit.fill,),
            ),
          ],
        )
    );
  }
}