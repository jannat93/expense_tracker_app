class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    title: map['title'],
    amount: (map['amount'] as num).toDouble(),
    date: DateTime.parse(map['date']),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "amount": amount,
    "date": date.toIso8601String().substring(0, 10),
  };
}
