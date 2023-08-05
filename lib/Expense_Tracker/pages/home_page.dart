import 'package:bootcamp_app/Expense_Tracker/components/expense_summary.dart';
import 'package:bootcamp_app/Expense_Tracker/components/expense_tile.dart';
import 'package:bootcamp_app/Expense_Tracker/data/expense_data.dart';
import 'package:bootcamp_app/Expense_Tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:bootcamp_app/Expense_Tracker/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @protected
  @factory
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseRupeesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name:
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),

            //expense amount:
            Row(
              children: [
                // rupees
                Expanded(
                    child: TextField(
                  controller: newExpenseRupeesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Rupees",
                  ),
                ))
              ],
            )
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text("Save"),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save
  void save() {
    if (newExpenseNameController.text.isNotEmpty && newExpenseRupeesController.text.isNotEmpty) {
      //create expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: newExpenseRupeesController.text,
          dateTime: DateTime.now()
        );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
      //pop the dialogue out once saved:
      Navigator.pop(context);
    }
      
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear the controllers (once input they dont appear in dialogue box again)
  void clear() {
    newExpenseNameController.clear();
    newExpenseRupeesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Color.fromARGB(154, 201, 200, 200),
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: const Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          body: ListView(
            children: [
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(height: 20),

              //expense list
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime,
                        deleteTapped: (p0) => 
                            deleteExpense(value.getAllExpenseList()[index]),
                      ),
                    ),
            ],),
          ),
    );
  }
}


