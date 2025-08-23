import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BuildInstructorsShowcase extends StatelessWidget {
  const BuildInstructorsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final instructors = [
      {'name': 'أ. أحمد محمد', 'subject': 'رياضيات', 'rating': '4.9', 'color': Color(0xFF4ECDC4), 'image': AppAssets.man},
      {'name': 'أ. فاطمة علي', 'subject': 'علوم', 'rating': '4.8', 'color': Color(0xFF667eea), 'image': AppAssets.docwomen},
      {'name': 'أ. محمد حسن', 'subject': 'عربي', 'rating': '4.9', 'color': Color(0xFFf093fb), 'image': AppAssets.officer},
      {'name': 'أ. نور أحمد', 'subject': 'إنجليزي', 'rating': '4.7', 'color': Color(0xFFffecd2), 'image': AppAssets.girl1},
      {'name': 'أ. سارة محمود', 'subject': 'دراسات', 'rating': '4.8', 'color': Color(0xFFa8edea), 'image': AppAssets.girl2},
      {'name': 'أ. علي حسام', 'subject': 'حاسب', 'rating': '4.9', 'color': Color(0xFFc3cfe2), 'image': AppAssets.eng},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFE6E6FA)],
            ).createShader(bounds),
            child: const Text(
              'نخبة المدرسين',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: instructors.length,
              itemBuilder: (context, index) {
                final item = instructors[index];
                return Container(
                  width: 170,
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (item['color'] as Color).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.asset(
                            item['image'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item['color'] as Color,
                                      (item['color'] as Color).withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person, size: 60, color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Glass Effect
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Subject Badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              item['subject'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        // Bottom Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFFFD700),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['rating'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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