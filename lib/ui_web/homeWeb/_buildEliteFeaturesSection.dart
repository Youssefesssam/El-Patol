import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';

class BuildEliteFeaturesSection extends StatelessWidget {
  const BuildEliteFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ).createShader(bounds),
            child: const Text(
              'مميزاتنا الحصرية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.2, // <-- الكارت هيبقى أصغر
            mainAxisSpacing: 40,
            crossAxisSpacing: 40,
            children: [
              _buildFeatureCard(
                'شرح تفاعلي',
                'أساليب تدريس حديثة',
                AppAssets.smallAlbert,
              ),
              _buildFeatureCard(
                'مدرسون نخبة',
                'أفضل الخبراء المتخصصين',
                AppAssets.man,
              ),
              _buildFeatureCard(
                'متابعة شخصية',
                'تتبع دقيق لكل طالب',
                AppAssets.doctor,
              ),
              _buildFeatureCard(
                'تقييم مستمر',
                'اختبارات ومراجعات دورية',
                AppAssets.officerWomen,
              ),
              _buildFeatureCard(
                'تقييم مستمر',
                'اختبارات ومراجعات دورية',
                AppAssets.doc,
              ),
              _buildFeatureCard(
                'تقييم مستمر',
                'اختبارات ومراجعات دورية',
                AppAssets.officer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // الخلفية (الصورة)
            Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade400,
                  child: const Icon(Icons.image, color: Colors.white, size: 40),
                );
              },
            ),
            // تظليل علشان النص يبان
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.65),
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // النصوص
            Positioned(
              bottom: 12,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
