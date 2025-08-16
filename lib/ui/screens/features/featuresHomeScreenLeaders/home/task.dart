import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../services/firebase_service.dart';
import 'answers.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders=Provider.of(context);
    print(authProviders.codeSubl);
 Map codeData= FirebaseService.codeDetails(authProviders.codeSubl!, "L");
    return StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance
            .collection("governorate")
            .doc(authProviders.governorate)
        .collection('church')
        .doc(authProviders.churchCodeL)
        .collection('activites')
        .doc(authProviders.stageCode)
        .collection(New_fire_base_set_data_for_leader.taskCollection).limit(1).snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          _taskController.text = ''; // إذا لم تكن هناك بيانات
        } else {
          _taskController.text = snapshot.data!.docs.first['task']; // تحميل أول مهمة
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 160),
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        "Write the task",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Answers.routeName);
                        },
                        child: Icon(Icons.question_answer_outlined, size: 35, color: Colors.blue[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(-5, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _taskController.text.isEmpty ? '' : _taskController.text,
                            style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            New_fire_base_get_data_for_leader.deleteAnswers(governorate: authProviders.governorate!, church: authProviders.churchCodeL!, stage: "${authProviders.stageTypeL!}_${authProviders.stageYearL!}");
                            FirebaseFirestore.instance.collection("governorate").doc(authProviders.governorate)
                                .collection('church')
                                .doc(authProviders.churchCodeL)
                                .collection('activites')
                                .doc(authProviders.stageCode)
                                .collection(New_fire_base_set_data_for_leader.taskCollection).doc(snapshot.data!.docs.first.id).delete();
                            _taskController.clear();
                          },
                          child: Icon(Icons.delete, size: 30, color: Colors.red[400]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // حقل إدخال النص
                  TextField(
                    controller: _taskController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Task...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 30),

                  // أزرار الإجراءات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: SlideAction(
                          innerColor: Colors.white,
                          outerColor: Colors.red[600],
                          elevation: 10,
                          textColor: Colors.white,
                          sliderButtonIconSize: 10,
                          sliderButtonIconPadding: 12,
                          animationDuration: const Duration(milliseconds: 200),
                          sliderButtonIcon: const Icon(Icons.exit_to_app, size: 20, color: Colors.red),
                          submittedIcon: const Icon(Icons.check, size: 30, color: Colors.white),
                          key: GlobalKey<SlideActionState>(),
                          onSubmit: () {
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Exit",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: SlideAction(
                          innerColor: Colors.white,
                          outerColor: Colors.blue[800],
                          elevation: 10,
                          textColor: Colors.white,
                          sliderButtonIconSize: 10,
                          sliderButtonIconPadding: 12,
                          animationDuration: const Duration(milliseconds: 500),
                          sliderButtonIcon:  Icon(Icons.send, size: 20, color: Colors.blue[800]),
                          submittedIcon: const Icon(Icons.check, size: 30, color: Colors.white),
                          key: GlobalKey<SlideActionState>(),
                          onSubmit: () {
                            New_fire_base_set_data_for_leader.sendTask(
                                task: _taskController.text,
                                leader: authProviders.nameL!,
                              governorate:authProviders.governorate! ,
                              church: authProviders.churchCodeL!,
                              stage: authProviders.stageCode!,
                              );

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Share",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
