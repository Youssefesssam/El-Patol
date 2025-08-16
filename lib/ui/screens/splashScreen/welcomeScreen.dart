import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/loginScreenMasterLeader.dart';
import '../../../screens/login_sub_leader.dart';
import '../auth/loginScreen/loginScreen.dart';
import '../homeScreen/screenUser/homeScreenUsers.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = "WelcomeScreen";

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe3f2fd), Color(0xFF90caf9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 🌟 Logo Title
              Text(
                "SAY WIN",
                style: GoogleFonts.abel(
                  fontSize: 52,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.green.shade800,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 📝 Welcome Text
              Text(
                "مرحبًا بك في تطبيق الخدمة!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                "من فضلك اختر نوع الدخول:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade700,
                ),
              ),

              const SizedBox(height: 36),

              // 🔐 Master Leader Button
              _buildRoleButton(
                context: context,
                label: "ماستر ليدر",
                icon: Icons.workspace_premium_rounded,
                color: Colors.blue.shade800,
                onTap: () {
                  Navigator.pushNamed(context, LoginScreenMasterLeader.routeName);
                },
              ),

              const SizedBox(height: 16),

              // 👤 Leader Button
              _buildRoleButton(
                context: context,
                label: "ليدر",
                icon: Icons.person_outline,
                color: Colors.indigo,
                onTap: () {
                  Navigator.pushNamed(context, LoginSubLeaderScreen.routeName);
                },
              ),

              const SizedBox(height: 16),

              // 🙋 User Button
              _buildRoleButton(
                context: context,
                label: "يوزر",
                icon: Icons.person,
                color: Colors.teal.shade700,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? userId = prefs.getString('userId');
                  if (userId == null) {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  } else {
                    Navigator.pushNamed(context, HomeScreenUsers.routeName);
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Custom Role Button
  Widget _buildRoleButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: color.withOpacity(0.4),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
