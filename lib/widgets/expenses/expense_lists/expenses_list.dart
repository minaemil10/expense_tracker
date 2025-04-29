import 'package:expense_tracker/widgets/expenses/expense_lists/expense_card.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.expenses, {super.key, required this.onDismissed});

  final void Function(Expense) onDismissed;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withAlpha(210),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onDismissed(expenses[index]);
        },           
        child: ExpenseCard(expense: expenses[index]),
      ),
    );
  }
}
