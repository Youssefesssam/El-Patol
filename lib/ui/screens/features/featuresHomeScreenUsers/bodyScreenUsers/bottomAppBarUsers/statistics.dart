import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../../services/localScoresCacheHelper.dart';
import '../../../../utilites/appAssets.dart';

class Statistics extends StatefulWidget {
  static const String routeName = "statistics";
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  // ألوان متسقة للتطبيق
  final Color _primaryColor = Colors.blue.shade800;
  final Color _secondaryColor = Colors.blue.shade600;
  final Color _accentColor = Colors.blueAccent.shade400;
  final Color _lightBackground = Colors.blue.shade50;
  final Color _textColor = Colors.blue.shade900;
  final Color _textOnPrimary = Colors.white;
  final Color _successColor = Colors.green.shade600;
  final Color _warningColor = Colors.red;
  final Color _cardBackground = Colors.white;

  bool _isExpanded = false;
  Map<String, Map<String, int>>? _cachedScores;
  int? _cachedWeek;

  final Map<String, String> arabicTranslations = {
    'meetingScoreDB': 'حضور الاجتماع',
    'communionSummary': 'التناول',
    'massSummary': 'حضور القداس',
    'confessionSummary': 'الاعتراف',
    'weekScore': 'الدرجة الأسبوعية',
    'totalScore': 'المجموع الكلي',
    'Weekly': 'أسبوعي',
    'Total': 'كلي',
    'Performance Chart': 'مخطط الأداء',
  };

  Future<Map<String, Map<String, int>>> _fetchScores(AuthProviders authProviders) async {
    if (_cachedScores != null && _cachedWeek == authProviders.weekUse) {
      return _cachedScores!;
    }

    final weekStr = authProviders.weekUse!.toString();

    // ✅ حاول تجيب البيانات من SharedPreferences
    final localData = await LocalScoresCacheHelper.getWeekScoresLocally(weekStr);
    if (localData != null) {
      _cachedScores = localData;
      _cachedWeek = authProviders.weekUse;
      return localData;
    }

    // ❌ لو مش موجود محلي، جيب من Firebase
    final firebaseData = await New_fire_base_set_data_for_leader.getAllScoresForWeekOnce(
      userId: authProviders.userId!,
      weekNumber: weekStr,
      code: authProviders.codeUs!,
      church: authProviders.churchCodeUs!,
      governorate: authProviders.governorateUs!,
      stage: authProviders.stageCodeUs!,
    );

    // 💾 خزن البيانات محليًا
    await LocalScoresCacheHelper.saveWeekScoresLocally(
      weekNumber: weekStr,
      scores: firebaseData,
    );

    _cachedScores = firebaseData;
    _cachedWeek = authProviders.weekUse;
    return firebaseData;
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);

    return Scaffold(
      backgroundColor: _lightBackground,
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(authProviders.profileURl ?? AppAssets.user),
                  radius: 32,
                  backgroundColor: _primaryColor,
                ),
                const SizedBox(width: 10),
                Text(
                  authProviders.name ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserInfo(context),
                    const SizedBox(height: 20),
                    _buildFutureContent(authProviders),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureContent(AuthProviders authProviders) {
    return FutureBuilder<Map<String, Map<String, int>>>(
      future: _fetchScores(authProviders),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _primaryColor));
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}', style: TextStyle(color: _textColor)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("لا توجد بيانات", style: TextStyle(color: _textColor)));
        }

        final scores = snapshot.data!;
        return Column(
          children: [
            counterWeek(scores, context),
            const SizedBox(height: 20),
            _buildContent(scores, context),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);
    return Card(
      elevation: 6,
      color: _primaryColor,
      shadowColor: _accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authProviders.name ?? '',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textOnPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text('البريد: ${authProviders.email}', style: _style()),
            if (_isExpanded) ...[
              Text('الهاتف: ${authProviders.phone}', style: _style()),
              Text('العنوان: ${authProviders.address}', style: _style()),
            ],
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _isExpanded ? "إظهار أقل" : "إظهار المزيد",
                    style: GoogleFonts.cairo(color: _textOnPrimary),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: _textOnPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _style() => GoogleFonts.cairo(
    fontSize: 14,
    color: _textOnPrimary,
  );

  Widget _buildWeekSelector(BuildContext context, AuthProviders authProviders) {
    return Card(
      elevation: 3,
      color: _primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: _textOnPrimary),
              onPressed: () {
                if (authProviders.weekUse! > 1) {
                  authProviders.setWeek(authProviders.weekUse! - 1);
                }
              },
            ),
            Text(
              'الأسبوع ${authProviders.weekUse}',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textOnPrimary,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: _textOnPrimary),
              onPressed: () {
                if (authProviders.weekUse! < 52) {
                  authProviders.setWeek(authProviders.weekUse! + 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, Map<String, int>> scores, BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);
    return Column(
      children: [
        _buildWeekSelector(context, authProviders),
        const SizedBox(height: 20),
        _buildSummaryCards(scores),
        const SizedBox(height: 20),
        _buildChartsSection(scores, context),
        const SizedBox(height: 20),
        _buildDetailedTable(scores),
        const SizedBox(height: 8),
        Text(
          "Weekly: درجات الأسبوع المحدد - Total: المجموع الكلي لكل الأسابيع",
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: _textColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(Map<String, Map<String, int>> scores) {
    int totalWeekScore = 0;
    int totalOverallScore = 0;

    scores.forEach((key, value) {
      totalWeekScore += value['weekScore'] ?? 0;
      totalOverallScore += value['totalScore'] ?? 0;
    });

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard('المجموع الأسبوعي', '$totalWeekScore', Icons.timeline, _primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard('المجموع الكلي', '$totalOverallScore', Icons.stars, _primaryColor),
        ),
      ],
    );
  }

  Widget counterWeek(Map<String, Map<String, int>> scores, BuildContext context) {
    int totalMeeting = 0, totalCommunion = 0, totalMass = 0, totalConfession = 0;

    scores.forEach((key, value) {
      if (key.contains('meetingScoreDB')) totalMeeting = value['totalScore'] ?? 0;
      if (key.contains('communionSummary')) totalCommunion = value['totalScore'] ?? 0;
      if (key.contains('massSummary')) totalMass = value['totalScore'] ?? 0;
      if (key.contains('confessionSummary')) totalConfession = value['totalScore'] ?? 0;
    });

    final week = Provider.of<AuthProviders>(context).weekUse!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSummaryCardForDetails(arabicTranslations['meetingScoreDB']!, '${(totalMeeting / 25).round()}', Icons.groups, _primaryColor, week),
          const SizedBox(width: 10),
          _buildSummaryCardForDetails(arabicTranslations['communionSummary']!, '${(totalCommunion / 25).round()}', Icons.restaurant, _primaryColor, week),
          const SizedBox(width: 10),
          _buildSummaryCardForDetails(arabicTranslations['massSummary']!, '${(totalMass / 25).round()}', Icons.church, _primaryColor, week),
          const SizedBox(width: 10),
          _buildSummaryCardForDetails(arabicTranslations['confessionSummary']!, '${(totalConfession / 25).round()}', Icons.psychology, _primaryColor, week),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 6,
      color: _cardBackground,
      shadowColor: _accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.cairo(fontSize: 14, color: _textColor)),
            const SizedBox(height: 5),
            Text(value, style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardForDetails(String title, String value, IconData icon, Color color, int week) {
    return Card(
      elevation: 4,
      color: _cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.cairo(fontSize: 14, color: _textColor)),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
                Text(' / $week', style: GoogleFonts.cairo(
                  fontSize: 20,
                  color: _textColor.withOpacity(0.7),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(Map<String, Map<String, int>> scores, BuildContext context) {
    return Card(
      elevation: 4,
      color: _cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              arabicTranslations['Performance Chart']!,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [
                  Icon(Icons.bar_chart, color: _primaryColor),
                  Text(' أسبوعي', style: GoogleFonts.cairo(color: _textColor))
                ]),
                Row(children: [
                  Icon(Icons.show_chart, color: _secondaryColor),
                  Text(' كلي', style: GoogleFonts.cairo(color: _textColor))
                ]),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTable(Map<String, Map<String, int>> scores) {
    return Card(
      elevation: 4,
      color: _cardBackground,
      child: Table(
        border: TableBorder.all(color: _accentColor.withOpacity(0.3)),
        children: [
          TableRow(
            decoration: BoxDecoration(color: _primaryColor),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'النوع',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: _textOnPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'الدرجة الأسبوعية',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: _textOnPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'الدرجة الكلية',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: _textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
          ...scores.entries.map((entry) {
            return TableRow(
              decoration: BoxDecoration(color: _cardBackground),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    arabicTranslations[entry.key] ?? entry.key,
                    style: GoogleFonts.cairo(color: _textColor),
                  ),
                ),
                _buildScoreCell(entry.value['weekScore'] ?? 0),
                _buildScoreCell(entry.value['totalScore'] ?? 0),
              ],
            );
          }),
        ],
      ),
    );
  }

  TableCell _buildScoreCell(int score) {
    Color cellColor = score >= 10 ? _successColor : _warningColor;

    return TableCell(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: cellColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          score.toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}