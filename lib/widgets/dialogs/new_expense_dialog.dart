import 'dart:io';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpenseDialog extends StatefulWidget {
  const NewExpenseDialog({
    super.key,
    required this.onSaveExpense,
  });
  final void Function(Expense) onSaveExpense;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseDialogState();
  }
}

class _NewExpenseDialogState extends State<NewExpenseDialog> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  var _selectedCategory = Category.leisure;
  DateTime? _dateChosen;
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _dateDialog() async {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year - 1, dateNow.month, dateNow.day);
    final chosenDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: dateNow,
      initialDate: dateNow,
    );
    setState(() {
      _dateChosen = chosenDate;
    });
  }

  void _showAlertMessage() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('Make sure to fill All fields!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Make sure to fill All fields!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void _onSave() {
    var isTitle =
        titleController.text.trim().isNotEmpty; //added trim to remove spaces
    var enteredAmount = double.tryParse(amountController.text);
    var isAmount = enteredAmount != null && enteredAmount >= 0;
    var isDate = _dateChosen != null;
    if (isDate && isAmount && isTitle) {
      widget.onSaveExpense(
        Expense(
            title: titleController.text,
            amount: double.parse(amountController.text),
            date: _dateChosen!,
            category: _selectedCategory),
      );
      Navigator.pop(context);
    } else {
      _showAlertMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16, right: 16, bottom: keyboardPadding + 16, top: 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 50,
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$',
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      maxLength: 50,
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                  SizedBox(
                    height: 2,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map((element) {
                            return DropdownMenuItem(
                              value: element,
                              child: Text(element.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (category) {
                            setState(() {
                              _selectedCategory = category!;
                            });
                          },
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              _dateChosen == null
                                  ? 'No Date chosed'
                                  : formatter.format(_dateChosen!),
                            ),
                            IconButton(
                              onPressed: _dateDialog,
                              icon: Icon(Icons.calendar_month_sharp),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _dateChosen == null
                                  ? 'No Date chosed'
                                  : formatter.format(_dateChosen!),
                            ),
                            IconButton(
                              onPressed: _dateDialog,
                              icon: Icon(Icons.calendar_month_sharp),
                            ),
                          ],
                        )
                      ],
                    ),
                  SizedBox(
                    height: 2,
                  ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('cancel')),
                        ElevatedButton(
                            onPressed: _onSave, child: Text('save expense'))
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values.map((element) {
                            return DropdownMenuItem(
                              value: element,
                              child: Text(element.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (category) {
                            setState(() {
                              _selectedCategory = category!;
                            });
                          },
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('cancel')),
                        ElevatedButton(
                            onPressed: _onSave, child: Text('save expense'))
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
