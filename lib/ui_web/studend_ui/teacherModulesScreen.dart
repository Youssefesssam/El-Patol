import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/models_web/model_module.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models_web/model_student.dart';
import '../../ui/screens/utilites/appAssets.dart';
import 'moduleVideosScreen.dart';

class TeacherModulesScreen extends StatefulWidget {
  final String teacherId;
  final Student student;

  const TeacherModulesScreen({
    super.key,
    required this.teacherId,
    required this.student,
  });

  @override
  State<TeacherModulesScreen> createState() => _TeacherModulesScreenState();
}

class _TeacherModulesScreenState extends State<TeacherModulesScreen> {
  late Map<String, dynamic> paidModules;

  @override
  void initState() {
    super.initState();
    paidModules = Map<String, dynamic>.from(widget.student.paidModules);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "📚 موديولات ${widget.teacherId}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('center')
            .doc(widget.student.centerCode)
            .collection('Mr')
            .doc(widget.teacherId)
            .collection('modules')
            .doc(widget.student.stageCode)
            .collection('module')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا يوجد موديولات بعد 📚",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          print("🔥 READ module");
          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final moduleId = docs[index].id;

              final title = data['title'] ?? 'بدون عنوان';
              final stage = data['stage'] ?? '';
              final price = data['price'] ?? 0;
              final imageUrl = data['imageUrl'] ?? '';

              final key = "${widget.teacherId}_$moduleId";
              var status = paidModules[key];

              // حالة الزر
              String buttonText;
              Color buttonColor;
              VoidCallback? onPressed;

              if (status == true) {
                buttonText = "فتح الكورس";
                buttonColor = Colors.green[700]!;
                onPressed = () => _navigateToModule(context, moduleId, title);
              } else if (status == "pending") {
                buttonText = "في انتظار القبول";
                buttonColor = Colors.grey;
                onPressed = null;
              } else {
                buttonText = "اشترك الآن";
                buttonColor = Colors.orange[700]!;
                onPressed = () =>
                    _showSubscriptionDialog(context, moduleId, title, price);
              }

              return GestureDetector(
                onTap: status == true
                    ? () => _navigateToModule(context, moduleId, title)
                    : null,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // صورة الموديول
                        Positioned.fill(
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            AppAssets.man,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Overlay غامق
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),

                        // النصوص
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "المرحلة: $stage",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                "💰 $price جنيه",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                onPressed: onPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 36),
                                ),
                                child: Text(
                                  buttonText,
                                  style: GoogleFonts.cairo(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToModule(BuildContext context, String moduleId, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleVideosScreen(
          moduleId: moduleId,
          moduleTitle: title,
          teacherId: widget.teacherId,
        ),
      ),
    );
  }

  void _showSubscriptionDialog(
      BuildContext context, String moduleId, String title, int price) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تأكيد الاشتراك', style: GoogleFonts.cairo()),
        content: Text('هل تريد الاشتراك في "$title" مقابل $price جنيه؟',
            style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _subscribeToModule(moduleId);
              await requestSubscription(widget.teacherId, moduleId,
                  widget.student, title, price);

              setState(() {
                paidModules["${widget.teacherId}_$moduleId"] = "pending";
              });

              _showPendingMessage(context, title);
            },
            child: Text('تأكيد', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showPendingMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال طلب الاشتراك في "$title"، في انتظار القبول من المستر.',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.orange[700],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> requestSubscription(String teacherId, String moduleId,
      Student student, String title, int price) async {
    print("🔥 READ requestSubscription");

    await FirebaseFirestore.instance
        .collection('center')
        .doc(student.centerCode)
        .collection('Mr')
        .doc(teacherId)
        .collection('modules')
        .doc(student.stageCode)
        .collection('subscriptionRequests')
        .add({
      "studentId": student.id,
      "studentStage": student.stageCode,
      "studentEmail": student.email,
      "studentName": student.name,
      "moduleId": moduleId,
      "title": title,
      "price": price,
      "status": "pending",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<void> _subscribeToModule(String moduleId) async {
    print("🔥 READ _subscribeToModule");

    await FirebaseFirestore.instance
        .collection('center')
        .doc(widget.student.centerCode)
        .collection('Student')
        .doc(widget.student.stageCode)
        .collection('users')
        .doc(widget.student.id)
        .update({
      "paidModules.${widget.teacherId}_$moduleId": "pending",
    });
  }
}
