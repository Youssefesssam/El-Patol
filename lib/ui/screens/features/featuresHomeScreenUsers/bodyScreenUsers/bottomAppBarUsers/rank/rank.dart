import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import '../../../../../utilites/appAssets.dart';

class RankPage extends StatefulWidget {
  static const String routeName = 'rank';
  const RankPage({Key? key}) : super(key: key);

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<Map<String, dynamic>> userRanks = [];
  Map<String, dynamic>? currentUserData;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final CollectionReference usersRef = FirebaseFirestore.instance
          .collection("governorate")
          .doc("Suez")
          .collection("church")
          .doc("102")
          .collection("users_church")
          .doc("P_3")
          .collection("users");

      final QuerySnapshot usersSnapshot = await usersRef.get();

      List<Future<Map<String, dynamic>?>> futures = [];

      for (var userDoc in usersSnapshot.docs) {
        final String userId = userDoc.id;
        final CollectionReference userCollection = usersRef.doc(userId).collection("user");

        futures.add(
          userCollection.get().then((subUsersSnapshot) async {
            for (var subUserDoc in subUsersSnapshot.docs) {
              final DocumentReference scoreRef = userCollection
                  .doc(subUserDoc.id)
                  .collection("summary")
                  .doc("score");

              final DocumentSnapshot scoreDoc = await scoreRef.get();

              int totalScore = scoreDoc.exists && scoreDoc.data() != null
                  ? (scoreDoc.data() as Map<String, dynamic>)['totalScore'] ?? 0
                  : 0;

              final userData = subUserDoc.data() as Map<String, dynamic>;

              return {
                'id': userId,
                'name': userData['name'] ?? 'Unknown',
                'score': totalScore,
                'profileUrl': userData['profileUrl'] ?? '',
              };
            }
            return null;
          }),
        );
      }

      final List<Map<String, dynamic>?> results = await Future.wait(futures);
      userRanks = results.whereType<Map<String, dynamic>>().toList();
      userRanks.sort((a, b) => b['score'].compareTo(a['score']));

      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        for (var user in userRanks) {
          if (user['id'] == currentUser.uid) {
            currentUserData = user;
            break;
          }
        }
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error fetching $e');
    }
  }

  int getUserRank(String userId) {
    final index = userRanks.indexWhere((u) => u['id'] == userId);
    return index != -1 ? index + 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '🏆  Ranking',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: Lottie.asset(AppAssets.loder))
          : RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              _buildPodiumNewStyle(),
              const SizedBox(height: 16),
              if (currentUserData != null) _buildUserRankHighlight(),
              const SizedBox(height: 16),
              if (currentUserData != null) _buildCurrentUserCardNew(),
              const SizedBox(height: 16),
              ...userRanks.asMap().entries.map((entry) {
                int index = entry.key;
                var user = entry.value;
                return _buildUserRankCard(user, index + 1);
              }),
              if (userRanks.isEmpty)
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Lottie.asset(AppAssets.achivement, height: 120),
                    const SizedBox(height: 20),
                    Text(
                      "لا يوجد مستخدمين بعد!",
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumNewStyle() {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (userRanks.length > 1) _podiumItem(userRanks[1], 2, AppAssets.silver),
                const SizedBox(width: 20),
                if (userRanks.isNotEmpty) _podiumItem(userRanks[0], 1, AppAssets.gold),
                const SizedBox(width: 20),
                if (userRanks.length > 2) _podiumItem(userRanks[2], 3, AppAssets.bronze),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumItem(Map<String, dynamic> user, int position, String medalAsset) {
    return Column(
      children: [
        CircleAvatar(
          radius: position == 1 ? 50 : 40,
          backgroundImage: user['profileUrl'].isNotEmpty
              ? NetworkImage(user['profileUrl'])
              : AssetImage(AppAssets.profile) as ImageProvider,
        ),
        const SizedBox(height: 8),
        Text(
          '${user['score']} pts',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          user['name'],
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCurrentUserCardNew() {
    final rank = getUserRank(currentUserData!['id']);
    final score = currentUserData!['score'];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: currentUserData!['profileUrl']?.isNotEmpty == true
                ? NetworkImage(currentUserData!['profileUrl'])
                : AssetImage(AppAssets.profile) as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUserData!['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your Score: $score',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
          ),
          Chip(
            label: Text('#$rank', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.orangeAccent,
          )
        ],
      ),
    );
  }

  Widget _buildUserRankCard(Map<String, dynamic> user, int rank) {
    bool isCurrentUser = currentUserData != null && user['id'] == currentUserData!['id'];
    return Card(
      elevation: 2,
      color: isCurrentUser ? const Color(0xFFFFF3E0) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user['profileUrl'].isNotEmpty
              ? NetworkImage(user['profileUrl'])
              : AssetImage(AppAssets.profile) as ImageProvider,
          radius: 25,
        ),
        title: Text(user['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text('${user['score']} points', style: const TextStyle(color: Colors.grey)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#$rank',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildUserRankHighlight() {
    final rank = getUserRank(currentUserData!['id']);
    final score = currentUserData!['score'];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: currentUserData!['profileUrl']?.isNotEmpty == true
                ? NetworkImage(currentUserData!['profileUrl'])
                : AssetImage(AppAssets.profile) as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUserData!['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Score: $score pts',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text('Rank', style: TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}