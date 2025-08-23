import 'package:flutter/material.dart';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';

class BuildPremiumSubjectsGrid extends StatelessWidget {
  const BuildPremiumSubjectsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // تحديد نوع الجهاز
    DeviceType deviceType = _getDeviceType(screenWidth);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(deviceType),
        vertical: 16,
      ),
      child: Column(
        children: [
          _buildHeader(context, deviceType),
          const SizedBox(height: 24),
          _buildResponsiveGrid(context, deviceType),
        ],
      ),
    );
  }

  // تحديد نوع الجهاز
  DeviceType _getDeviceType(double width) {
    if (width >= 1200) return DeviceType.desktop;
    if (width >= 800) return DeviceType.tablet;
    if (width >= 600) return DeviceType.largeMobile;
    return DeviceType.mobile;
  }

  // الحصول على المسافة الجانبية حسب نوع الجهاز
  double _getHorizontalPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 40;
      case DeviceType.tablet:
        return 30;
      case DeviceType.largeMobile:
        return 20;
      case DeviceType.mobile:
        return 16;
    }
  }

  // بناء العنوان الرئيسي
  Widget _buildHeader(BuildContext context, DeviceType deviceType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        'المواد الدراسية المتميزة',
        style: TextStyle(
          fontSize: _getHeaderFontSize(deviceType),
          fontWeight: FontWeight.w700,
          color: Colors.orangeAccent,
          letterSpacing: 0.5,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // حجم خط العنوان حسب نوع الجهاز
  double _getHeaderFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 32;
      case DeviceType.tablet:
        return 28;
      case DeviceType.largeMobile:
        return 26;
      case DeviceType.mobile:
        return 24;
    }
  }

  // بناء الشبكة المتجاوبة
  Widget _buildResponsiveGrid(BuildContext context, DeviceType deviceType) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(deviceType);
        final spacing = _getGridSpacing(deviceType);

        // حساب عرض كل عنصر
        final availableWidth = constraints.maxWidth - (spacing * (crossAxisCount - 1));
        final itemWidth = availableWidth / crossAxisCount;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: _getAspectRatio(deviceType, itemWidth),
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: _getSubjects().map((subject) =>
              _buildSubjectCard(
                subject.title,
                subject.imagePath,
                subject.primaryColor,
                subject.bgColor,
                deviceType,
              ),
          ).toList(),
        );
      },
    );
  }

  // عدد الأعمدة حسب نوع الجهاز
  int _getCrossAxisCount(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 4;
      case DeviceType.tablet:
        return 3;
      case DeviceType.largeMobile:
        return 2;
      case DeviceType.mobile:
        return 2;
    }
  }

  // نسبة العرض إلى الارتفاع
  double _getAspectRatio(DeviceType deviceType, double itemWidth) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 0.75; // أطول لاستيعاب الصورة الأكبر
      case DeviceType.tablet:
        return 0.8;
      case DeviceType.largeMobile:
        return 0.85;
      case DeviceType.mobile:
        return 0.9; // أطول للهواتف الصغيرة لاستيعاب الصورة الأكبر
    }
  }

  // المسافة بين عناصر الشبكة
  double _getGridSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 24;
      case DeviceType.tablet:
        return 20;
      case DeviceType.largeMobile:
        return 16;
      case DeviceType.mobile:
        return 12;
    }
  }

  // قائمة المواد الدراسية
  List<Subject> _getSubjects() {
    return [
      Subject('الرياضيات', AppAssets.albert, const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
      Subject('العلوم', AppAssets.doctor, const Color(0xFF059669), const Color(0xFFECFDF5)),
      Subject('اللغة العربية', AppAssets.girl1, const Color(0xFFD97706), const Color(0xFFFEF3C7)),
      Subject('اللغة الإنجليزية', AppAssets.girl2, const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
      Subject('الدراسات', AppAssets.officer, const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
      Subject('الحاسب الآلي', AppAssets.eng, const Color(0xFF0891B2), const Color(0xFFE0F7FA)),
    ];
  }

  // بناء كارت المادة الدراسية
  Widget _buildSubjectCard(
      String title,
      String imagePath,
      Color primaryColor,
      Color bgColor,
      DeviceType deviceType,
      ) {
    final cardPadding = _getCardPadding(deviceType);
    final imageSize = _getImageSize(deviceType);
    final titleFontSize = _getTitleFontSize(deviceType);
    final iconSize = _getIconSize(deviceType);

    return GestureDetector(
      onTap: () {
        // يمكن إضافة وظيفة التنقل هنا
        _handleSubjectTap(title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(_getBorderRadius(deviceType)),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // دوائر الزينة في الخلفية
            _buildBackgroundDecorations(primaryColor, deviceType),

            // المحتوى الرئيسي
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الصورة الشخصية (العنصر الأساسي)
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: _buildSubjectImage(imagePath, primaryColor, imageSize, title),
                    ),
                  ),

                  SizedBox(height: _getVerticalSpacing(deviceType) * 0.5),

                  // الجزء السفلي مع الأيقونة والنص
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الأيقونة الصغيرة
                        _buildSubjectIcon(title, primaryColor, iconSize),

                        SizedBox(height: _getVerticalSpacing(deviceType) * 0.3),

                        // النص
                        _buildSubjectTitle(title, primaryColor, titleFontSize),

                        SizedBox(height: _getVerticalSpacing(deviceType) * 0.2),

                        // نقاط الزينة
                        _buildDecorationDots(primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // شارة "متميز"
            _buildPremiumBadge(primaryColor, deviceType),
          ],
        ),
      ),
    );
  }

  // الحصول على padding الكارت
  double _getCardPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 20;
      case DeviceType.tablet:
        return 18;
      case DeviceType.largeMobile:
        return 16;
      case DeviceType.mobile:
        return 14;
    }
  }

  // حجم الصورة
  double _getImageSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 250;
      case DeviceType.tablet:
        return 100;
      case DeviceType.largeMobile:
        return 80;
      case DeviceType.mobile:
        return 75;
    }
  }

  // حجم خط العنوان
  double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 15;
      case DeviceType.largeMobile:
        return 14;
      case DeviceType.mobile:
        return 13;
    }
  }

  // حجم الأيقونة
  double _getIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 20;
      case DeviceType.tablet:
        return 18;
      case DeviceType.largeMobile:
        return 16;
      case DeviceType.mobile:
        return 14;
    }
  }

  // نصف القطر للحواف
  double _getBorderRadius(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 24;
      case DeviceType.tablet:
        return 20;
      case DeviceType.largeMobile:
        return 18;
      case DeviceType.mobile:
        return 16;
    }
  }

  // المسافة العمودية
  double _getVerticalSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return 16;
      case DeviceType.tablet:
        return 14;
      case DeviceType.largeMobile:
        return 12;
      case DeviceType.mobile:
        return 10;
    }
  }

  // دوائر الزينة في الخلفية
  Widget _buildBackgroundDecorations(Color primaryColor, DeviceType deviceType) {
    final decorationSize = deviceType == DeviceType.mobile ? 40.0 : 60.0;

    return Stack(
      children: [
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: decorationSize,
            height: decorationSize,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(decorationSize / 2),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -30,
          child: Container(
            width: decorationSize + 20,
            height: decorationSize + 20,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular((decorationSize + 20) / 2),
            ),
          ),
        ),
      ],
    );
  }

  // صورة المادة
  Widget _buildSubjectImage(String imagePath, Color primaryColor, double size, String title) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              color: primaryColor.withOpacity(0.1),
              child: Icon(
                _getSubjectIcon(title),
                color: primaryColor,
                size: size * 0.45,
              ),
            );
          },
        ),
      ),
    );
  }

  // أيقونة المادة
  Widget _buildSubjectIcon(String title, Color primaryColor, double iconSize) {
    return Container(
      padding: EdgeInsets.all(iconSize * 0.3),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getSubjectIcon(title),
        color: Colors.white,
        size: iconSize,
      ),
    );
  }

  // عنوان المادة
  Widget _buildSubjectTitle(String title, Color primaryColor, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // نقاط الزينة
  Widget _buildDecorationDots(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(2),
        ),
      )),
    );
  }

  // شارة المتميز
  Widget _buildPremiumBadge(Color primaryColor, DeviceType deviceType) {
    final badgeSize = deviceType == DeviceType.mobile ? 8.0 : 10.0;

    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: badgeSize * 0.6,
          vertical: badgeSize * 0.2,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '⭐',
          style: TextStyle(
            fontSize: badgeSize,
          ),
        ),
      ),
    );
  }

  // التعامل مع الضغط على المادة
  void _handleSubjectTap(String subject) {
    // يمكن إضافة منطق التنقل هنا
    debugPrint('تم الضغط على مادة: $subject');
  }

  // الحصول على أيقونة المادة
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'الرياضيات':
        return Icons.calculate;
      case 'العلوم':
        return Icons.science;
      case 'اللغة العربية':
        return Icons.language;
      case 'اللغة الإنجليزية':
        return Icons.translate;
      case 'الدراسات':
        return Icons.public;
      case 'الحاسب الآلي':
        return Icons.computer;
      default:
        return Icons.book;
    }
  }
}

// تعريف أنواع الأجهزة
enum DeviceType {
  mobile,      // أقل من 600px
  largeMobile, // 600-799px
  tablet,      // 800-1199px
  desktop,     // أكبر من 1200px
}

// كلاس المادة الدراسية
class Subject {
  final String title;
  final String imagePath;
  final Color primaryColor;
  final Color bgColor;

  Subject(this.title, this.imagePath, this.primaryColor, this.bgColor);
}