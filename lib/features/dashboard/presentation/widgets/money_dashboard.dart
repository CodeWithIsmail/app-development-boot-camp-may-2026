import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';
import 'package:mexpense/core/widgets/widgets.dart';
import 'package:mexpense/features/dashboard/presentation/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class MoneyDashboard extends StatelessWidget {
  const MoneyDashboard({super.key});

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
              Icons.arrow_downward,
              Colors.red.shade900,
              'Expense',
              balance['Expense']!,
            ),
            BalanceShowGroup(
              Icons.arrow_upward,
              Colors.lightGreenAccent,
              'Income',
              balance['Income']!,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    if (provider.isLoading && provider.expenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return customColumn({
      'NetBalance': provider.netBalance,
      'Income': provider.incomeTotal,
      'Expense': provider.expenseTotal,
    });
  }
}
