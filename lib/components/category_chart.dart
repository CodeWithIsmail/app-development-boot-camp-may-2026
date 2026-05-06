import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/services/services.dart';

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
    yield* widget.firestoreService.getRecords().map((querySnapshot) {
      final Map<String, double> expenses = {for (final cat in category) cat: 0};

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
                sections: showingSections(snapshot.data!),
              ),
            ),
          );
        }
      },
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> expenses) {
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
