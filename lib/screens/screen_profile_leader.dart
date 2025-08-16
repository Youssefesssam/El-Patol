import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/leader_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName ="ProfileScreen";

  @override
  Widget build(BuildContext context) {
    final leaderProvider = Provider.of<LeaderProvider>(context);
    final leader = leaderProvider.currentLeader;

    if (leader == null) {
      return Center(child: Text('لا توجد بيانات'));
    }

    return Scaffold(
      appBar: AppBar(title: Text('بيانات الليدر')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الكود: ${leader.code}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('الاسم: ${leader.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('المحافظة: ${leader.governorateName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('الكنيسة: ${leader.church}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('المرحلة: ${leader.stage}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('الصفة: ${leader.specialty}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}