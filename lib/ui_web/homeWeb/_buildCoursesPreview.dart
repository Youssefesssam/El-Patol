import 'dart:ui';

import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';

class BuildCoursesPreview extends StatelessWidget {
  const BuildCoursesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ).createShader(bounds),
            child: Text(
              'البرامج التعليمية المتقدمة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: 40),
          Column(
            children: [
              _buildCompactCourseCard(
                'برنامج الصف الأول الإعدادي',
                'مراجعة شاملة وتأسيس قوي في جميع المواد',
                '120 درس',
                '4.8',
                '1200+',
                [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                AppAssets.boy,
              ),
              SizedBox(height: 20),
              _buildCompactCourseCard(
                'برنامج الصف الثاني الإعدادي',
                'تطوير المهارات والفهم العميق للمناهج',
                '140 درس',
                '4.9',
                '980+',
                [Color(0xFF667eea), Color(0xFF764ba2)],
                AppAssets.girl3,
              ),
              SizedBox(height: 20),
              _buildCompactCourseCard(
                'برنامج الشهادة الإعدادية',
                'إعداد متكامل لامتحان الشهادة الإعدادية',
                '180 درس',
                '4.7',
                '1500+',
                [Color(0xFFf093fb), Color(0xFFf5576c)],
                AppAssets.crazy,
              ),
            ],
          ),
        ],
      ),
    );

  }
  Widget _buildCompactCourseCard(String title, String description, String lessons, String rating, String students, List<Color> colors, String imagePath) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.play_circle_fill, color: Colors.white, size: 40);
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        _buildCourseInfo(Icons.play_circle_outline, lessons, colors.first),
                        SizedBox(width: 15),
                        _buildCourseInfo(Icons.people_outline, students, Color(0xFFFF6B35)),
                        SizedBox(width: 15),
                        _buildCourseInfo(Icons.star, rating, Color(0xFFFFD700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCourseInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }


}
