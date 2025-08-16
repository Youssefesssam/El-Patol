import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../utilites/appTexts.dart';

class Word extends StatefulWidget {
  const Word({super.key});

  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  final TextEditingController wordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders=Provider.of(context);
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
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // شريط أعلى الصفحة

                  const SizedBox(height: 20),

                  // العنوان
                  Text(
                    "Word",
                    style: GoogleFonts.abel(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // جلب آخر كلمة مخزنة
                  StreamBuilder<QuerySnapshot>(
                    stream:   FirebaseFirestore.instance
                      .collection("governorate")
                      .doc(authProviders.governorate)
                      .collection('church')
                      .doc(authProviders.churchCodeL)
                      .collection('activites')
                      .doc("${authProviders.stageTypeL!}_${authProviders.stageYearL}")
                        .collection('word')
                        .orderBy('Time', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: Colors.blue));
                      }
                      var docs = snapshot.data!.docs;
                      String lastMessage = docs.isNotEmpty
                          ? docs.first['message']
                          : "No words yet";

                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.latestWord,
                                style: GoogleFonts.abyssinicaSil(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                lastMessage,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // حقل إدخال النص
                  TextField(
                    controller: wordController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: AppLocalizations.of(context)!.typeYourWordSayNextWeekHere,
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
                      // زر الخروج
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          child:  Center(
                            child: Text(
                              AppLocalizations.of(context)!.exit,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // زر المشاركة
                      InkWell(
                        onTap: () async {
                          await New_fire_base_set_data_for_leader.sendWord(
                            message: wordController.text,
                            sender: authProviders.nameL!,
                            church:authProviders.churchCodeL! ,
                            stage:"${authProviders.stageTypeL!}_${authProviders.stageYearL}" ,
                            governorate:authProviders.governorate!
                          );
                          AppTexts.fristSeenWord(true);

                          wordController.clear();
                        },
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade800,
                                Colors.blue,
                                Colors.indigo.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child:  Center(
                            child: Text(
                              AppLocalizations.of(context)!.share,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
