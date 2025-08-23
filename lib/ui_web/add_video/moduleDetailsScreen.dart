import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // عشان التاريخ
import '../../models_web/model_module.dart';

class ModuleDetailsScreen extends StatefulWidget {
  final Module module;
  const ModuleDetailsScreen({super.key, required this.module});

  @override
  State<ModuleDetailsScreen> createState() => _ModuleDetailsScreenState();
}

class _ModuleDetailsScreenState extends State<ModuleDetailsScreen> {
  Future<void> _addDummyVideo() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection("center")
          .doc('101')
          .collection('Mr')
          .doc('Mr1017595')
          .collection("videos")
          .doc(widget.module.stage) // 👈 المرحلة
          .collection("video")
          .doc();

      final newVideo = {
        "id": docRef.id,
        "title": "فيديو تجريبي - ${widget.module.title}",
        "teacherId": "teacher_123",
        "teacherImage":
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
        "stage": widget.module.stage,
        "moduleId": widget.module.id,
        "url": "https://example.com/dummy-video.mp4",
        "createdAt": Timestamp.fromDate(DateTime.now()),
      };

      await docRef.set(newVideo);

      // اربط الفيديو مع الموديول
      await FirebaseFirestore.instance
          .collection("center")
          .doc('101')
          .collection('Mr')
          .doc('Mr1017595')
          .collection("modules")
          .doc(widget.module.stage) // 👈 المرحلة
          .collection("module")
          .doc(widget.module.id)
          .update({
        "videos": FieldValue.arrayUnion([docRef.id])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إضافة الفيديو بنجاح ✅")),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ أثناء رفع الفيديو: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoIds = widget.module.videos;

    return Scaffold(
      appBar: AppBar(
        title: Text("📚 ${widget.module.title}"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDummyVideo,
        icon: const Icon(Icons.upload_file),
        label: const Text("إضافة فيديو"),
        backgroundColor: Colors.deepPurple,
      ),
      body: videoIds.isEmpty
          ? const Center(
        child: Text(
          "لا يوجد فيديوهات بعد 🎥",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("center")
            .doc('101')
            .collection('Mr')
            .doc('Mr1017595')
            .collection("videos")
            .doc(widget.module.stage) // 👈 المرحلة
            .collection("video")
            .where(FieldPath.documentId, whereIn: videoIds.isEmpty ? ["dummy"] : videoIds)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا يوجد فيديوهات 🎥"));
          }

          final docs = snapshot.data!.docs;

          docs.sort((a, b) {
            final at = (a['createdAt'] as Timestamp).toDate();
            final bt = (b['createdAt'] as Timestamp).toDate();
            return bt.compareTo(at);
          });

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 كروت جنب بعض
              childAspectRatio: 0.8, // الكارد أطول عشان الصورة
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final createdAt =
              (data['createdAt'] as Timestamp).toDate();

              // فورمات التاريخ
              final formattedDate =
              DateFormat("d MMMM yyyy", "ar").format(createdAt);

              return InkWell(
                onTap: () {
                  // هنا تفتح الفيديو
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // صورة المستر (خلفية الكارد)
                        Positioned.fill(
                          child: Image.network(
                            AppAssets.man,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // طبقة شفافة
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        // المحتوى (الأيقونة + العنوان في النص)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_circle_outline_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // التاريخ في الأسفل
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              formattedDate,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
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
