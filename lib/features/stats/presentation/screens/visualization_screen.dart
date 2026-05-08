import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/core/constants/constants.dart';
import 'package:mexpense/features/stats/presentation/widgets/category_chart.dart';
import 'package:mexpense/features/stats/presentation/widgets/datewise_chart.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({super.key});

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  late DateTime endDate;
  late DateTime startDate;
  final DateFormat dateFormat = DateFormat('dd MMM yy');

  @override
  void initState() {
    endDate = DateTime.now();
    startDate = endDate.subtract(Duration(days: 14));
    super.initState();
  }

  String get stDate => dateFormat.format(startDate);

  String get enDate => dateFormat.format(endDate);

  Widget _buildDateExpenseTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    endDate = endDate.subtract(Duration(days: 15));
                    startDate = startDate.subtract(Duration(days: 15));
                  });
                },
                icon: Icon(Icons.keyboard_arrow_left),
              ),
              Text('$stDate - $enDate'),
              IconButton(
                onPressed: () {
                  DateTime temp = DateTime.now();
                  String newTemp = dateFormat.format(temp);
                  if (newTemp != enDate) {
                    setState(() {
                      endDate = endDate.add(Duration(days: 15));
                      startDate = startDate.add(Duration(days: 15));
                    });
                  }
                },
                icon: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
              child: DatewiseChart(endDate),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? catStartDate;
  DateTime? catEndDate;
  Widget _buildCategoryExpenseTab(BuildContext context) {
    final label = (catStartDate != null && catEndDate != null)
        ? '${dateFormat.format(catStartDate!)} - ${dateFormat.format(catEndDate!)}'
        : 'All Time';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Filter by date range',
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    initialEntryMode: DatePickerEntryMode.input,
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    initialDateRange:
                        (catStartDate != null && catEndDate != null)
                        ? DateTimeRange(start: catStartDate!, end: catEndDate!)
                        : null,
                  );
                  if (picked != null) {
                    setState(() {
                      catStartDate = picked.start;
                      catEndDate = picked.end;
                    });
                  }
                },
                icon: Icon(Icons.filter_list),
              ),
              SizedBox(width: 8),
              Text(label),
              Spacer(),
              if (catStartDate != null && catEndDate != null)
                IconButton(
                  tooltip: 'Clear range',
                  onPressed: () {
                    setState(() {
                      catStartDate = null;
                      catEndDate = null;
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: CategorywiseChart(
              startDate: catStartDate,
              endDate: catEndDate,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Text('Expense Visualization', style: expensesTextStyle),
              TabBar(
                tabAlignment: TabAlignment.center,
                labelColor: selectColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: selectColor,
                tabs: const [
                  Tab(text: 'Date - Expense'),
                  Tab(text: 'Category - Expense'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildDateExpenseTab(context),
                    _buildCategoryExpenseTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
