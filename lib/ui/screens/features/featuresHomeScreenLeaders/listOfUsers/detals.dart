import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/fireBaseSetDataForLeader.dart';
import '../../../../../model/modelUser.dart';

class Details extends StatefulWidget {
  static const String routeName ='detalse';
  final VoidCallback onCloseDetals;
  final String userId;
  final MyUser user;
  final dynamic currentWeek;

  const Details({
    super.key,
    required this.onCloseDetals,
    required this.userId,
    required this.user,
    required this.currentWeek, required String userCode,
  });

  @override
  State<Details> createState() => _DetailsState();
}


class _DetailsState extends State<Details> {
  int? selectedCardIndex;
  late int weekToUse;
  TextEditingController searchAllUser = TextEditingController();
  String searchUser = '';

  bool click = false;
  bool _isExpanded = false; // Moved to state level

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    AuthProviders authProviders = Provider.of<AuthProviders>(
      context,
      listen: false,
    );

    Provider.of<AuthProviders>(context, listen: false).readUsersToLeaders(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: authProviders.stageCode!,
    );

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthProviders authProviders = Provider.of(context);
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int? passedWeek = args?['week'];
    weekToUse = passedWeek ?? authProviders.weekUse!; // <-- هنا نعطي 1 كقيمة افتراضية إن لم توجد بيانات

  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 100),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[800]!, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildUserInfo(context),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  _buildStreamContent(authProviders),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamContent(AuthProviders authProviders) {
    return StreamBuilder<Map<String, Map<String, int>>>(
      stream: FireBaseSetDataForLeader.getAallScoresWeekStream(
        userId: widget.userId,
        weekNumber:weekToUse.toString(),
        governorate:authProviders.governorate! ,
        church:authProviders.churchCodeL! ,
        code:widget.user.code,
        stage: authProviders.stageCode!
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'حدث خطأ: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد بيانات",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final scores = snapshot.data!;
        return Column(
          children: [
            counterWeek(scores, context),
            const SizedBox(height: 20),
            _buildContent(scores, context,AuthProviders()),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),

          const SizedBox(height: 5),
          Text(
            'email : ${widget.user.email}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),

          if (_isExpanded) ...[
            Text('birth day : ${widget.user.birthDay}', style: _style()),
            Text('phone : ${widget.user.phone}', style: _style()),
            Text('university : ${widget.user.university}', style: _style()),
            Text('address : ${widget.user.address}', style: _style()),
            Text('talent : ${widget.user.talent}', style: _style()),
            Text('lack : ${widget.user.lack}', style: _style()),
          ],

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  _isExpanded ? "Show Less" : "Show More",
                  style:  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _style() => TextStyle(fontSize: 14, color: Colors.grey.shade400);

  Widget _buildWeekSelector(BuildContext context, AuthProviders authProviders) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              if (weekToUse > 1) {
                setState(() {
                  weekToUse--;

                });
              }
            },
          ),
          Text(
            'الأسبوع ${weekToUse}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
            onPressed: () {
              if (weekToUse < 48) {
                setState(() {
                  weekToUse++;

                });              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, Map<String, int>> scores, BuildContext context,AuthProviders authProviders) {
    return Column(
      children: [
        _buildWeekSelector(context, authProviders),
        const SizedBox(height: 25),

        _buildSummaryCards(scores),
        const SizedBox(height: 25),
        _buildChartsSection(scores, context),
        const SizedBox(height: 25),
        _buildDetailedTable(scores),
        const SizedBox(height: 8),
        Text(
          "Weekly: درجات الأسبوع المحدد - Total: المجموع الكلي لكل الأسابيع",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade900,
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
          child: _buildSummaryCard(
            title: 'المجموع الأسبوعي',
            value: totalWeekScore.toString(),
            icon: Icons.timeline,
            color: Colors.blue[800]!,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            title: 'المجموع',
            value: totalOverallScore.toString(),
            icon: Icons.stars,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget counterWeek(Map<String, Map<String, int>> scores, BuildContext context) {
    int totalMeeting = 0;
    int totalCommunion = 0;
    int totalMass = 0;
    int totalConfession = 0;

    scores.forEach((key, value) {
      if (key.contains('meetingScoreDB')) totalMeeting = value['totalScore'] ?? 0;
      if (key.contains('communionSummary')) totalCommunion = value['totalScore'] ?? 0;
      if (key.contains('massSummary')) totalMass = value['totalScore'] ?? 0;
      if (key.contains('confessionSummary')) totalConfession = value['totalScore'] ?? 0;
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSummaryCard(
            title: 'حضور الاجتماع',
            value: '${(totalMeeting / 25).round()}',
            icon: Icons.groups,
            color: Colors.blue[800]!,
          ),
          const SizedBox(width: 10),
          _buildSummaryCard(
            title: 'التناول',
            value: '${(totalCommunion / 25).round()}',
            icon: Icons.restaurant,
            color: Colors.teal,
          ),
          const SizedBox(width: 10),
          _buildSummaryCard(
            title: 'حضور القداس',
            value: '${(totalMass / 25).round()}',
            icon: Icons.church,
            color: Colors.purple,
          ),
          const SizedBox(width: 10),
          _buildSummaryCard(
            title: 'الاعتراف',
            value: '${(totalConfession / 25).round()}',
            icon: Icons.psychology,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(Map<String, Map<String, int>> scores, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مخطط الأداء',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.blue[800]),
                const SizedBox(width: 5),
                const Text("الأسبوعي", style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.amber),
                const SizedBox(width: 5),
                const Text("الكلي", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetailedTable(Map<String, Map<String, int>> scores) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade900),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade900),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('النوع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('الدرجة الأسبوعية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('الدرجة الكلية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ...scores.entries.map(
              (entry) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key, style: const TextStyle(color: Colors.white)),
              ),
              _buildScoreCell(entry.value['weekScore'] ?? 0),
              _buildScoreCell(entry.value['totalScore'] ?? 0),
            ],
          ),
        ),
      ],
    );
  }

  TableCell _buildScoreCell(int score, {bool isHighBetter = true}) {
    Color cellColor;
    if (isHighBetter) {
      cellColor = score > 10 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
    } else {
      cellColor = score < 5 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
    }

    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            score.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
} // Closing brace for _DetailsState class