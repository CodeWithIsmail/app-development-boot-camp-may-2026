import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mexpense/features/transactions/providers/transaction_provider.dart';
import 'package:mexpense/features/auth/providers/auth_provider.dart';
import 'package:mexpense/features/transactions/ui/screens/add_expense_screen.dart';
import 'package:mexpense/features/stats/ui/widgets/money_dashboard.dart';
import 'package:mexpense/helper/helpers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<MainScreen> {
  void editOrDelete(Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          actions: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                // For edit, navigate to add screen with data
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(expense: expense),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                context.read<TransactionProvider>().deleteExpense(
                  expense['id'],
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionProvider, AuthProvider>(
      builder: (context, transactionProvider, authProvider, child) {
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
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MoneyMate', style: welcomeTextStyle),
                              Text(
                                authProvider.currentUserId?.toString() ?? '',
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
                              await authProvider.signOut();
                              // Navigation handled by app.dart
                            },
                            icon: const Icon(Icons.logout_outlined, size: 23),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: dashboardGradient,
                    boxShadow: [dashboardShadow],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(17.0),
                    child: MoneyDashboard(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Transactions', style: expensesTextStyle)],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: transactionProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : transactionProvider.expenses.isEmpty
                      ? const Center(child: Text('No records found.'))
                      : ListView.builder(
                          itemCount: transactionProvider.expenses.length,
                          itemBuilder: (context, int index) {
                            Map<String, dynamic> expense =
                                transactionProvider.expenses[index];

                            String transactionType = expense['title'];
                            String category = expense['category'];
                            String amount = "${expense['amount']} TK";
                            String date = expense['date'];

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
                                                color: Colors.tealAccent
                                                    .withValues(alpha: 0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              width: 45,
                                              height: 45,
                                              alignment: Alignment.center,
                                              child: iconMap[category],
                                            ),
                                            const SizedBox(width: 10),
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
                                            const SizedBox(width: 10),
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.grey
                                                  .withValues(alpha: 0.2),
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
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
