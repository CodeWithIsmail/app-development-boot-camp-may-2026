import 'package:flutter/material.dart';
import 'package:mexpense/components/money_dashboard.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/models/expense.dart';
import 'package:mexpense/providers/providers.dart';
import 'package:mexpense/screens/screens.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<MainScreen> {
  void editOrDelete(Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Choose an option'),
          actions: <Widget>[
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpense(
                      'Edit',
                      expense.title,
                      expense.category,
                      expense.amount.toString(),
                      expense.date,
                      expenseId: expense.id?.toString(),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await dialogContext.read<ExpenseProvider>().deleteExpense(
                  expense.id!,
                );
                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade100,
                        child: Image.asset('images/moneymate.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MoneyMate', style: welcomeTextStyle),
                          Text(
                            context.watch<UserProvider>().displayName ?? '',
                            style: nameTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await context.read<UserProvider>().signOut();
                        },
                        icon: Icon(Icons.logout_outlined, size: 23),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: dashboardGradient,
                boxShadow: [dashboardShadow],
              ),
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: const MoneyDashboard(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Transactions', style: expensesTextStyle)],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child) {
                  final expenses = expenseProvider.expenses;

                  if (expenseProvider.isLoading && expenses.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (expenses.isEmpty) {
                    return Center(child: Text('No records found.'));
                  }

                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, int index) {
                      final expense = expenses[index];
                      final transactionType = expense.title;
                      final category = expense.category;
                      final amount = '${expense.amount} TK';
                      final date = expense.date;

                      return GestureDetector(
                        onDoubleTap: () {
                          if (category != 'Initial Balance') {
                            editOrDelete(expense);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 7,
                            top: 7,
                            left: 4,
                            right: 6,
                          ),
                          child: Container(
                            decoration: expenseTileDecoration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.tealAccent.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        width: 45,
                                        height: 45,
                                        alignment: Alignment.center,

                                        child: iconMap[category],
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        category,
                                        style: expenseTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            amount,
                                            style: expenseValTextStyle,
                                          ),
                                          Text(
                                            date,
                                            style: expenseDayTextStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                        child: iconType[transactionType],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
