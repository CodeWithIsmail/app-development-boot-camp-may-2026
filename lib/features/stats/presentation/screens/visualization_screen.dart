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
  DateFormat dateFormat = DateFormat('dd MMM yy');
  String stDate = "";
  String enDate = "";

  @override
  void initState() {
    endDate = DateTime.now();
    startDate = endDate.subtract(Duration(days: 14));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stDate = dateFormat.format(startDate);
    enDate = dateFormat.format(endDate);
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date - Expense Bar Chart', style: transactionTextStyle),
              SizedBox(height: 10),
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

                      // print(stDate);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 20,
                  ),
                  child: DatewiseChart(endDate),
                ),
              ),
              SizedBox(height: 50),
              Text('Category - Expense Pie Chart', style: transactionTextStyle),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 20,
                  ),
                  child: const CategorywiseChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
