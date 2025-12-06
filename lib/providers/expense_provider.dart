import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  return ExpenseNotifier()..loadExpenses();
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super([]);

  static const storageKey = 'expenses';

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);

    if (raw != null) {
      state = Expense.decode(raw);
    }
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, Expense.encode(state));
  }

  void addExpense(Expense expense) async {
    state = [...state, expense];
    await saveExpenses();
  }

  void deleteExpense(String id) async {
    state = state.where((e) => e.id != id).toList();
    await saveExpenses();
  }
}
