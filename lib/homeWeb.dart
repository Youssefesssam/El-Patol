import 'dart:ui';
import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeWeb extends StatelessWidget {
  static const String routeName = "homeWeb";

  const HomeWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildHeroSection(),

            _sectionTitle("🚀 دوراتنا"),
            const SizedBox(height: 10),
            _animatedWrap([
              _animatedCard(Icons.science_outlined, "الفيزياء", "إتقان أساسيات الفيزياء بأسلوب مبسط وتفاعلي."),
              _animatedCard(Icons.calculate_outlined, "الرياضيات", "تعلم الرياضيات بأمثلة واقعية وتمارين ممتعة."),
              _animatedCard(Icons.biotech_outlined, "الكيمياء", "استكشف عالم الذرات والجزيئات والتفاعلات."),
              _animatedCard(Icons.history_edu_outlined, "التاريخ", "فهم الماضي لبناء مستقبل أفضل."),
              _animatedCard(Icons.language_outlined, "اللغة الإنجليزية", "طور مفرداتك ومهارات التحدث بطلاقة."),
              _animatedCard(Icons.computer_outlined, "علوم الحاسوب", "تعلم البرمجة والذكاء الاصطناعي."),
            ]),

            _sectionDivider(),

            _sectionTitle("👩‍🏫 مدرسونا"),
            const SizedBox(height: 10),
            _animatedWrap([
              _animatedTeacher("أحمد علي", "خبير في الفيزياء", "assets/teacher1.jpg"),
              _animatedTeacher("منى حسن", "متخصصة في الرياضيات", "assets/teacher2.jpg"),
              _animatedTeacher("عمر سعيد", "مدرس الكيمياء", "assets/teacher3.jpg"),
            ]),

            _sectionDivider(),

            _sectionTitle("💡 لماذا تختارنا؟"),
            _animatedWrap([
              _animatedFeature(Icons.star_rounded, "جودة عالية", "مدرسون بخبرة سنوات طويلة."),
              _animatedFeature(Icons.access_time_filled, "جدول مرن", "حصص صباحية ومسائية."),
              _animatedFeature(Icons.school_rounded, "طرق حديثة", "تعليم تفاعلي بأحدث الوسائل."),
            ]),

            _sectionDivider(),

            _sectionTitle("💬 آراء طلابنا"),
            _animatedWrap([
              _testimonialCard("أفضل مكان للتعلم! تحسنت درجاتي كثيراً بفضل الأكاديمية."),
              _testimonialCard("المدرسون رائعون ويساعدون دائماً."),
              _testimonialCard("تعلم ممتع وبيئة ودية وفعّالة."),
            ]),

            _sectionDivider(),

            _contactSection(),
          ],
        ),
      ),
    );
  }

  // ------------------ عناصر أساسية ------------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.cyan.shade400],
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppAssets.logoPatol, width: 60, height: 60),
          Row(
            children: [
              _navItem("الرئيسية"),
              _navItem("الدورات"),
              _navItem("المدرسون"),
              _navItem("تواصل معنا"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Image.asset(
            AppAssets.mainPhoto,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Lottie.asset(
          AppAssets.fire,
          repeat: true,
        ),
        Column(
          children: [
            Text(
              "أكاديمية الباتول",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(2, 2))
              ]),
            ),
            const SizedBox(height: 15),
            Text(
              "نمنحك العلم والمهارات لتصنع مستقبلك",
              style: TextStyle(fontSize: 22, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("سجّل الآن", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),

      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal)),
  );

  Widget _sectionDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Divider(thickness: 1, color: Colors.grey.shade300, indent: 50, endIndent: 50),
  );

  Widget _navItem(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
    ),
  );

  // ------------------ الكروت ------------------
  Widget _animatedCard(IconData icon, String title, String desc) {
    return _hoverableCard(
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.teal),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 5),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _animatedTeacher(String name, String subject, String img) {
    return _hoverableCard(
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: AssetImage(img)),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          Text(subject, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _animatedFeature(IconData icon, String title, String desc) {
    return _hoverableCard(
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.teal),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 5),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _testimonialCard(String text) {
    return _hoverableCard(
      child: Text("“$text”", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
    );
  }

  Widget _hoverableCard({required Widget child}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 4))],
        ),
        child: child,
      ),
    );
  }

  // ------------------ التواصل ------------------
  Widget _contactSection() {
    return Container(
      width: double.infinity,
      color: Colors.teal,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: const [
          Text("تواصل معنا", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Text(
            "📍 العنوان: شارع رئيسي، القاهرة\n📞 الهاتف: +20 123 456 789\n✉ البريد: info@elpatolacademy.com",
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ------------------ أنيميشن الظهور ------------------
  Widget _animatedWrap(List<Widget> items) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: List.generate(items.length, (index) {
        return ScrollAnimatedItem(child: items[index]);
      }),
    );
  }
}

// ==================== ويدجت الانميشن ====================
class ScrollAnimatedItem extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;

  const ScrollAnimatedItem({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offsetY = 50,
  }) : super(key: key);

  @override
  State<ScrollAnimatedItem> createState() => _ScrollAnimatedItemState();
}

class _ScrollAnimatedItemState extends State<ScrollAnimatedItem> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.child.hashCode.toString()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        } else if (info.visibleFraction <= 0.1 && _visible) {
          setState(() => _visible = false);
        }
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _visible ? const Offset(0, 0) : Offset(0, widget.offsetY / 100),
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
