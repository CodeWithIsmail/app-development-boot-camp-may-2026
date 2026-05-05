import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/services/services.dart';

class CategorywiseChart extends StatefulWidget {
  final LocalExpenseService firestoreService;

  const CategorywiseChart(this.firestoreService, {super.key});

  @override
  State<CategorywiseChart> createState() => _CategorywiseChartState();
}

class _CategorywiseChartState extends State<CategorywiseChart> {
  late Stream<Map<String, double>> _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = getExpensesStream();
  }

  Stream<Map<String, double>> getExpensesStream() async* {
    // DateTime now = DateTime.now();
    // DateTime fifteenDaysAgo = now.subtract(Duration(days: 15));
    // DateFormat dateFormat = DateFormat('dd-MMM-yy');
    Map<String, double> expenses = {};

    for (String category in category) {
      expenses[category] = 0;
    }

    yield* widget.firestoreService.getRecords().map((querySnapshot) {
      final filteredDocs = querySnapshot.docs.where((doc) {
        return doc.data()['Transaction_type'] == 'Expense';
      }).toList();

      for (var doc in filteredDocs) {
        String cate = doc.data()['Category'];
        double amount = double.tryParse(doc.data()['Amount'].toString()) ?? 0.0;
        expenses[cate] = (expenses[cate] ?? 0) + amount;
      }

      return expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: _expensesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          return BarChart(mainBarChartData(snapshot.data!));
        }
      },
    );
  }

  BarChartData mainBarChartData(Map<String, double> expenses) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < expenses.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: 10,
              toY: expenses[category[i]]!,
              gradient: barGradient,
            ),
          ],
        ),
      );
    }

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
    String text = category[value.toInt()];
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
