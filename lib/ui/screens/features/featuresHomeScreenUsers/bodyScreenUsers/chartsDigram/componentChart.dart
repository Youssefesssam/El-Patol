import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../firebase/authProvider.dart';
import '../bottomAppBarUsers/statistcsViewModel.dart';
import 'package:fl_chart/fl_chart.dart';

class ComponentChart extends StatefulWidget {
  static const String routeName = "componentChart";
  var selectedmonth;

  ComponentChart({super.key, this.selectedmonth = 0});

  @override
  State<ComponentChart> createState() => _ComponentChartState();
}

class _ComponentChartState extends State<ComponentChart> {
  Future<List<int>> fetchWeeklyScores(StatisticsViewModel statisticsViewModel) async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    return [
      4,
      await statisticsViewModel.getStatisticsCircle('score', '1', widget.selectedmonth.toString(),authProviders.userId!).first,
      await statisticsViewModel.getStatisticsCircle('score', '1', widget.selectedmonth.toString(),authProviders.userId!).first,
      await statisticsViewModel.getStatisticsCircle('score', '1', widget.selectedmonth.toString(),authProviders.userId!).first,
    ];
  }

  @override
  Widget build(BuildContext context) {
    StatisticsViewModel statisticsViewModel = Provider.of<StatisticsViewModel>(context, listen: false);

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
        aspectRatio: 1,
        child: FutureBuilder<List<int>>(
          future: fetchWeeklyScores(statisticsViewModel),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Data Available"));
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
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: const TextStyle(color: Colors.teal));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return const Text('القداس', style: TextStyle(color: Colors.teal));
                  case 2:
                    return const Text('التناول', style: TextStyle(color: Colors.teal));
                  case 3:
                    return const Text('الاعتراف', style: TextStyle(color: Colors.teal));
                  case 4:
                    return const Text('الاجتماع', style: TextStyle(color: Colors.teal));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(enabled: true),
        groupsSpace: 10,
        barGroups: List.generate(4, (index) {
          return BarChartGroupData(x: index + 1, barRods: [
            BarChartRodData(
             // toY: fetchedData[index].toDouble(),
              toY: 40,
              fromY: 0,
              width: 7,
              color: Colors.teal,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6)),
            ),
          ]);
        }),
      ),
    );
  }
}
