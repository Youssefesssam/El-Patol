import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../../../../firebase/authProvider.dart';
import '../../../../../../../firebase/dataProvider.dart';
import '../../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_get_data_for_use.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/fireBaseGetDataForUser.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../../../../firebase/providerTotalScore.dart';

import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../utilites/appTexts.dart';
import '../../../../../utilites/consts.dart';


class WordUser extends StatefulWidget {
  const WordUser({super.key});

  @override
  State<WordUser> createState() => _WordUserState();
}

class _WordUserState extends State<WordUser> {
  bool isFirstSeen = AppTexts.seenWord;

  @override
  Widget build(BuildContext context) {
    final providerTotalScore = Provider.of<ProviderTotalScore>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context);
    final authProviders = Provider.of<AuthProviders>(context);

    return
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // تحديد الحد الأقصى للإرتفاع
        ),child:
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50) ),
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.white],
                end: Alignment.bottomCenter

            ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade300,Colors.blue.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.wordOfWeek,
                      style: GoogleFonts.abyssinicaSil(fontSize: 22, color: Colors.blue.shade900,fontWeight: FontWeight.bold),
                    ),
                  SizedBox(width: 10,),
                  Icon(Icons.hdr_strong_outlined,color: Colors.blue.shade900,)
                ],
              ),
               SizedBox(height: 20,),
              // Image or Icon Header
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Icon(Icons.hearing, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // Card for the word
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue.shade50],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: New_fire_base_get_data_for_use.fetchMessages(governorate:authProviders.governorateUs!, churchCode: authProviders.churchCodeUs!, stageCode: authProviders.stageCodeUs!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('خطأ: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا يوجد كلمة متاحة'));
                      }

                      final message = snapshot.data!.docs[0];
                      final text = message['message'];

                      return Center(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.abyssinicaSil(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Slide Action Button
              Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> _key = GlobalKey();
                  return SlideAction(
                    key: _key,
                    onSubmit: () async {
                      await Consts.getWordId();
                      CollectionReference wordRef =   FirebaseFirestore.instance
                          .collection("governorate")
                          .doc(authProviders.governorateUs)
                          .collection('church')
                          .doc(authProviders.churchCodeUs)
                          .collection('activites')
                          .doc(authProviders.stageCodeUs).collection('word');
                      QuerySnapshot snapshot = await wordRef.get();

                      if (snapshot.docs.isNotEmpty) {
                        var doc = snapshot.docs.first;
                        String docId = doc.id;

                        if (doc.id != authProviders.wordId || authProviders.wordId == null) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString("wordId", docId);
                          authProviders.setwordId(docId);
                          int currentScore =
                          await New_fire_base_set_data_for_user.getScore(
                            yearId: '1',
                            weekId: authProviders.week.toString(),
                            monthId: authProviders
                                .currentMonth
                                .toString(),
                            scoreType:
                            'scoreSeenUserWord',
                            userId: authProviders.userId!,
                            governorate:
                            authProviders.governorateUs!,
                            church:
                            authProviders.churchCodeUs!,
                            stage: authProviders.stageCodeUs!,
                            code: authProviders.codeUs!,
                          );
                          int updatedScore = currentScore+ 5;


                          await New_fire_base_set_data_for_leader.updateScore(
                            yearId: '1',
                            weekId: authProviders.week.toString(),
                            monthId: authProviders.currentMonth.toString(),
                            newValue: updatedScore,
                            scoreType: 'scoreSeenUserWord',
                            userId: authProviders.userId!,
                            stage: authProviders.stageCodeUs!, governorate: authProviders.governorateUs!, church: authProviders.churchCodeUs!, code: authProviders.codeUs!,
                          );
                        }
                      }
                    },
                    sliderButtonIcon: Icon(
                      Icons.visibility,
                      color: Colors.blue.shade900,
                      size: 20,
                    ),
                    outerColor: Colors.blue.shade900,
                    innerColor: Colors.white,
                    child: Text(
                      "Slide to Mark as Seen",
                      style: GoogleFonts.aboreto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}