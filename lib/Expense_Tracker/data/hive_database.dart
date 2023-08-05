import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_item.dart';

class HiveDataBase {
  //reference our box
  final myBoc = Hive.box("expenses_database2");
  //write data
  void saveData(List<ExpenseItem> allExpense) {
    /* 
      Hive can only store strings and dateTime, and not custom objects like ExpenseItem
    
    */

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      //convert each expenseItem into a list of storable types => strings, dateTime
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //finally lets store in our database
    myBoc.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    List savedExpense = myBoc.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpense.length; i++) {
      //i is of particular list, i[0]=name,i[1]=amount,i[2] =dateTime
      //collect individual expense data
      String name = savedExpense[i][0];
      String amount = savedExpense[i][1];
      DateTime dateTime = savedExpense[i][2];

      //create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      //addexpense to overall list og expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
