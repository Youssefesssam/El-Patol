import 'dart:ui';
import 'package:el_patol/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';

class BuildPremiumAppBar extends StatelessWidget {
  const BuildPremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: _getHorizontalMargin(constraints.maxWidth),
              vertical: 15,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(constraints.maxWidth),
              vertical: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: _buildAppBarContent(constraints.maxWidth,context),
              ),
            ),
          );
        },
      ),
    );
  }

  // تحديد المحتوى حسب حجم الشاشة
  Widget _buildAppBarContent(double screenWidth,BuildContext context) {
    if (screenWidth < 600) {
      // شاشات صغيرة (موبايل)
      return _buildMobileLayout(context);
    } else if (screenWidth < 900) {
      // شاشات متوسطة (تابلت)
      return _buildTabletLayout(context);
    } else {
      // شاشات كبيرة (ديسكتوب)
      return _buildDesktopLayout(context);
    }
  }

  // تخطيط الموبايل
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(24, 12),
            _buildActionButton(12, 8, 14,context),
          ],
        ),
        SizedBox(height: 15),
        _buildTitle(20, 1.0),
      ],
    );
  }

  // تخطيط التابلت
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _buildLogo(28, 14),
              SizedBox(width: 15),
              Flexible(child: _buildTitle(24, 1.2)),
            ],
          ),
        ),
        SizedBox(width: 20),
        _buildActionButton(20, 12, 15,context),
      ],
    );
  }

  // تخطيط الديسكتوب
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildLogo(32, 12),
            SizedBox(width: 20),
            _buildTitle(28, 1.5),
          ],
        ),
        _buildActionButton(30, 15, 16,context),
      ],
    );
  }

  // Logo مع أحجام متجاوبة
  Widget _buildLogo(double iconSize, double padding) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A5ACD),
            Color(0xFF8A2BE2),
            Color(0xFF9370DB),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A5ACD).withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          AppAssets.logo2,
          height: iconSize,
          fit: BoxFit.cover,
          color: Colors.white,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.diamond, color: Colors.white, size: iconSize);
          },
        ),
      ),
    );
  }

  // العنوان مع أحجام متجاوبة
  Widget _buildTitle(double fontSize, double letterSpacing) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Color(0xFFE6E6FA),
        ],
      ).createShader(bounds),
      child: Text(
        'خليك ديما متفوق',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: letterSpacing,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  // زر الإجراء مع أحجام متجاوبة
  Widget _buildActionButton(double horizontalPadding, double verticalPadding, double fontSize,BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, LoginScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFF7931E),
              Color(0xFFFFD700),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF6B35).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'ابدأ الآن',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  // حساب الهامش الأفقي
  double _getHorizontalMargin(double screenWidth) {
    if (screenWidth < 600) return 15; // موبايل
    if (screenWidth < 900) return 20; // تابلت
    return 25; // ديسكتوب
  }

  // حساب المسافة الداخلية الأفقية
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 600) return 20; // موبايل
    if (screenWidth < 900) return 25; // تابلت
    return 30; // ديسكتوب
  }
}