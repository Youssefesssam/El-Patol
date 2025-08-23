import 'dart:ui';
import 'package:flutter/material.dart';

class BuildCompactStatsSection extends StatelessWidget {
  const BuildCompactStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 5,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ).createShader(bounds),
                child: Text(
                  'إنجازاتنا المتميزة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // استخدم LayoutBuilder لمعرفة عرض الشاشة
              LayoutBuilder(
                builder: (context, constraints) {
                  // لو العرض أقل من 800 بكسل اعمل scroll
                  if (constraints.maxWidth < 800) {
                    return _buildScrollableStats();
                  } else {
                    return _buildRowStats();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // عرض الإحصائيات في صف واحد (للشاشات الكبيرة)
  Widget _buildRowStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCompactStatItem('3500+', 'طالب متفوق', Icons.school, Color(0xFF4ECDC4)),
        _buildCompactStatItem('120+', 'مدرس خبير', Icons.person, Color(0xFFFF6B35)),
        _buildCompactStatItem('800+', 'درس تفاعلي', Icons.play_circle, Color(0xFF6A5ACD)),
        _buildCompactStatItem('98%', 'نسبة النجاح', Icons.star, Color(0xFFFFD700)),
      ],
    );
  }

  // عرض الإحصائيات مع scroll (للشاشات الصغيرة)
  Widget _buildScrollableStats() {
    return SizedBox(
      height: 180, // ارتفاع ثابت للـ scroll
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _buildCompactStatItem('3500+', 'طالب متفوق', Icons.school, Color(0xFF4ECDC4)),
            SizedBox(width: 20),
            _buildCompactStatItem('120+', 'مدرس خبير', Icons.person, Color(0xFFFF6B35)),
            SizedBox(width: 20),
            _buildCompactStatItem('800+', 'درس تفاعلي', Icons.play_circle, Color(0xFF6A5ACD)),
            SizedBox(width: 20),
            _buildCompactStatItem('98%', 'نسبة النجاح', Icons.star, Color(0xFFFFD700)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(String number, String label, IconData icon, Color color) {
    return Container(
      width: 140,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 15),
          Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}