import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum Category { leisure, work, food, travel }

final uuid = Uuid();
final formatter = DateFormat('dd/MM/yyyy');
final Map<Category, IconData> categoryIconChooser = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work,
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where(
          (expense) {
            return expense.category == category;
          },
        ).toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    var sum = 0.0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
