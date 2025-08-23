import 'dart:math';
import 'dart:ui';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '_buildCompactStatsSection.dart';
import '_buildCoursesPreview.dart';
import '_buildEliteFeaturesSection.dart';
import '_buildInstructorsShowcase.dart';
import '_buildLuxuryFooter.dart';
import '_buildLuxuryHeroSection.dart';
import '_buildPremiumAppBar.dart';
import '_buildPremiumSubjectsGrid.dart';

class HomeWeb extends StatefulWidget {
  static const String routeName = "homeWeb";

  @override
  _HomeWebState createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  late AnimationController _colorButtonController;

  late Animation<double> _particleAnimation;
  late Animation<double> _colorButtonAnimation;

  // اختر التدرج اللي عجبك (غير الرقم من 1 لـ 6)
  int selectedColorScheme = 1;
  int _hoveredColorIndex = -1;
  bool _isColorPickerVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(seconds: 25),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    _colorButtonController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _colorButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorButtonController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _rotationController.repeat();
    _floatingController.repeat(reverse: true);
    _particleController.repeat();
    _colorButtonController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    _colorButtonController.dispose();
    super.dispose();
  }

  // دالة لاختيار ألوان الخلفية
  List<Color> _getBackgroundColors() {
    switch (selectedColorScheme) {
      case 1: // Ocean Deep (أزرق محيطي)
        return [
          Color(0xFF0C1B33), // Deep Navy
          Color(0xFF1B2951), // Ocean Blue
          Color(0xFF2E3A59), // Steel Blue
          Color(0xFF405B73), // Slate Blue
        ];
      case 2: // Sunset Vibes (غروب الشمس)
        return [
          Color(0xFF2D1B2E), // Deep Purple
          Color(0xFF42275A), // Royal Purple
          Color(0xFF734B6D), // Mauve
          Color(0xFFFF6B35), // Sunset Orange
        ];
      case 3: // Forest Night (ليل الغابة)
        return [
          Color(0xFF0F2027), // Dark Green
          Color(0xFF203A43), // Forest Green
          Color(0xFF2C5364), // Teal
          Color(0xFF0B4D2C), // Emerald
        ];
      case 4: // Royal Gold (ذهبي ملكي)
        return [
          Color(0xFF1A1A2E), // Dark Purple
          Color(0xFF16213E), // Navy
          Color(0xFF533E2D), // Bronze
          Color(0xFFF7941D), // Gold
        ];
      case 5: // Cosmic Purple (بنفسجي فضائي)
        return [
          Color(0xFF0F0C29), // Space Purple
          Color(0xFF24243e), // Deep Purple
          Color(0xFF302B63), // Galaxy Purple
          Color(0xFF6A5ACD), // Slate Blue
        ];
      case 6: // Emerald Dream (أخضر زمردي)
        return [
          Color(0xFF134E5E), // Teal
          Color(0xFF71B280), // Green
          Color(0xFF42A5B3), // Turquoise
          Color(0xFF2E8B57), // Sea Green
        ];
      default:
        return [
          Color(0xFF0B0A1A),
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
          Color(0xFF0F3460),
        ];
    }
  }

  // دالة لاختيار ألوان الجسيمات
  List<Color> _getParticleColors() {
    switch (selectedColorScheme) {
      case 1: // Ocean Deep
        return [
          Color(0xFF4FC3F7), // Light Blue
          Color(0xFF29B6F6), // Sky Blue
          Color(0xFF03DAC6), // Cyan
        ];
      case 2: // Sunset Vibes
        return [
          Color(0xFFFF9800), // Orange
          Color(0xFFFF5722), // Deep Orange
          Color(0xFFE91E63), // Pink
        ];
      case 3: // Forest Night
        return [
          Color(0xFF4CAF50), // Green
          Color(0xFF8BC34A), // Light Green
          Color(0xFF00E676), // Bright Green
        ];
      case 4: // Royal Gold
        return [
          Color(0xFFFFD700), // Gold
          Color(0xFFFFA500), // Orange
          Color(0xFFFF8C00), // Dark Orange
        ];
      case 5: // Cosmic Purple
        return [
          Color(0xFF9C27B0), // Purple
          Color(0xFF673AB7), // Deep Purple
          Color(0xFF3F51B5), // Indigo
        ];
      case 6: // Emerald Dream
        return [
          Color(0xFF00BCD4), // Cyan
          Color(0xFF4CAF50), // Green
          Color(0xFF8BC34A), // Light Green
        ];
      default:
        return [
          Color(0xFF6A5ACD),
          Color(0xFF4B0082),
          Color(0xFF8A2BE2),
        ];
    }
  }

  List<Color> _getColorPreview(int scheme) {
    switch (scheme) {
      case 1: return [Color(0xFF0C1B33), Color(0xFF405B73)];
      case 2: return [Color(0xFF2D1B2E), Color(0xFFFF6B35)];
      case 3: return [Color(0xFF0F2027), Color(0xFF0B4D2C)];
      case 4: return [Color(0xFF1A1A2E), Color(0xFFF7941D)];
      case 5: return [Color(0xFF0F0C29), Color(0xFF6A5ACD)];
      case 6: return [Color(0xFF134E5E), Color(0xFF2E8B57)];
      default: return [Color(0xFF0B0A1A), Color(0xFF0F3460)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        onKey: (node, event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              setState(() {
                selectedColorScheme = selectedColorScheme > 1 ? selectedColorScheme - 1 : 6;
              });
              _colorButtonController.reset();
              _colorButtonController.forward();
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              setState(() {
                selectedColorScheme = selectedColorScheme < 6 ? selectedColorScheme + 1 : 1;
              });
              _colorButtonController.reset();
              _colorButtonController.forward();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getBackgroundColors(),
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              _buildAnimatedBackground(),
              const SingleChildScrollView(
                child: Column(
                  children: [
                    BuildPremiumAppBar(),
                    BuildLuxuryHeroSection(),
                    SizedBox(height: 60),
                    BuildCompactStatsSection(),
                    SizedBox(height: 80),
                    BuildPremiumSubjectsGrid(),
                    SizedBox(height: 80),
                    BuildEliteFeaturesSection(),
                    SizedBox(height: 80),
                    BuildInstructorsShowcase(),
                    SizedBox(height: 80),
                    BuildCoursesPreview(),
                    SizedBox(height: 60),
                    BuildLuxuryFooter(),
                  ],
                ),
              ),
              _buildMinimalColorPicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalColorPicker() {
    return Positioned(
      top: 100,
      right: 20,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isColorPickerVisible = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isColorPickerVisible = false;
            _hoveredColorIndex = -1;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(_isColorPickerVisible ? 12 : 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(_isColorPickerVisible ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(_isColorPickerVisible ? 20 : 25),
            border: Border.all(
              color: Colors.white.withOpacity(_isColorPickerVisible ? 0.2 : 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isColorPickerVisible ? 0.3 : 0.1),
                blurRadius: _isColorPickerVisible ? 20 : 10,
                offset: Offset(0, _isColorPickerVisible ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // مؤشر اللون الحالي
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getColorPreview(selectedColorScheme),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getColorPreview(selectedColorScheme)[1].withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.palette_outlined,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                ),
              ),

              // الأزرار المخفية
              if (_isColorPickerVisible) ...[
                SizedBox(height: 12),
                Container(
                  width: 2,
                  height: 15,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getParticleColors().take(2).toList(),
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                SizedBox(height: 12),

                // أزرار الألوان الصغيرة
                ...List.generate(6, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hoveredColorIndex = index),
                      onExit: (_) => setState(() => _hoveredColorIndex = -1),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorScheme = index + 1;
                          });
                          _colorButtonController.reset();
                          _colorButtonController.forward();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: _hoveredColorIndex == index ? 30 : 25,
                          height: _hoveredColorIndex == index ? 30 : 25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _getColorPreview(index + 1),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColorScheme == index + 1
                                  ? Colors.white.withOpacity(0.8)
                                  : _hoveredColorIndex == index
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.2),
                              width: selectedColorScheme == index + 1 ? 2.5 : 1.5,
                            ),
                            boxShadow: [
                              if (selectedColorScheme == index + 1 || _hoveredColorIndex == index)
                                BoxShadow(
                                  color: _getColorPreview(index + 1)[1].withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                            ],
                          ),
                          child: selectedColorScheme == index + 1
                              ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 12),

                // زر إعادة التعيين صغير
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorScheme = 1;
                    });
                    _colorButtonController.reset();
                    _colorButtonController.forward();
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white.withOpacity(0.7),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final particleColors = _getParticleColors();
        return Container(
          child: Stack(
            children: [
              // Animated mesh gradient
              Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    startAngle: _particleAnimation.value * 2 * pi,
                    endAngle: (_particleAnimation.value + 1) * 2 * pi,
                    colors: [
                      Colors.transparent,
                      particleColors[0].withOpacity(0.05),
                      particleColors[1].withOpacity(0.08),
                      particleColors[2].withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Floating orbs
              ...List.generate(15, (index) {
                final random = Random(index);
                final x = random.nextDouble() * MediaQuery.of(context).size.width;
                final y = random.nextDouble() * MediaQuery.of(context).size.height;
                final size = random.nextDouble() * 200 + 50;
                final opacity = random.nextDouble() * 0.05 + 0.02;
                final colorIndex = index % particleColors.length;

                return Positioned(
                  left: x + (sin(_particleAnimation.value * 2 * pi + index) * 30),
                  top: y + (cos(_particleAnimation.value * 2 * pi + index) * 20),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          particleColors[colorIndex].withOpacity(opacity),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
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