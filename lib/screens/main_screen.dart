import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/data/repositories/auth_service.dart';
import 'package:mexpense/features/stats/ui/widgets/money_dashboard.dart';
import 'package:mexpense/features/transactions/data/repositories/local_expense_service.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/screens/add_expense_screen.dart';
import 'package:mexpense/screens/screens.dart';
import 'package:mexpense/services/services.dart';

class MainScreen extends StatefulWidget {
  final LocalExpenseService firestoreService;

  const MainScreen(this.firestoreService, {super.key});

  @override
  State<MainScreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<MainScreen> {
  void editOrDelete(LocalDocument document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          actions: <Widget>[
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Map<String, dynamic> data = document.data();
                String transactionType = data['Transaction_type'];
                String category = data['Category'];
                String date = data['date'];
                String amount = "${data['Amount']} TK";
                widget.firestoreService.deleteRecord(document.id);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpense(
                      'Edit',
                      transactionType,
                      category,
                      amount,
                      date,
                      widget.firestoreService,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                widget.firestoreService.deleteRecord(document.id);
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
                            widget.firestoreService.collectionName,
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
                          await AuthService().signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginOrRegistration(),
                            ),
                          );
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
                child: MoneyDashboard(widget.firestoreService),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Transactions', style: expensesTextStyle)],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<LocalQuerySnapshot>(
                stream: widget.firestoreService.getRecords(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('An error occurred!'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Center(child: Text('No records found.'));
                  }

                  List transactionList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: transactionList.length,
                    itemBuilder: (context, int index) {
                      LocalDocument document = transactionList[index];

                      Map<String, dynamic> data = document.data();

                      String transactionType = data['Transaction_type'];
                      String category = data['Category'];
                      String amount = "${data['Amount']} TK";
                      String date = data['date'];

                      return GestureDetector(
                        onDoubleTap: () {
                          if (category != 'Initial Balance') {
                            editOrDelete(document);
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
