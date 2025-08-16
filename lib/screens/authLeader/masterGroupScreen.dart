import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../firebase/authProvider.dart';
import '../../services/attendanceStatsHelper.dart';

class MasterGroupScreen extends StatefulWidget {
  final String groupName;
  final List<String> stages;

  const MasterGroupScreen({
    super.key,
    required this.groupName,
    required this.stages,
  });

  @override
  State<MasterGroupScreen> createState() => _MasterGroupScreenState();
}

class _MasterGroupScreenState extends State<MasterGroupScreen> {
  late AuthProviders authProviders;
  late Future<List<Map<String, double>>> _statsFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStats();
  }
  void _loadStats({bool refresh = false}) {
    AuthProviders authProviders=Provider.of(context,listen: false);
    setState(() {
      _statsFuture = Future.wait(
        widget.stages.map((stage) => AttendanceStatsHelper.getAllMonthlyStats(
          governorate: authProviders.governorateMaster!,
          church: authProviders.churchCodeMaster!,
          stageCode: stage,
          forceRefresh: refresh, // نتحكم فيها من الزر
        )),
      );
    });
  }
  String getStageLabel(String code) {
    final parts = code.split("_");
    switch (parts[0]) {
      case "P":
        return "إعدادي ${parts[1]}";
      case "S":
        return "ثانوي ${parts[1]}";
      case "U":
        return "جامعة ${parts[1]}";
      default:
        return code;
    }
  }

  Color _getAvgColor(double value) {
    if (value >= 85) return const Color(0xFF43A047);
    if (value >= 70) return const Color(0xFF27AD89);
    if (value > 50) return const Color(0xFFE53935);
    if (value == 50) return const Color(0xFF1E88E5);
    return const Color(0xD4D51914);
  }

  IconData _getPerformanceIcon(double value) {
    if (value >= 85) return Icons.emoji_events;
    if (value >= 70) return Icons.check_circle;
    if (value >= 50) return Icons.warning;
    return Icons.error;
  }

  Future<void> _showRefreshDialog(BuildContext context, AuthProviders authProviders) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تحديث البيانات"),
        content: const Text("هل تريد تحديث البيانات من السحابة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceRefreshData(context, authProviders);
            },
            child: const Text("تحديث"),
          ),
        ],
      ),
    );
  }

  Future<void> _forceRefreshData(BuildContext context, AuthProviders authProviders) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("جاري تحديث البيانات...")),
      );

      // جلب البيانات الجديدة مع forceRefresh = true
      await Future.wait(
        widget.stages.map((stage) => AttendanceStatsHelper.getAllMonthlyStats(
          governorate: authProviders.governorateMaster!,
          church: authProviders.churchCodeMaster!,
          stageCode: stage,
          forceRefresh: true,
        )),
      );

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("خطأ في تحديث البيانات: $e")),
      );
    }
  }

  Future<void> _showStageDetailsDialog(BuildContext context, String stage, Map<String, double> stats) async {
    final avg = stats.values.reduce((a, b) => a + b) / stats.length;
    final absenceRate = 100 - avg;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getStageLabel(stage)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("المعدل:", style: TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  backgroundColor: _getAvgColor(avg).withOpacity(0.2),
                  label: Text(
                    "${avg.toStringAsFixed(1)}%",
                    style: TextStyle(color: _getAvgColor(avg), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("نسبة الغياب:", style: TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  label: Text(
                    "${absenceRate.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text("التفاصيل الشهرية:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final key = stats.keys.elementAt(index);
                  final value = stats.values.elementAt(index);
                  final absence = 100 - value;
                  return ListTile(
                    title: Text(key),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${value.toStringAsFixed(1)}% حضور",
                          style: TextStyle(
                            color: value >= 75 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${absence.toStringAsFixed(1)}% غياب",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسنا"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    return Scaffold(
      body: FutureBuilder<List<Map<String, double>>>(
        future:  _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ في تحميل بيانات ${widget.groupName}"));
          }

          final allStats = snapshot.data!;
          final stageAverages = <String, double>{};
          final stageAbsenceRates = <String, double>{};

          for (int i = 0; i < widget.stages.length; i++) {
            final stats = allStats[i];
            if (stats.isNotEmpty) {
              final avg = stats.values.reduce((a, b) => a + b) / stats.length;
              stageAverages[widget.stages[i]] = avg;
              stageAbsenceRates[widget.stages[i]] = 100 - avg;
            }
          }

          final sortedStages = stageAverages.entries
              .where((entry) => entry.value.isFinite && !entry.value.isNaN)
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final validAverages = stageAverages.values
              .where((v) => v.isFinite && !v.isNaN)
              .toList();

          final overallAvg = validAverages.isNotEmpty
              ? (validAverages.reduce((a, b) => a + b) / validAverages.length).toStringAsFixed(1)
              : "0";

          final overallAbsenceRate = validAverages.isNotEmpty
              ? (100 - double.parse(overallAvg)).toStringAsFixed(1)
              : "0";


          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // الكارت الرئيسي للإحصائيات العامة
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      _loadStats(refresh: true); // زر التحديث
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("جاري تحديث البيانات...")),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              Card(
                elevation: 5,
                shadowColor: Colors.blue.shade700.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.yellow.shade700),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.groupName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Chip(
                                    backgroundColor: _getAvgColor(double.parse(overallAvg)).withOpacity(0.9),
                                    label: Text(
                                      "$overallAvg% حضور",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Chip(
                                    backgroundColor: Colors.red.shade700.withOpacity(0.9),
                                    label: Text(
                                      "$overallAbsenceRate% غياب",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // عرض مراحل كل مرحلة في ExpansionTile
                          ...List.generate(widget.stages.length, (i) {
                            final stage = widget.stages[i];
                            final stats = allStats[i];

                            if (stats.isEmpty) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ExpansionTile(
                                      leading: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.no_accounts_outlined,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        getStageLabel(stage),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Column(
                                  children: stats.entries
                                      .where((entry) =>
                                  entry.value.isFinite && !entry.value.isNaN)
                                  .map((entry) {
                                final absence = 100 - entry.value;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(entry.key,
                                              style: const TextStyle(
                                                  fontSize: 14, color: Colors.grey)),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${entry.value.toStringAsFixed(1)}% حضور",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: entry.value >= 75
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                          Text(
                                            "${absence.toStringAsFixed(1)}% غياب",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            ),
                                      ],
                                    ),
                                  )
                              );
                            }

                            final avg = stageAverages[stage] ?? 0;
                            final absenceRate = 100 - avg;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () => _showStageDetailsDialog(context, stage, stats),
                                child: ExpansionTile(
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _getAvgColor(avg).withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _getPerformanceIcon(avg),
                                        color: _getAvgColor(avg),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    getStageLabel(stage),
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Column(
                                        children: stats.entries.map((entry) {
                                          final absence = 100 - entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(entry.key, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${entry.value.toStringAsFixed(1)}% حضور",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: entry.value >= 75 ? Colors.green : Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${absence.toStringAsFixed(1)}% غياب",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // رسم بياني Bar Chart
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                maxY: 100,
                                minY: 0,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        if (value.toInt() < sortedStages.length) {
                                          final stage = sortedStages[value.toInt()].key;
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              getStageLabel(stage).split(" ").last,
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      getTitlesWidget: (value, _) => Text("${value.toInt()}%", style: const TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                barGroups: List.generate(sortedStages.length, (i) {
                                  final value = sortedStages[i].value;
                                  return BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: value,
                                        color: _getAvgColor(value),
                                        borderRadius: BorderRadius.circular(4),
                                        width: 22,
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: 100,
                                          color: Colors.blue.shade900,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 0.5,
                                    dashArray: [4],
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // عرض الدوائر الإحصائية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "إحصائيات الحضور والغياب حسب المرحلة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: sortedStages.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: .85,
                ),
                itemBuilder: (context, index) {
                  if (index < sortedStages.length) {
                    final stage = sortedStages[index].key;
                    final avg = sortedStages[index].value;
                    final absenceRate = 100 - avg;
                    return InkWell(
                      onTap: () => _showStageDetailsDialog(context, stage, allStats[widget.stages.indexOf(stage)]),
                      child: _buildStageCircle(
                        context,
                        getStageLabel(stage),
                        avg,
                        _getAvgColor(avg),
                        absenceRate: absenceRate,
                      ),
                    );
                  } else {
                    return _buildStageCircle(
                      context,
                      "المعدل العام",
                      double.parse(overallAvg),
                      _getAvgColor(double.parse(overallAvg)),
                      absenceRate: double.parse(overallAbsenceRate),
                      isOverall: true,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStageCircle(
      BuildContext context,
      String title,
      double value,
      Color color, {
        double absenceRate = 0,
        bool isOverall = false,
      }) {
    return Card(
      elevation: 4,
      color: Colors.yellow.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isOverall ? Colors.blue.shade900 : Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child:CircularProgressIndicator(
                    value: (value.isNaN || value.isInfinite) ? 0.0 : value / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),

                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${value.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "${absenceRate.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendCircle(Colors.green.shade700),
                const SizedBox(width: 4),
                const Text("حضور", style: TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                _legendCircle(Colors.red.shade700),
                const SizedBox(width: 4),
                const Text("غياب", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendCircle(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}