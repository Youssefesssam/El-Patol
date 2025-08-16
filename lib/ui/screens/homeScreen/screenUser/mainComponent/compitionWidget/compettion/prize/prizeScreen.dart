import 'package:flutter/material.dart';
import 'DailyCheckInScreen.dart';
import 'RewardStoreScreen.dart';
import 'myRewardsScreen.dart';


class PrizeScreen extends StatelessWidget {
  static const String routeName ='prizeScreen';
  const PrizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏠 الصفحة الرئيسية")),
      body: ListView(
        children: [

          ListTile(
            title: const Text("🛍️ متجر الجوائز"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardStoreScreen())),
          ),
          ListTile(
            title: const Text("🎖️ جوائزي"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRewardsScreen())),
          ),
        ],
      ),
    );
  }
}
