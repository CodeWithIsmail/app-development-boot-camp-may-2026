import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/helper/helpers.dart';

class DatewiseChart extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final DateTime endDate;

  const DatewiseChart(this.expenses, this.endDate, {super.key});

  Map<String, double> getExpenses() {
    DateTime now = endDate;
    DateTime fifteenDaysAgo = now.subtract(const Duration(days: 15));
    DateFormat dayFormat = DateFormat('dd');
    Map<String, double> expensesMap = {};

    for (int i = 14; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      expensesMap[dayFormat.format(date)] = 0;
    }

    final filteredExpenses = expenses.where((expense) {
      DateTime docDate = DateTime.fromMillisecondsSinceEpoch(
        expense['dateTime'],
      );
      return (docDate.isAfter(fifteenDaysAgo) ||
              docDate.isAtSameMomentAs(fifteenDaysAgo)) &&
          docDate.isBefore(now.add(const Duration(days: 1))) &&
          expense['title'] == 'Expense';
    }).toList();

    for (var expense in filteredExpenses) {
      DateTime docDate = DateTime.fromMillisecondsSinceEpoch(
        expense['dateTime'],
      );
      String day = dayFormat.format(docDate);
      double amount = expense['amount'] as double;
      expensesMap[day] = (expensesMap[day] ?? 0) + amount;
    }

    return expensesMap;
  }

  @override
  Widget build(BuildContext context) {
    final expensesData = getExpenses();

    if (expensesData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return BarChart(mainBarChartData(expensesData));
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
