import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models_web/model_module.dart';
import '../add_video/moduleDetailsScreen.dart';

class SeenVideoUser extends StatefulWidget {
  static const String routeName = 'seenVideoUser';
  const SeenVideoUser({super.key});

  @override
  State<SeenVideoUser> createState() => _SeenVideoUserState();
}

class _SeenVideoUserState extends State<SeenVideoUser> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  /// ✅ هل المستخدم مشترك في الكورس؟
  Future<bool> userAlreadySubscribed(String moduleId) async {
    if (userId == null) return false;
    final doc = await FirebaseFirestore.instance
        .collection("subscriptions")
        .doc(userId)
        .collection("userCourses")
        .doc(moduleId)
        .get();
    return doc.exists;
  }

  /// ✅ اشترك في الكورس (إضافة في Firestore)
  Future<void> subscribeToCourse(Module module) async {
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection("subscriptions")
        .doc(userId)
        .collection("userCourses")
        .doc(module.id) // لازم module.id يبقى موجود
        .set({
      "moduleId": module.id,
      "title": module.title,
      "price": module.price,
      "stage": module.stage,
      "subscribedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          "📚 الكورسات المتاحة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("modules")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا يوجد كورسات بعد 📚",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final module = Module.fromMap(data, docs[index].id);

              return FutureBuilder<bool>(
                future: userAlreadySubscribed(module.id),
                builder: (context, subscriptionSnapshot) {
                  final isSubscribed = subscriptionSnapshot.data ?? false;

                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // صورة الكورس
                          Positioned.fill(
                            child: module.imageUrl != null &&
                                module.imageUrl!.isNotEmpty
                                ? Image.network(
                              module.imageUrl!,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              AppAssets.man,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),

                          // النصوص + الزرار
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "المرحلة: ${module.stage}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                Text(
                                  "💰 ${module.price}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                  ),
                                  onPressed: () async {
                                    if (isSubscribed ||
                                        module.price == "0") {
                                      // دخول للكورس
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ModuleDetailsScreen(
                                                  module: module),
                                        ),
                                      );
                                    } else {
                                      // اشتراك
                                      await subscribeToCourse(module);
                                      setState(() {}); // تحديث الزرار
                                    }
                                  },
                                  child: Text(
                                    (isSubscribed || module.price == "0")
                                        ? "دخول الكورس"
                                        : "اشترك الآن",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
