import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/services/services.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/widgets/widgets.dart';

class MoneyDashboard extends StatefulWidget {
  final LocalExpenseService firestoreService;

  const MoneyDashboard(this.firestoreService, {super.key});

  @override
  State<MoneyDashboard> createState() => _MoneyDashboardState();
}

class _MoneyDashboardState extends State<MoneyDashboard> {
  late Stream<Map<String, int>> balanceDataStream;

  @override
  void initState() {
    super.initState();
    balanceDataStream = getExpensesStream();
  }

  Stream<Map<String, int>> getExpensesStream() async* {
    int income = 0;
    int expense = 0;
    int netBal = 0;
    yield* widget.firestoreService.getRecords().map((querySnapshot) {
      income = 0;
      expense = 0;
      netBal = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        String cate = data['Transaction_type'];
        double amount = double.tryParse(data['Amount'].toString()) ?? 0.0;
        if (cate == 'Expense') {
          expense += amount.toInt();
        } else {
          income += amount.toInt();
        }
      }
      netBal = income - expense;
      return {'NetBalance': netBal, 'Income': income, 'Expense': expense};
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: balanceDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          return customColumn(snapshot.data!.cast<String, int>());
        }
      },
    );
  }

  Column customColumn(Map<String, int> balance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Net Balance', style: netBalTextStyle),
        Text(balance['NetBalance'].toString(), style: balTextStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BalanceShowGroup(
              CupertinoIcons.down_arrow,
              Colors.red.shade900,
              'Expense',
              balance['Expense']!,
            ),
            BalanceShowGroup(
              CupertinoIcons.up_arrow,
              Colors.lightGreenAccent,
              'Income',
              balance['Income']!,
            ),
          ],
        ),
      ],
    );
  }
}
