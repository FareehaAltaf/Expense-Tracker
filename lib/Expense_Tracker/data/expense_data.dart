import 'package:bootcamp_app/Expense_Tracker/data/hive_database.dart';
import 'package:flutter/material.dart';
import '../datetime/date_time_helper.dart';
import '../models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  //list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];
  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data for display
  final db = HiveDataBase();
  void prepareData() {
    //if there exist data, get  it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    // so we know what we're gonna store
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    // so we know which exp we looking at
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday (mon, tue, ect) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return '';
    }
  }

  // get the date for the start of the week (sun)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today to a nearest sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek =
            today.subtract(Duration(days: i)); // store found Sun in startOfWeek
      }
    }
    return startOfWeek!;
  }

  /*
  convert overall list of expense into a daily expense sumary
  
  e.g.
  overallExpenseList = [
    [ food, 2023/01/30, $10],
    [ hat, 2023/01/30, $15],
    [ drinks, 2023/01/31, $1],
    [ food, 2023/02/01, $5],
    [ food, 2023/02/01, $6],
    [ food, 2023/02/05, $7],
    [ food, 2023/02/05, $11],
  
  ]

  ->

  DailyExpenseSummary = //summary of each day, nd spent
  [
    [2023/01/30: $25],
    [2023/01/31: $1],
    [2023/02/01: $11],
    [2023/02/03: $7],
    [2023/02/05: $21],
  ]

  */

  Map<String, double> calculateDailyExpensesSummary() {
    Map<String, double> dailyExpensesSummary = {
      // date {yyyy/mm/dd} : amountTotalForDay
    };
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpensesSummary.containsKey(date)) {
        //if a date in overallexplist put her straigjt into dailyexpsum
        double currentAmount = dailyExpensesSummary[date]!;
        currentAmount += amount;
        dailyExpensesSummary[date] = currentAmount;
      } else // if a new date
      {
        dailyExpensesSummary.addAll({date: amount});
      }
    }
    return dailyExpensesSummary;
  }
}
