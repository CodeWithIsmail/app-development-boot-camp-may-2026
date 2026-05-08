import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/data.dart';
import 'package:mexpense/features/dashboard/presentation/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class CategorywiseChart extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const CategorywiseChart({super.key, this.startDate, this.endDate});

  @override
  State<CategorywiseChart> createState() => _CategorywiseChartState();
}

class _CategorywiseChartState extends State<CategorywiseChart> {
  int? _touchedIndex;

  String _formatAmount(double a) {
    if (a % 1 == 0) return a.toInt().toString();
    return a.toStringAsFixed(2);
  }

  List<PieChartSectionData> _showingSections(
    BuildContext context,
    Map<String, double> expenses,
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

      final isSelected = _touchedIndex == i;
      final fontSize = isSelected ? 16.0 : 14.0;
      final radius = isSelected
          ? MediaQuery.of(context).size.width * 0.43
          : MediaQuery.of(context).size.width * 0.4;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final percentage = ((amount / total) * 100).toStringAsFixed(0);
      final title = isSelected ? '${_formatAmount(amount)} Tk' : '$percentage%';

      sections.add(
        PieChartSectionData(
          color: colorMap[categoryName],
          value: amount,
          title: title,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
          badgeWidget: _Badge(iconMap[categoryName]!, size: 40.0),
          badgePositionPercentageOffset: 0.98,
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = (widget.startDate == null || widget.endDate == null)
        ? provider.categoryTotals()
        : provider.categoryTotalsInRange(
            startDate: widget.startDate,
            endDate: widget.endDate,
          );

    if (expenses.isEmpty || expenses.values.every((value) => value == 0)) {
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
          sections: _showingSections(context, expenses),
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              if (response == null || response.touchedSection == null) {
                setState(() => _touchedIndex = null);
                return;
              }
              setState(
                () => _touchedIndex =
                    response.touchedSection!.touchedSectionIndex,
              );
            },
          ),
        ),
      ),
    );
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
