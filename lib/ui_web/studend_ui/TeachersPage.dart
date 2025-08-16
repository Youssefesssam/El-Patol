import 'package:el_patol/ui/screens/utilites/appAssets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeachersPage extends StatelessWidget {
  static const String routeName = "TeachersPage";

  final List<Map<String, String>> teachers = [
    {"name": "Albert", "subject": "physics ", "image": AppAssets.albert},
    {"name": "منى محمد", "subject": "🔬 علوم", "image": AppAssets.doc},
    {"name": "خالد حسن", "subject": "📚 لغة عربية", "image": AppAssets.boy},
    {"name": "سارة علي", "subject": "🎨 فنون", "image": AppAssets.docwomen},
    {"name": "محمد عبد الله", "subject": "💻 حاسوب", "image": AppAssets.officer},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.girl3},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.coach},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.man},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.boxing},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.drawer},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.eng},
    {"name": "ليلى يوسف", "subject": "🌍 جغرافيا", "image": AppAssets.basketball},
  ];

  TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        title: const Text("👩‍🏫 معلمونا الرائعون"),
        backgroundColor: Colors.orange.shade400,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Column(children:  [
                  Text(
                    "🎉 أهلاً بك في قائمة معلمينا المبدعين 🌟",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "📚 هنا ستجد نخبة من المعلمين المتميزين في جميع المواد، "
                        "جاهزين لمساعدتك على تحقيق النجاح 💪✨",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    AppAssets.docCrazy,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,// عشان تملأ المساحة
                  ),
                  Column(
                    children: [
                      Text(
                        "انت هنا فالمكان الصح هنا البدايه"
                        ,
                        style: GoogleFonts.cairo(
                          fontSize: 30,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        " اختر مدرسك عشان تكمل مشوارك "
                        ,
                        style: GoogleFonts.cairo(
                          fontSize: 30,
                          color: Colors.orangeAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 3,
                    // عدد الأعمدة
                    mainAxisSpacing: 30,
                    // المسافة الرأسية بين الصفوف
                    crossAxisSpacing: 70,
                    // المسافة الأفقية بين الأعمدة
                    shrinkWrap: true,
                    children: teachers.map((teacher) {
                      return TeacherCard(
                        name: teacher["name"]!,
                        subject: teacher["subject"]!,
                        image: teacher["image"]!,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "You are a small "
                        ,
                        style: GoogleFonts.cairo(
                          fontSize: 30,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Albert Einstein",
                        style: GoogleFonts.cairo(
                          fontSize: 30,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Image.asset(
                    AppAssets.smallAlbert,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,// عشان تملأ المساحة
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class TeacherCard extends StatefulWidget {
  final String name;
  final String subject;
  final String image;

  const TeacherCard({
    super.key,
    required this.name,
    required this.subject,
    required this.image,
  });

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _flipCard(),
      onExit: (_) => _flipCard(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.1416;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: GestureDetector(
              onTap: _flipCard,
              child: _controller.value <= 0.5
                  ? _buildFront()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.1416),
                      child: _buildBack(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          clipBehavior: Clip.antiAlias, // مهم عشان القص يشتغل
          child: Image.asset(
            widget.image,
            fit: BoxFit.cover, // عشان تملأ المساحة
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          width: double.infinity,
          child: Text(widget.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildBack() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, size: 60, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              widget.subject,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "أنت تبني المستقبل 🌟",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
