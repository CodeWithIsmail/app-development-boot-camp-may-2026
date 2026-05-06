import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/helper/helpers.dart';
import 'package:mexpense/services/services.dart';

class AddExpense extends StatefulWidget {
  final LocalExpenseService firestoreService;
  String expenseDropDownText;
  String transactionDropDownText;
  final String amount;
  final String date;
  final String title;

  AddExpense(
    this.title,
    this.transactionDropDownText,
    this.expenseDropDownText,
    this.amount,
    this.date,
    this.firestoreService, {
    super.key,
  });

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController amountCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  DateTime selected = DateTime.now();

  @override
  void initState() {
    if (widget.title == 'Edit') {
      dateCon.text = widget.date;
      String input = widget.amount;
      String amount = input.substring(0, input.indexOf(' '));
      amountCon.text = amount;
    } else {
      dateCon.text = DateFormat('dd-MMM-yy').format(DateTime.now());
    }
    super.initState();
  }

  var transactionType = ['Expense', 'Income'];

  var expenseType = [
    'Food',
    'Shopping',
    'Education',
    'Transport',
    'Health',
    'Entertainment',
    'Home',
    'Others',
  ];
  var incomeType = ['Salary', 'Saving', 'Others'];

  // String ExpenseDropDown = ;
  // String TransactionDropDown = 'Expense';

  void updateDropDown() {
    if (widget.transactionDropDownText == 'Income') {
      widget.expenseDropDownText = 'Salary';
      expenseType = ['Salary', 'Saving', 'Others'];
    } else {
      widget.expenseDropDownText = 'Health';
      expenseType = [
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
                Text('${widget.title} Transaction', style: addTextStyle),
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
                        value: widget.transactionDropDownText,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: transactionType.map((String transactionType) {
                          return DropdownMenuItem(
                            value: transactionType,
                            child: Text(transactionType),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            widget.transactionDropDownText = newValue!;
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
                      Text('Select ${widget.transactionDropDownText} type'),
                      DropdownButton(
                        value: widget.expenseDropDownText,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: expenseType.map((String expenseType) {
                          return DropdownMenuItem(
                            value: expenseType,
                            child: Text(expenseType),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            widget.expenseDropDownText = newValue!;
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
                      String type = widget.transactionDropDownText;
                      String category = widget.expenseDropDownText;
                      int amount = int.parse(amountCon.text.toString());
                      String date = dateCon.text;

                      DateTime parsedDate = DateFormat("dd-MMM-yy").parse(date);
                      DateTime finalDateTime = DateTime(
                        parsedDate.year,
                        parsedDate.month,
                        parsedDate.day,
                        0,
                        0,
                        0,
                        0, // Millisecond
                      );
                      widget.firestoreService.addRecord(
                        type,
                        category,
                        amount,
                        date,
                        finalDateTime,
                      );

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
