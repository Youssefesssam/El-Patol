import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';


import '../../../../../../../../firebase/authProvider.dart';
import '../../../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_get_data_for_use.dart';
import '../../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import 'countdownTimer.dart';

class IdeasUser extends StatefulWidget {
  const IdeasUser({super.key});

  @override
  State<IdeasUser> createState() => _IdeasUserState();
}

class _IdeasUserState extends State<IdeasUser> with TickerProviderStateMixin {
  late int currentWeek;
  bool _isWeekLoaded = false;
  bool isVotingFinished = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchWeekNumber();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  Future<void> _fetchWeekNumber() async {
    AuthProviders authProviders = Provider.of(context, listen: false);
    int week = await New_fire_base_get_data_for_leader.fetchCurrentWeek(
      governorate: authProviders.governorateUs ?? authProviders.governorate!,
      church: authProviders.churchCodeUs ?? authProviders.churchCodeL!,
      stage: authProviders.stageCodeUs ?? authProviders.stageCode!,
    );
    setState(() {
      currentWeek = week;
      _isWeekLoaded = true;
    });
  }

  void _playWinSound() async {
    await _audioPlayer.play(AssetSource('sounds/win.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    if (!_isWeekLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.votingOnOpinion,
              style: GoogleFonts.aboreto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: CountdownTimer(
                currentWeekNumber: currentWeek,
                onTimerFinished: (bool finished) {
                  setState(() {
                    isVotingFinished = finished;
                  });
                  if (finished) {
                    _controller.forward();
                    _playWinSound();
                  }
                },
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: New_fire_base_get_data_for_use.fetchOpinion(
                  governorate: authProviders.governorateUs ?? authProviders.governorate!,
                  church: authProviders.churchCodeUs ?? authProviders.churchCodeL!,
                  stage: authProviders.stageCodeUs ?? authProviders.stageCode!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noOpinion,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  List opinions = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>? ?? {};
                    return {
                      'id': doc.id,
                      'opinion': data['opinion'] ?? 'No content',
                      'votes': data['votes'] ?? 0,
                      'voters': List<String>.from(data['voters'] ?? []),
                      'userId': data['userId'] ?? "",
                    };
                  }).toList();

                  opinions.sort((a, b) => (b['votes'] as int).compareTo(a['votes'] as int));

                  if (!isVotingFinished) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: opinions.length,
                      itemBuilder: (context, index) {
                        final opinion = opinions[index];
                        final hasVoted = opinion['voters'].contains(authProviders.userId??authProviders.codeLeader);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              opinion['opinion'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[800],
                              ),
                            ),
                            subtitle: Text(
                              'Votes: ${opinion['votes']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                hasVoted ? Icons.favorite : Icons.favorite_border,
                                color: hasVoted ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                New_fire_base_set_data_for_user.upvoteOpinion(
                                  opinionId: opinion['id'],
                                  userId: authProviders.userId??authProviders.codeLeader!,
                                  governorate: authProviders.governorateUs ?? authProviders.governorate!,
                                  church: authProviders.churchCodeUs ?? authProviders.churchCodeL!,
                                  stage: authProviders.stageCodeUs ?? authProviders.stageCode!,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    final topOpinion = opinions.first;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.endVotes,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]!,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.emoji_events,
                                    color: Colors.amber,
                                    size: 36,
                                  ),
                                  title: Text(
                                    topOpinion['opinion'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Total Votes: ${topOpinion['votes']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
