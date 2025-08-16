import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../../../../firebase/authProvider.dart';
import '../../../../../../../firebase/dataProvider.dart';
import '../../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/fireBaseSetDataForUser.dart';
import '../../../../../../../firebase/providerTotalScore.dart';
import '../../../../../../../model/modelEvent.dart';

import '../../../../../utilites/appAssets.dart';
import '../../../../../utilites/appTexts.dart';
import '../../../../../utilites/consts.dart';

class EventUser extends StatefulWidget {
  EventUser({super.key});

  @override
  State<EventUser> createState() => _EventUserState();
}

class _EventUserState extends State<EventUser> {
  bool _isExpanded = false;
  int ScoreSeenEvnt = 0;

  @override
  Widget build(BuildContext context) {
    bool isFirstSeen = AppTexts.seenEvent ;
    DataProvider dataProvider = Provider.of(context);
    ProviderTotalScore providerTotalScore =
    Provider.of<ProviderTotalScore>(context, listen: false);
    AuthProviders authProviders = Provider.of(context);

    int count = dataProvider.currentWeekNum;

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hi..Event",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.event_available,
                      color: Colors.blue.shade900,
                    )
                  ],
                ),
                const SizedBox(height: 15),
                // Event Card
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info
                      const SizedBox(height: 15),
                      // Event Image
                      StreamBuilder<QuerySnapshot>(
                        stream:   FirebaseFirestore.instance
                            .collection("governorate")
                            .doc(authProviders.governorateUs)
                            .collection('church')
                            .doc(authProviders.churchCodeUs)
                            .collection('activites')
                            .doc(authProviders.stageCodeUs)
                            .collection(ModelHiEvent.collection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          var docs = snapshot.data!.docs;
                          String? imageUrl;

                          // التحقق من وجود بيانات والتحقق من وجود الصورة
                          if (docs.isNotEmpty && docs.first.data() != null) {
                            var data =
                            docs.first.data() as Map<String, dynamic>;
                            imageUrl = data.containsKey('image')
                                ? data['image'] as String?
                                : null;
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height *
                                  .45,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppAssets.nothing,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                  MediaQuery.of(context).size.height *
                                      .45,
                                );
                              },
                            )
                                : Image.asset(
                              AppAssets.nothing,
                              fit: BoxFit.fitWidth,

                              width: double.infinity,
                              height: MediaQuery.of(context).size.height *
                                  .45,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                        width: MediaQuery.of(context).size.width * .4,
                        child: Center(child: Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> _key =
                            GlobalKey();
                            return Padding(
                              padding: const EdgeInsets.all(.0),
                              child: SlideAction(
                                innerColor: Colors.white,
                                sliderButtonIconPadding: 4,
                                sliderButtonIcon:  Icon(
                                  Icons.person,
                                  size: 22,
                                  color: Colors.blue.shade900,
                                ),
                                submittedIcon: const Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                outerColor: Colors.blue.shade900,
                                enabled: true,
                                elevation: 0,
                                textColor: Colors.white,
                                sliderRotate: true,
                                height: 80,
                                key: _key,
                                onSubmit: () async {

                                  await Consts.getHiEventId();
                                  CollectionReference hiEventRef =   FirebaseFirestore.instance
                                      .collection("governorate")
                                      .doc(authProviders.governorateUs)
                                      .collection('church')
                                      .doc(authProviders.churchCodeUs)
                                      .collection('activites')
                                      .doc(authProviders.stageCodeUs)
                                      .collection('hiEvent');
                                  QuerySnapshot snapshot = await hiEventRef.get();
                                  if (snapshot.docs.isNotEmpty) {
                                    var doc = snapshot.docs
                                        .first;
                                    String docId = doc.id;
                                    if (doc.id != authProviders
                                        .hiEventId ||
                                        authProviders
                                            .hiEventId == null) {
                                      SharedPreferences prefs = await SharedPreferences
                                          .getInstance();
                                      await prefs.setString("hiEvent",
                                          docId);
                                      authProviders.sethiEventId(
                                          docId);

                                      await New_fire_base_set_data_for_leader.updateScore(
                                        yearId: '1',
                                        weekId: "1",//authProviders.week.toString(),
                                        monthId: authProviders.currentMonth.toString(),
                                        newValue: 5,
                                        scoreType: 'scoreSeenUserEvent',
                                        userId: authProviders.userId!,
                                        stage: authProviders.stageCodeUs!, governorate: authProviders.governorateUs!, church: authProviders.churchCodeUs!, code: authProviders.codeUs!,

                                      );
                                    }
                                  }
                                },

                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Expanded(
                                      child: Text(
                                        "Seen",
                                        style: GoogleFonts.aboreto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream:  FirebaseFirestore.instance
                            .collection("governorate")
                            .doc(authProviders.governorateUs)
                            .collection('church')
                            .doc(authProviders.churchCodeUs)
                            .collection('activites')
                            .doc(authProviders.stageCodeUs)
                            .collection(ModelHiEvent.collection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var docs = snapshot.data!.docs;
                          String lastMessage = docs.isNotEmpty
                              ? docs.first['hiEvent'] ?? "No words yet"
                              : "No words yet";

                          return Builder(
                            builder: (context) {
                              bool isLongText = lastMessage.length > 100;
                              String displayText = isLongText
                                  ? (_isExpanded
                                  ? lastMessage
                                  : lastMessage.substring(0, 100) + "...")
                                  : lastMessage;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                      children: [
                                        TextSpan(text: displayText),
                                        if (isLongText)
                                          TextSpan(
                                            text:
                                            _isExpanded ? " Less" : "More",
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue.shade900,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  _isExpanded = !_isExpanded;
                                                });
                                              },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
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
