import 'package:flutter/material.dart';

class BuildLuxuryFooter extends StatelessWidget {
  const BuildLuxuryFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.4),
          ],
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ).createShader(bounds),
            child: Text(
              'تواصل معنا',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.facebook, Color(0xFF1877F2)),
              SizedBox(width: 15),
              _buildSocialIcon(Icons.telegram, Color(0xFF0088CC)),
              SizedBox(width: 15),
              _buildSocialIcon(Icons.youtube_searched_for, Color(0xFFFF0000)),
              SizedBox(width: 15),
              _buildSocialIcon(Icons.phone, Color(0xFF25D366)),
            ],
          ),
          SizedBox(height: 30),
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '© 2024 مركز النخبة الإعدادي - جميع الحقوق محفوظة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

}
