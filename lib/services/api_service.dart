import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ApiService {
  static const String baseUrl =
      "https://expense-tracker-api-4.onrender.com/api/expenses/";
  // GET all expenses
  static Future<List<Expense>> fetchExpenses() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Expense.fromMap(e)).toList();
    } else {
      throw Exception("Failed to load expenses");
    }
  }

  // POST create
  static Future<Expense> addExpense(Expense exp) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(exp.toMap()),
    );

    if (response.statusCode == 201) {
      return Expense.fromMap(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add");
    }
  }

  // DELETE
  static Future<void> deleteExpense(int id) async {
    final url = "$baseUrl$id/";

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete");
    }
  }
}
