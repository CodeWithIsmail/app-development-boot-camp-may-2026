import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/features/transactions/providers/transaction_provider.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Map<String, dynamic>? expense; // For edit mode

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController amountCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  DateTime selected = DateTime.now();

  String transactionDropDownText = 'Expense';
  String expenseDropDownText = 'Food';

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      // Edit mode
      final expense = widget.expense!;
      transactionDropDownText = expense['title'];
      expenseDropDownText = expense['category'];
      amountCon.text = expense['amount'].toString();
      dateCon.text = expense['date'];
      selected = DateTime.fromMillisecondsSinceEpoch(expense['dateTime']);
    } else {
      dateCon.text = DateFormat('dd-MMM-yy').format(DateTime.now());
    }
  }

  var transactionType = ['Expense', 'Income'];

  List<String> get expenseType {
    if (transactionDropDownText == 'Income') {
      return ['Salary', 'Saving', 'Others'];
    } else {
      return [
        'Food',
        'Shopping',
        'Education',
        'Transport',
        'Health',
        'Entertainment',
        'Home',
        'Others',
      ];
    }
  }

  // String ExpenseDropDown = ;
  // String TransactionDropDown = 'Expense';

  void updateDropDown() {
    if (transactionDropDownText == 'Income') {
      expenseDropDownText = 'Salary';
    } else {
      expenseDropDownText = 'Food';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${widget.expense != null ? 'Edit' : 'Add'} Transaction',
                  style: addTextStyle,
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // width: MediaQuery.of(context).size.width * 0.8,
                  height: kToolbarHeight,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.list),
                      Text('Select transaction type'),
                      DropdownButton(
                        value: transactionDropDownText,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: transactionType.map((String transactionType) {
                          return DropdownMenuItem(
                            value: transactionType,
                            child: Text(transactionType),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            transactionDropDownText = newValue!;
                            updateDropDown();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // width: MediaQuery.of(context).size.width * 0.8,
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.list),
                      Text('Select $transactionDropDownText type'),
                      DropdownButton(
                        value: expenseDropDownText,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: expenseType.map((String expenseType) {
                          return DropdownMenuItem(
                            value: expenseType,
                            child: Text(expenseType),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            expenseDropDownText = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountCon,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.bangladeshiTakaSign,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: dateCon,
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () async {
                    DateTime? current = await showDatePicker(
                      context: context,
                      initialDate: selected,
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );

                    if (current != null) {
                      selected = current;
                      dateCon.text = DateFormat('dd-MMM-yy').format(current);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Date',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: FaIcon(FontAwesomeIcons.clock, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    gradient: dashboardGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final type = transactionDropDownText;
                      final category = expenseDropDownText;
                      final amount = double.parse(amountCon.text);
                      final date = dateCon.text;
                      final dateTime = selected.millisecondsSinceEpoch;

                      final expenseData = {
                        'title': type,
                        'category': category,
                        'amount': amount,
                        'date': date,
                        'dateTime': dateTime,
                      };

                      final provider = context.read<TransactionProvider>();
                      if (widget.expense != null) {
                        // Edit
                        provider.updateExpense(
                          widget.expense!['id'],
                          expenseData,
                        );
                      } else {
                        // Add
                        provider.addExpense(expenseData);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
