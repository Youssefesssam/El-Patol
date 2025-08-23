import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:el_patol/ui_web/add_video/chooseStage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models_web/model_module.dart';
import 'createModuleScreen.dart';
import 'moduleDetailsScreen.dart';

class ModulesListScreen extends StatelessWidget {
  static const String routeName = 'modulesListScreen';
  final String stage; // 👈 هنستقبله من الشاشة الأولى

  const ModulesListScreen({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, ChooseStageScreen.routeName);
            },
              child: Icon(Icons.arrow_back_ios_new)),
        const Text(
            "📚 قائمة الموديولات",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

        ],

      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateModuleScreen(stage: stage), // 👈 هنا بنبعت المرحلة
          ));
        },
        icon: const Icon(Icons.add, size: 26),
        label: const Text(
          "موديول جديد",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("center")
            .doc('101')
            .collection('Mr')
            .doc('Mr1017595')
            .collection("modules")
            .doc(stage) // نخزن الموديول جوه المرحلة
            .collection('module')
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا يوجد موديولات بعد 📚",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // عمودين جنب بعض
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2, // نسبة العرض للارتفاع
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final module = Module.fromMap(data, docs[index].id);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModuleDetailsScreen(module: module),
                    ),
                  );
                },
                child: Hero(
                  tag: module.title,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // صورة الموديول
                          Positioned.fill(
                            child: module.imageUrl != null && module.imageUrl!.isNotEmpty
                                ? Image.network(
                              module.imageUrl!,
                              fit: BoxFit.contain,
                            )
                                : Image.asset(
                              AppAssets.man, // صورة افتراضية
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Overlay أسود شفاف فوق الصورة
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

                          // النصوص فوق الصورة
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
                                    fontSize: 18,
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
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                Text(
                                  "💰 ${module.price}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
