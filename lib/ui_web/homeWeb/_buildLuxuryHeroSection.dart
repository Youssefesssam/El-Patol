import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';

import '../../ui/screens/auth/loginScreen/loginScreen.dart';

class BuildLuxuryHeroSection extends StatefulWidget {
  const BuildLuxuryHeroSection({super.key});

  @override
  State<BuildLuxuryHeroSection> createState() => _BuildLuxuryHeroSectionState();
}

class _BuildLuxuryHeroSectionState extends State<BuildLuxuryHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late AnimationController _floatingController;
  late AnimationController _particleController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2500));

    _rotationController =
        AnimationController(vsync: this, duration: Duration(seconds: 25));

    _floatingController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    _particleController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _floatingAnimation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<double>(begin: 120.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _rotationController.repeat();
    _floatingController.repeat(reverse: true);
    _particleController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              height: MediaQuery.of(context).size.height * 0.85,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: _buildTextContent(),
                        ),
                      ),
                      SizedBox(width: 40),
                      if (constraints.maxWidth > 900) // عرض الصورة بس في الشاشات الكبيرة
                        Expanded(
                          flex: 5,
                          child: _buildPremiumHeroVisual(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xFF6A5ACD).withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 20),
              SizedBox(width: 10),
              Text(
                'مرحباً بك في عالم التميز الأكاديمي',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFF6B35)],
          ).createShader(bounds),
          child: Text(
            'التعليم الراقي\nللمرحلة الإعدادية',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
              letterSpacing: 2.5,
            ),
          ),
        ),
        SizedBox(height: 25),
        Text(
          'انضم إلى النخبة من الطلاب المتفوقين واكتشف إمكانياتك الحقيقية\nمع أفضل المدرسين وأحدث الطرق التعليمية التفاعلية',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(0.9),
            height: 1.6,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 40),
        Row(
          children: [
            _buildLuxuryButton(
              'ابدأ رحلة التفوق',
              [Color(0xFF6A5ACD), Color(0xFF8A2BE2)],
                  () {
                    Navigator.pushNamed(context, LoginScreen.routeName);

                  },
              Icons.rocket_launch_outlined,
            ),
            SizedBox(width: 15),
            _buildLuxuryButton(
              'شاهد العروض',
              [Colors.transparent, Colors.transparent],
                  () {},
              Icons.play_circle_outline,
              isOutlined: true,
            ),
          ],
        ),
        SizedBox(height: 40),
        _buildPremiumTrustBadges(),
      ],
    );
  }

  Widget _buildLuxuryButton(
      String text, List<Color> colors, VoidCallback onPressed, IconData icon,
      {bool isOutlined = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isOutlined ? null : LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(35),
        border: isOutlined ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: isOutlined
            ? []
            : [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 2,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumTrustBadges() {
    return Row(
      children: [
        _buildTrustBadge('3500+', 'طالب نخبة', Color(0xFF4ECDC4)),
        SizedBox(width: 25),
        _buildTrustBadge('120+', 'مدرس متميز', Color(0xFFFF6B35)),
        SizedBox(width: 25),
        _buildTrustBadge('98%', 'معدل التفوق', Color(0xFFFFD700)),
      ],
    );
  }

  Widget _buildTrustBadge(String number, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [color, color.withOpacity(0.8)],
          ).createShader(bounds),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumHeroVisual() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.3),
          child: Container(
            height: 450,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                        offset: Offset(0, 25),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Image.asset(
                          AppAssets.main1,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildCompactOrbitingSubjects(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactOrbitingSubjects() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Container(
          height: 450,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6A5ACD),
                      Color(0xFF8A2BE2),
                      Color(0xFF9370DB),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(AppAssets.logo2, fit: BoxFit.cover,color: Colors.white,),
                ),
              ),
              ...List.generate(6, (index) {
                final angle =
                    (index * 60 + _rotationAnimation.value * 360) * (pi / 180);
                final radius = 130.0;
                final x = radius * cos(angle);
                final y = radius * sin(angle);

                return Transform.translate(
                  offset: Offset(x, y),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
