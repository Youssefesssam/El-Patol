import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRewardsScreen extends StatelessWidget {
  const MyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("🎖️ جوائزي")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, userSnap) {
          if (!userSnap.hasData) return const Center(child: CircularProgressIndicator());

          final userRewards = List<String>.from(userSnap.data!['rewards'] ?? []);

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('daily_rewards_store').snapshots(),
            builder: (context, storeSnap) {
              if (!storeSnap.hasData) return const SizedBox();

              final allRewards = storeSnap.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .where((reward) => userRewards.contains(reward['id']))
                  .toList();

              if (allRewards.isEmpty) {
                return const Center(child: Text("لا توجد جوائز حتى الآن 😔"));
              }

              return ListView.builder(
                itemCount: allRewards.length,
                itemBuilder: (context, index) {
                  final reward = allRewards[index];
                  return ListTile(
                    title: Text(reward['title']),
                    subtitle: const Text("✅ تم الشراء"),
                    leading: const Icon(Icons.card_giftcard),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
