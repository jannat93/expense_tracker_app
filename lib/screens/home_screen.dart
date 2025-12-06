import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    double total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker Lite')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Expense", style: TextStyle(fontSize: 16)),
                  Text(
                    "৳ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text("No expenses yet."))
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, i) {
                final e = expenses[i];
                return Card(
                  child: ListTile(
                    title: Text(e.title),
                    subtitle: Text(
                        "${e.date.day}-${e.date.month}-${e.date.year}"),
                    trailing:
                    Text("৳ ${e.amount.toStringAsFixed(2)}"),
                    onLongPress: () => _delete(context, ref, e),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _delete(BuildContext ctx, WidgetRef ref, Expense e) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Expense"),
        content: Text("Delete '${e.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref.read(expenseProvider.notifier).deleteExpense(e.id);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
