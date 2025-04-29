import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/dialogs/new_expense_dialog.dart';
import 'package:expense_tracker/widgets/expenses/expense_lists/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'course subscription',
      amount: 19.99,
      category: Category.work,
      date: DateTime.now(),
    ),
    Expense(
      title: 'restaurant bill',
      amount: 35.66,
      category: Category.food,
      date: DateTime.now(),
    ),
    Expense(
      title: 'park fees',
      amount: 1.88,
      category: Category.leisure,
      date: DateTime.now(),
    ),
  ];

  void _onaddExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _onRemoveExpense(Expense expense) {
    final itemIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(
          seconds: 3,
        ),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(itemIndex, expense);
            });
          },
        ),
        content: Text('Expense delted'),
      ),
    );
  }

  void _openItemDialog() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpenseDialog(
            onSaveExpense: _onaddExpense,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker App'),
        actions: [
          IconButton(
            onPressed: _openItemDialog,
            icon: Icon(Icons.add),
            style: IconButton.styleFrom(),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: ExpensesList(
                    _registeredExpenses,
                    onDismissed: _onRemoveExpense,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: ExpensesList(
                    _registeredExpenses,
                    onDismissed: _onRemoveExpense,
                  ),
                ),
              ],
            ),
    );
  }
}
