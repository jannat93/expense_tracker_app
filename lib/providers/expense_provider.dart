import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

final expenseProvider =
StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  return ExpenseNotifier()..loadExpenses();
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super([]);

  // Load from API
  Future<void> loadExpenses() async {
    state = await ApiService.fetchExpenses();
  }

  // Add
  Future<void> addExpense(Expense e) async {
    final newExpense = await ApiService.addExpense(e);
    state = [...state, newExpense];
  }

  // Delete
  Future<void> deleteExpense(int id) async {
    await ApiService.deleteExpense(id);
    state = state.where((exp) => exp.id != id).toList();
  }
}
