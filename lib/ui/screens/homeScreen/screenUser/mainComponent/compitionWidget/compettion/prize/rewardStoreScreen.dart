import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../utilites/appAssets.dart';


class Reward {
  final String name;
  final int cost;
  final String imagePath;

  Reward({required this.name, required this.cost, required this.imagePath});
}

class RewardStoreScreen extends StatefulWidget {
  const RewardStoreScreen({super.key});

  @override
  State<RewardStoreScreen> createState() => _RewardStoreScreenState();
}

class _RewardStoreScreenState extends State<RewardStoreScreen> {
  int userPoints = 0;
  List<String> ownedRewards = [];

  final List<Reward> rewards = [
    Reward(name: 'التوثيق', cost: 10, imagePath: AppAssets.success),
    Reward(name: 'بروفايل ذهبي', cost: 50, imagePath: AppAssets.star),
    Reward(name: 'خلفية Galaxy', cost: 90, imagePath: AppAssets.gold),
    Reward(name: 'لقب الأسطورة', cost: 100, imagePath: AppAssets.silver),
    Reward(name: 'تعليقات ملونة', cost: 150, imagePath: AppAssets.bronze),
    Reward(name: 'تأثير خاص', cost: 200, imagePath: AppAssets.processing),
    Reward(name: 'بطاقة هدية', cost: 210, imagePath: AppAssets.giftCard),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        userPoints = data['dailyPoints'] ?? 0;
        ownedRewards = List<String>.from(data['rewards'] ?? []);
      });
    }
  }

  Future<void> _buyReward(Reward reward) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    if (ownedRewards.contains(reward.name)) {
      _showMessage('🎁 لديك هذه الجائزة بالفعل');
    } else if (userPoints >= reward.cost) {
      final newPoints = userPoints - reward.cost;

      await userRef.update({
        'dailyPoints': newPoints,
        'rewards': FieldValue.arrayUnion([reward.name]),
      });

      setState(() {
        userPoints = newPoints;
        ownedRewards.add(reward.name);
      });

      _showMessage('✅ تم شراء "${reward.name}" بنجاح!');
    } else {
      _showMessage('❌ لا توجد نقاط كافية لشراء "${reward.name}"');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purpleAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎁 متجر الجوائز'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade600, Colors.purple.shade900],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.stars, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('نقاطك:', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Text(
                  '$userPoints 🪙',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                final alreadyOwned = ownedRewards.contains(reward.name);

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset(reward.imagePath, fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          reward.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "النقاط المطلوبة: ${reward.cost}",
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          onPressed: alreadyOwned ? null : () => _buyReward(reward),
                          icon: Icon(alreadyOwned ? Icons.check_circle : Icons.shopping_cart),
                          label: Text(alreadyOwned ? 'تم' : 'شراء'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: alreadyOwned ? Colors.grey : Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
