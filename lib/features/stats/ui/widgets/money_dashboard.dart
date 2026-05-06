import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mexpense/features/transactions/providers/transaction_provider.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/widgets/balance_show_group.dart';
import 'package:provider/provider.dart';

class MoneyDashboard extends StatelessWidget {
  const MoneyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final netBalance = transactionProvider.netBalance;
        final totalIncome = transactionProvider.totalIncome;
        final totalExpense = transactionProvider.totalExpense;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Net Balance', style: netBalTextStyle),
            Text(netBalance.toStringAsFixed(2), style: balTextStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BalanceShowGroup(
                  CupertinoIcons.down_arrow,
                  Colors.red.shade900,
                  'Expense',
                  totalExpense.toInt(),
                ),
                BalanceShowGroup(
                  CupertinoIcons.up_arrow,
                  Colors.lightGreenAccent,
                  'Income',
                  totalIncome.toInt(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
