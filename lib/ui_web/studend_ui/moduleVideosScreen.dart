import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:intl/intl.dart';

import '../../ui/screens/utilites/appAssets.dart';

class ModuleVideosScreen extends StatelessWidget {
  final String moduleId;
  final String moduleTitle;
  final String teacherId;

  const ModuleVideosScreen({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "🎥 $moduleTitle",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('center')
            .doc('101')
            .collection('Mr')
            .doc(teacherId)
            .collection('videos')
            .doc("P_1") // 👈 المرحلة (عدّل حسب هيكلة DB عندك)
            .collection('video')
            .where('moduleId', isEqualTo: moduleId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد فيديوهات بعد 🎥',
                style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // ترتيب حسب التاريخ
          docs.sort((a, b) {
            final at = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            final bt = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            return bt.compareTo(at);
          });

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? 'فيديو بدون عنوان';
              final url = data['url'] ?? '';
              final createdAt =
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

              final formattedDate =
              DateFormat("d MMMM yyyy", "ar").format(createdAt);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(url: url, title: title),
                    ),
                  );
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
                        // صورة افتراضية (ممكن لاحقاً تحط thumbnail)
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

                        // أيقونة + العنوان
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
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
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

                        // التاريخ
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

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayerScreen({super.key, required this.url, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.cairo()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _videoController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
