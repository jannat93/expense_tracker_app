import 'dart:convert';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    title: map['title'],
    amount: (map['amount'] as num).toDouble(),
    date: DateTime.parse(map['date']),
  );

  static String encode(List<Expense> list) =>
      jsonEncode(list.map((e) => e.toMap()).toList());

  static List<Expense> decode(String raw) =>
      (jsonDecode(raw) as List).map((e) => Expense.fromMap(e)).toList();
}
