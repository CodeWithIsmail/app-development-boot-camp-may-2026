import 'package:flutter/material.dart';
import 'package:mexpense/core/utils/helpers.dart';
import 'package:mexpense/core/widgets/widgets.dart';
import 'package:mexpense/features/dashboard/presentation/screens/add_expense_screen.dart';
import 'package:mexpense/features/dashboard/presentation/screens/main_screen.dart';
import 'package:mexpense/features/stats/presentation/screens/visualization_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
              builder: (context) =>
                  AddExpense('Add', 'Expense', 'Food', '', ''),
            ),
          );
        },
        shape: CircleBorder(),
        child: AppFloatingButton(),
      ),
      body: index == 0 ? const MainScreen() : const VisualizationScreen(),
    );
  }
}
