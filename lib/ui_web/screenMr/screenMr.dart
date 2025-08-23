import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../add_video/chooseStage.dart';
import '../subscriptionRequestsScreen/subscriptionRequestsScreen.dart';
import 'followingStudent.dart';

class ScreenMr extends StatelessWidget {
  static const String routeName = 'screenMr';

  const ScreenMr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'لوحة التحكم',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
              Color(0xFF000428),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  FancyDarkButton(
                    label: '📚 الطلاب',
                    icon: Icons.school_rounded,
                    gradient: const [Color(0xFF1E3C72), Color(0xFF2A5298)],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FollowingStudent(
                            centerCode: "101",
                            teacherCode: "Mr1017595",
                          ),
                        ),
                      );
                    },
                  ),
                  FancyDarkButton(
                    label: '👥 الطلبات',
                    icon: Icons.person_4_rounded,
                    gradient: const [Color(0xFF42275a), Color(0xFF734b6d)],
                    onPressed: () {
                      Navigator.pushNamed(
                          context, SubscriptionRequestsScreen.routeName);
                    },
                  ),
                  FancyDarkButton(
                    label: '➕ وحدة جديدة',
                    icon: Icons.tune_rounded,
                    gradient: const [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364)
                    ],
                    onPressed: () {
                      Navigator.pushNamed(context, ChooseStageScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FancyDarkButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onPressed;

  const FancyDarkButton({
    super.key,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onPressed,
  });

  @override
  State<FancyDarkButton> createState() => _FancyDarkButtonState();
}

class _FancyDarkButtonState extends State<FancyDarkButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient.last.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Icon(widget.icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
