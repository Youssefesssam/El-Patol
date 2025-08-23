import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui/screens/utilites/appAssets.dart';

class TeachersPage extends StatefulWidget {
  static const String routeName = "TeachersPage";

  final String centerCode;
  final String studentCode;
  final String stageCode;

  const TeachersPage({
    super.key,
    required this.centerCode,
    required this.studentCode,
    required this.stageCode,
  });

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<QueryDocumentSnapshot> _teachers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Load teachers data once
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("center")
          .doc(widget.centerCode)
          .collection("Mr")
          .get();

      setState(() {
        _teachers = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "فشل في تحميل البيانات: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade700,
              Colors.orange.shade500,
              Colors.orange.shade300,
              Colors.orange.shade100,
              Colors.white,
            ],
            stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              _buildHeader(isLargeScreen),

              // Welcome message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "اكتشف معلمينا المتميزين",
                  style: GoogleFonts.cairo(
                    fontSize: isLargeScreen ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Welcome Cards
              SizedBox(
                height: isLargeScreen ? 200 : 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildWelcomeCard(
                      "🎓 أهلاً بك في قائمة معلمينا المبدعين",
                      "💚 هنا ستجد نخبة من المعلمين المتميزين في جميع المواد، جاهزين لمساعدتك على تحقيق النجاح",
                      AppAssets.docCrazy,
                      screenWidth,
                      isLargeScreen,
                      Colors.deepOrange,
                    ),
                    _buildWelcomeCard(
                      "📘 معلمو المواد العلمية",
                      "💡 دروس تفاعلية تساعدك على التفوق في الرياضيات والعلوم",
                      AppAssets.doc,
                      screenWidth,
                      isLargeScreen,
                      Colors.teal,
                    ),
                    _buildWelcomeCard(
                      "📝 معلمو المواد الأدبية",
                      "✨ شروحات مبسطة للأدب والتاريخ واللغات",
                      AppAssets.man,
                      screenWidth,
                      isLargeScreen,
                      Colors.purple,
                    ),
                  ],
                ),
              ),

              // Section title
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                child: Row(
                  children: [
                    Text(
                      "المعلمون المتاحون",
                      style: GoogleFonts.cairo(
                        fontSize: isLargeScreen ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange.shade800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_back, color: Colors.deepOrange.shade800),
                    const Spacer(),
                    Chip(
                      backgroundColor: Colors.deepOrange.shade100,
                      label: Text(
                        "${_teachers.length} معلم",
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Teachers Grid
              Expanded(child: _buildTeachersGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.orange.shade800),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Text(
            "معلمونا الرائعون",
            style: GoogleFonts.cairo(
              fontSize: isLargeScreen ? 26 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.school,
              color: Colors.orange.shade800,
              size: isLargeScreen ? 28 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String title1, String title2, String image, double screenWidth, bool isLargeScreen, Color color) {
    double cardWidth = screenWidth * 0.8;
    if (screenWidth >= 1200) cardWidth = 400;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: isLargeScreen ? 100 : 80,
                    height: isLargeScreen ? 100 : 80,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        image,
                        width: isLargeScreen ? 70 : 50,
                        height: isLargeScreen ? 70 : 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title1,
                          style: GoogleFonts.cairo(
                            fontSize: isLargeScreen ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          title2,
                          style: GoogleFonts.cairo(
                            fontSize: isLargeScreen ? 14 : 12,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeachersGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              _errorMessage!,
              style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadTeachers,
              child: Text("إعادة المحاولة", style: GoogleFonts.cairo()),
            ),
          ],
        ),
      );
    }

    if (_teachers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              "لا يوجد معلمين حالياً",
              style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 1.2,
      ),
      itemCount: _teachers.length,
      itemBuilder: (context, index) {
        final teacher = _teachers[index].data() as Map<String, dynamic>;
        final teacherCode = _teachers[index].id;

        return EnhancedTeacherCard(
          image: teacher["image"]?.isNotEmpty == true ? teacher["image"] : AppAssets.man,
          name: teacher["name"] ?? "بدون اسم",
          subject: teacher["specialty"] ?? "غير محدد",
          studentsCount: (teacher["students"] as List?)?.length ?? 0,
          rating: (teacher["rating"] ?? 4.5).toDouble(),
          experience: teacher["experience"] ?? "متوسط",
          onSubscribe: () async {
            await subscribeStudentToTeacher(teacherCode, context);
          },
        );
      },
    );
  }

  Future<void> subscribeStudentToTeacher(
      String teacherCode, BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(width: 20),
            Text(
              "جاري الاشتراك...",
              style: GoogleFonts.cairo(),
            ),
          ],
        ),
      ),
    );

    try {
      final studentRef = FirebaseFirestore.instance
          .collection("center")
          .doc(widget.centerCode)
          .collection("Student")
          .doc(widget.stageCode)
          .collection("users")
          .doc(widget.studentCode);

      final teacherRef = FirebaseFirestore.instance
          .collection("center")
          .doc(widget.centerCode)
          .collection("Mr")
          .doc(teacherCode);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(studentRef, {
          "teachers": FieldValue.arrayUnion([teacherCode])
        });

        transaction.update(teacherRef, {
          "students": FieldValue.arrayUnion([widget.studentCode])
        });
      });

      Navigator.pop(context); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "تم الاشتراك بنجاح! 🎉",
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "يمكنك الآن الوصول لدروس هذا المعلم",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "ممتاز",
                style: GoogleFonts.cairo(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Text("حدث خطأ: $e", style: GoogleFonts.cairo()),
            ],
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}

class EnhancedTeacherCard extends StatefulWidget {
  final String image;
  final String name;
  final String subject;
  final int studentsCount;
  final double rating;
  final String experience;
  final VoidCallback onSubscribe;

  const EnhancedTeacherCard({
    super.key,
    required this.image,
    required this.name,
    required this.subject,
    required this.studentsCount,
    required this.rating,
    required this.experience,
    required this.onSubscribe,
  });

  @override
  State<EnhancedTeacherCard> createState() => _EnhancedTeacherCardState();
}

class _EnhancedTeacherCardState extends State<EnhancedTeacherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? Colors.orange.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.15),
                blurRadius: isHovered ? 20 : 12,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),

                // Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Online Status Indicator
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.6),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),

                        // Name
                        Text(
                          widget.name,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Subject
                        Text(
                          widget.subject,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.orange.shade200,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),

                        // Rating and Students Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Rating Stars
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < widget.rating.floor()
                                      ? Icons.star
                                      : index < widget.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  size: 12,
                                  color: Colors.amber.shade300,
                                );
                              }),
                            ),

                            // Students Count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      Icons.group,
                                      size: 10,
                                      color: Colors.blue.shade600
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${widget.studentsCount}",
                                    style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Subscribe Button
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: ElevatedButton(
                            onPressed: widget.onSubscribe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              "اشتراك",
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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