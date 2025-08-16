import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../utilites/appColors.dart';

class Answers extends StatefulWidget {
  static const String routeName = 'answers';

  const Answers({super.key});

  @override
  State<Answers> createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
  Map<int, bool> expandedState = {};

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.backGround,
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Answers",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 15,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: New_fire_base_get_data_for_leader.receiveAnswers(
            governorate: authProviders.governorate!,
            church: authProviders.churchCodeL!,
            stage: authProviders.stageCode!,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No answers yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              );
            }

            final answers = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                expandedState.putIfAbsent(index, () => false);
                final answerText = answers[index]['answer'] ?? "No answer";
                final isLong = answerText.length > 100;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 10,
                  shadowColor: Colors.teal.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(Icons.person, color: Colors.blue.shade700, size: 30),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                answers[index]['sender'] ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 20, color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: expandedState[index]!
                                        ? answerText
                                        : (isLong ? "${answerText.substring(0, 80)}..." : answerText),
                                  ),
                                  if (isLong)
                                    TextSpan(
                                      text: expandedState[index]! ? " less" : "...more",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            expandedState[index] = !expandedState[index]!;
                                          });
                                        },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
