import 'package:bootcamp_app/Expense_Tracker/bargraph/bar_graph.dart';
import 'package:bootcamp_app/Expense_Tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });
  //cal max amount in bar grp
  double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,) {
    double max = 10000;
    List<double> values = [
      value.calculateDailyExpensesSummary()[sunday] ?? 0,
      value.calculateDailyExpensesSummary()[monday] ?? 0,
      value.calculateDailyExpensesSummary()[tuesday] ?? 0,
      value.calculateDailyExpensesSummary()[wednesday] ?? 0,
      value.calculateDailyExpensesSummary()[thursday] ?? 0,
      value.calculateDailyExpensesSummary()[friday] ?? 0,
      value.calculateDailyExpensesSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();
    // get the largest amount which is at end of sorted list
    // nd increase the cap slightly so the grp looks full
    max = values.last * 1.1;
    return max == 0 ? 10000 : max;
  }

  //calc the week total
  String calculateWeekTotal(
    ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,)
      {
      List<double> values = [
        value.calculateDailyExpensesSummary()[sunday] ?? 0,
        value.calculateDailyExpensesSummary()[monday] ?? 0,
        value.calculateDailyExpensesSummary()[tuesday] ?? 0,
        value.calculateDailyExpensesSummary()[wednesday] ?? 0,
        value.calculateDailyExpensesSummary()[thursday] ?? 0,
        value.calculateDailyExpensesSummary()[friday] ?? 0,
        value.calculateDailyExpensesSummary()[saturday] ?? 0,
      ];
        double total = 0;
        for (int i = 0; i < values.length; i++){
          total += values[i];
        }
        return total.toStringAsFixed(2);
      }

  @override
  Widget build(BuildContext context) {
    //get yyyymmdd for each day of week
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => 
      Column(
        children: [
          //week total
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                const Text(
                  'Week total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(" Rs." + calculateWeekTotal(value, sunday, monday, tuesday, wednesday,
                  thursday, friday, saturday) ),
              ],
            ),
          ),
          //barGraph
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                  thursday, friday, saturday),
              sunAmount: value.calculateDailyExpensesSummary()[sunday] ??
                  0, // ?? 0 = if no $ on sun write a 0
              monAmount: value.calculateDailyExpensesSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpensesSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpensesSummary()[wednesday] ?? 0,
              thurAmount: value.calculateDailyExpensesSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpensesSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExpensesSummary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
