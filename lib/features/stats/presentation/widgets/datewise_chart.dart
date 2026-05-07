import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/core/utils/helpers.dart';
import 'package:mexpense/features/dashboard/presentation/providers/providers.dart';
import 'package:provider/provider.dart';

class DatewiseChart extends StatelessWidget {
  final DateTime startdate;

  const DatewiseChart(this.startdate, {super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().dailyTotals(startdate);

    if (expenses.isEmpty || expenses.values.every((value) => value == 0)) {
      return const Center(child: Text('No data available'));
    }

    return BarChart(mainBarChartData(expenses));
  }

  BarChartData mainBarChartData(Map<String, double> expenses) {
    List<BarChartGroupData> barGroups = [];

    expenses.forEach((key, value) {
      int date = int.parse(key);
      double amount = value;
      barGroups.add(
        BarChartGroupData(
          x: date,
          barRods: [
            BarChartRodData(width: 10, toY: amount, gradient: barGradient),
          ],
        ),
      );
    });

    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 60,
            showTitles: true,
            getTitlesWidget: leftTitles,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      barGroups: barGroups,
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    String text = value.toInt().toString();
    return SideTitleWidget(
      meta: meta,
      space: 2,
      child: Text(text, style: barChartBottomStyle),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text = value.toInt().round().toString();
    return SideTitleWidget(
      meta: meta,
      space: 2,
      child: Text(text, style: barChartLeftStyle),
    );
  }
}
