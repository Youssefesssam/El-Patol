import 'package:flutter/material.dart';

import 'add_sub_leader_screen.dart';
import 'authLeader/masterGroupScreen.dart';

class MasterLeaderScreen extends StatefulWidget {
  static const String routeName = 'master';

  const MasterLeaderScreen({super.key});

  @override
  State<MasterLeaderScreen> createState() => _MasterLeaderScreenState();
}

class _MasterLeaderScreenState extends State<MasterLeaderScreen> {

  final Map<String, List<String>> groupedStages = const {
    "إعدادي": ["P_1", "P_2", "P_3"],
    "ثانوي": ["S_1", "S_2", "S_3"],
    "جامعة": ["U_1", "U_2", "U_3"],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabKeys = groupedStages.keys.toList();

    return DefaultTabController(
      length: tabKeys.length,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade900,
          title: const Text("📊 إحصائيات الحضور الشهرية"),
          centerTitle: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          bottom: TabBar(
            labelColor:Colors.black,
            tabs: tabKeys.map((key) => Tab(text: key)).toList(),
            indicatorColor: Colors.yellow.shade700,
          ),
        ),
        body: TabBarView(
          children: tabKeys.map((groupName) {
            final stages = groupedStages[groupName]!;
            return MasterGroupScreen(
              groupName: groupName,
              stages: stages,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddSubLeaderScreen.routeName);
          },
          backgroundColor: Colors.blue.shade900.withOpacity(.8),
          child: const Icon(Icons.person_add, color: Colors.white),
          tooltip: 'إضافة ليدر جديد',
        ),
      ),


    );
  }
}
