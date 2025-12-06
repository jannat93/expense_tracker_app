import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty
                    ? "Title is required"
                    : null,
              ),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Amount required";
                  if (double.tryParse(v) == null) return "Enter a number";
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                          "Date: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}")),
                  TextButton(
                    onPressed: pickDate,
                    child: const Text("Choose"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: save,
                child: const Text('Save Expense'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) setState(() => selectedDate = picked);
  }

  void save() {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text,
      amount: double.parse(_amountCtrl.text),
      date: selectedDate,
    );

    ref.read(expenseProvider.notifier).addExpense(expense);
    Navigator.pop(context);
  }
}
