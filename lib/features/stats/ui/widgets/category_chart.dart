import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/helper/helpers.dart';

final Map<String, String> categoryIconMap = {
  'Food': 'assets/food.png',
  'Shopping': 'assets/shopping.png',
  'Education': 'assets/education.png',
  'Transport': 'assets/transport.png',
  'Health': 'assets/health.png',
  'Entertainment': 'assets/entertainment.png',
  'Home': 'assets/home.png',
  'Others': 'assets/other.png',
};

class CategorywiseChart extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  const CategorywiseChart(this.expenses, {super.key});

  Map<String, double> getExpenses() {
    final Map<String, double> expensesMap = {
      for (final cat in category) cat: 0,
    };

    final filteredExpenses = expenses.where((expense) {
      return expense['title'] == 'Expense';
    }).toList();

    for (var expense in filteredExpenses) {
      String cate = expense['category'];
      double amount = expense['amount'] as double;
      expensesMap[cate] = (expensesMap[cate] ?? 0) + amount;
    }

    return expensesMap;
  }

  @override
  Widget build(BuildContext context) {
    final expensesData = getExpenses();

    if (expensesData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      alignment: Alignment.center,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(expensesData, context),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    Map<String, double> expenses,
    BuildContext context,
  ) {
    final List<PieChartSectionData> sections = [];
    final total = expenses.values.fold(0.0, (sum, value) => sum + value);

    if (total <= 0) {
      return sections;
    }

    for (int i = 0; i < category.length; i++) {
      final categoryName = category[i];
      final amount = expenses[categoryName] ?? 0.0;

      if (amount == 0) continue;

      final fontSize = 16.0;
      final radius = MediaQuery.of(context).size.width * 0.37;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final percentage = ((amount / total) * 100).toStringAsFixed(0);

      sections.add(
        PieChartSectionData(
          color: colorMap[categoryName]?.colors.first ?? Colors.grey,
          value: amount,
          title: '$percentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
          badgeWidget: _Badge(
            categoryIconMap[categoryName] ?? 'assets/other.png',
            size: 40.0,
          ),
          badgePositionPercentageOffset: 0.98,
        ),
      );
    }

    return sections;
  }
}

class _Badge extends StatelessWidget {
  final String assetPath;
  final double size;

  const _Badge(this.assetPath, {required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}
