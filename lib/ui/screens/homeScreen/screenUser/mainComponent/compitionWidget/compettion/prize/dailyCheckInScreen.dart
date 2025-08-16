import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'RewardStoreScreen.dart';

class DailyCheckInDialog extends StatefulWidget {
  static const String routeName ='dailyCheckInDialog';
  const DailyCheckInDialog({super.key});

  @override
  State<DailyCheckInDialog> createState() => _DailyCheckInDialogState();
}

class _DailyCheckInDialogState extends State<DailyCheckInDialog> {
  Future<void> handleCheckIn(DocumentSnapshot userDoc) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastLogin = (userDoc['lastLoginDate'] as Timestamp).toDate();
    final lastLoginDay = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);

    if (lastLoginDay == today) {
      return;
    }

    final daysDifference = today.difference(lastLoginDay).inDays;
    int newStreak = 1;
    if (daysDifference == 1) {
      newStreak = (userDoc['dailyStreak'] ?? 0) + 1;
    }

    await userDocRef.update({
      'dailyPoints': (userDoc['dailyPoints'] ?? 0) + 10,
      'dailyStreak': newStreak,
      'lastLoginDate': now,
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: userDocRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final doc = snapshot.data!;
            if (!doc.exists) {
              userDocRef.set({
                'dailyPoints': 10,
                'dailyStreak': 1,
                'lastLoginDate': DateTime.now(),
                'rewards': [],
              });
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final data = doc.data() as Map<String, dynamic>;
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final lastLogin = (data['lastLoginDate'] as Timestamp?)?.toDate();
            final lastLoginDay = lastLogin != null ? DateTime(lastLogin.year, lastLogin.month, lastLogin.day) : null;

            final checkedInToday = lastLoginDay == today;
            final dailyPoints = data['dailyPoints'] ?? 0;
            final dailyStreak = data['dailyStreak'] ?? 0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("📆 حضورك اليومي", style: Theme.of(context).textTheme.titleLarge)),
                const SizedBox(height: 20),
                Text("🔥 سلسلة الحضور: $dailyStreak يوم", style: const TextStyle(fontSize: 16)),
                Text("🎯 نقاطك اليومية: $dailyPoints نقطة", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: checkedInToday ? null : () => handleCheckIn(doc),
                  icon: const Icon(Icons.check),
                  label: const Text("سجل حضوري اليوم"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardStoreScreen()),
                    );
                  },
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text("فتح متجر الجوائز"),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إغلاق"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
