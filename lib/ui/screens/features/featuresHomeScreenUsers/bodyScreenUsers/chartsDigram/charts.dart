import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../firebase/authProvider.dart';
import '../bottomAppBarUsers/statistcsViewModel.dart';
import 'package:fl_chart/fl_chart.dart';

class Charts extends StatefulWidget {
  static const String routeName = "charts";

  Charts({super.key, this.selectMonth});
  final selectMonth;

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  Future<List<int>> fetchWeeklyScores(
      StatisticsViewModel statisticsViewModel,
      int selectMonth,
      ) async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);
    final userId = authProviders.userId;

    if (userId == null) {
      throw Exception("⚠️ User ID is null. Cannot fetch statistics.");
    }

    final data = await statisticsViewModel.getStatsForMonth(selectMonth, userId);
    print("✅ بيانات الأسابيع: $data");
    return data;
  }

  @override
  Widget build(BuildContext context) {
    StatisticsViewModel statisticsViewModel = Provider.of<StatisticsViewModel>(context, listen: false);
    int selectMonth = widget.selectMonth;

    return Container(
      padding: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 0),
      margin: const EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 4,
        child: FutureBuilder<List<int>>(
          future: fetchWeeklyScores(statisticsViewModel, selectMonth),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "حدث خطأ أثناء تحميل البيانات:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("لا توجد بيانات متاحة"));
            }

            List<int> fetchedData = snapshot.data!;
            return buildBarChart(fetchedData);
          },
        ),
      ),
    );
  }

  Widget buildBarChart(List<int> fetchedData) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          border: const Border(
            top: BorderSide.none,
            right: BorderSide.none,
            left: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 30,
              interval: 20,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: TextStyle(color: Colors.blue.shade900));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return Text('W1', style: TextStyle(color: Colors.blue.shade900));
                  case 2:
                    return Text('W2', style: TextStyle(color: Colors.blue.shade900));
                  case 3:
                    return Text('W3', style: TextStyle(color: Colors.blue.shade900));
                  case 4:
                    return Text('W4', style: TextStyle(color: Colors.blue.shade900));
                  default:
                    return Text('');
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(enabled: true),
        maxY: 160,
        groupsSpace: 10,
        barGroups: List.generate(fetchedData.length, (index) {
          return BarChartGroupData(x: index + 1, barRods: [
            BarChartRodData(
              toY: fetchedData[index].toDouble(),
              fromY: 0,
              width: 7,
              color: Colors.blue.shade900,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
            ),
          ]);
        }),
      ),
    );
  }
}
