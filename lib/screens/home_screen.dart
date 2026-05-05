import 'package:mexpense/services/services.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/screens/screens.dart';
import 'package:mexpense/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final LocalExpenseService firestoreService;

  const HomeScreen(this.firestoreService, {super.key});

  @override
  State<HomeScreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: index == 0 ? selectColor : unselectColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart_rounded,
                color: index == 1 ? selectColor : unselectColor,
              ),
              label: 'Stats',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpense(
                'Add',
                'Expense',
                'Food',
                '',
                '',
                widget.firestoreService,
              ),
            ),
          );
        },
        shape: CircleBorder(),
        child: AppFloatingButton(),
      ),
      body: index == 0
          ? MainScreen(widget.firestoreService)
          : VisualizationScreen(widget.firestoreService),
    );
  }
}
