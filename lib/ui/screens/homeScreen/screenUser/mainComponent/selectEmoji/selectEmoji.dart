import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SelectEmoji extends StatefulWidget {
  const SelectEmoji({Key? key}) : super(key: key);

  @override
  State<SelectEmoji> createState() => _SelectEmojiState();
}

class _SelectEmojiState extends State<SelectEmoji> with SingleTickerProviderStateMixin {
  String? savedEmojiName;
  String? savedEmojiVerse;
  String? savedEmojiPath;
  bool isLoading = true;

  double x = 0;
  double y = 0;
  late StreamSubscription _gyroscopeSubscription;

  late AnimationController _controller;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedEmojiData();
    _listenToGyroscope();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _listenToGyroscope() {
    _gyroscopeSubscription = accelerometerEvents.listen((event) {
      setState(() {
        x = event.x * 2;
        y = event.y * 2;
      });
    });
  }

  Future<void> _loadSavedEmojiData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmojiName = prefs.getString('saved_emoji_name');
      savedEmojiVerse = prefs.getString('saved_emoji_verse');
      savedEmojiPath = prefs.getString('saved_emoji_path');
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (savedEmojiName == null || savedEmojiPath == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select your emoji from',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              SizedBox(width: 5,),
              Icon(Icons.insert_emoticon_sharp,color: Colors.blue,),

            ],
          ),
        ),
      );
    }

    return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ✅ الآية
          if (savedEmojiVerse != null)
            Positioned(
              top: 40,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.blue, size: 22),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        savedEmojiVerse!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ✅ الكرة والإيموجي
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 130,
                right: 40,
                left: 0,
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(y, -x + _floatingAnimation.value),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ✅ الظل البنفسجي
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.blueAccent.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                radius: 0.8,
                              ),
                            ),
                          ),

                          // ✅ خلفية الكرة
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.05),
                                  Colors.transparent,
                                ],
                                center: Alignment.topLeft,
                                radius: 0.9,
                              ),
                              border: Border.all(color: Colors.white38, width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white10,
                                  blurRadius: 25,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),

                          // ✅ الإيموجي
                          ClipOval(
                            child: SizedBox(
                              width: 240,
                              height: 240,
                              child: Lottie.asset(
                                savedEmojiPath!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, color: Colors.red, size: 50),
                              ),
                            ),
                          ),

                          // ✅ لمعة داخلية
                          Positioned(
                            top: 30,
                            left: 90,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                  center: Alignment.center,
                                  radius: 0.6,
                                ),
                              ),
                            ),
                          ),

                          // ✅ نقطة ضوء
                          Positioned(
                            bottom: 25,
                            right: 110,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
              ;
            },
          ),

          // ✅ زر تغيير الإيموجي
        ],

    );
  }
}
