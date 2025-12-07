import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';


const Color _darkBg = Color(0xFF141414);
const Color _cardBg = Color(0xFF1E1E1E);
const Color _primaryColor = Color(0xFFBB86FC);
const Color _whiteText = Colors.white;

class ExpenseChartScreen extends ConsumerWidget {
  const ExpenseChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);


    final List<Map<String, dynamic>> weeklyData = [
      {'day': 'Mon', 'amount': 1500.0},
      {'day': 'Tue', 'amount': 2200.0},
      {'day': 'Wed', 'amount': 900.0},
      {'day': 'Thu', 'amount': 3000.0},
      {'day': 'Fri', 'amount': 1800.0},
    ];

    double maxSpend = weeklyData.map((e) => e['amount'] as double).reduce((a, b) => a > b ? a : b);
    if (maxSpend == 0) maxSpend = 1.0;

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        title: const Text(
          "Expense Tracking (Curve View)",
          style: TextStyle(color: _whiteText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weekly Spending Trend",
                style: TextStyle(color: _whiteText, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),


              Container(
                height: 250,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weeklyData.map((data) {
                    double heightFactor = (data['amount'] as double) / maxSpend;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '৳ ${data['amount'].toInt()}',
                          style: TextStyle(color: _primaryColor.withOpacity(0.8), fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 25,
                          height: 180 * heightFactor, // Scale height
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.5),
                                blurRadius: 5,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['day'],
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Insights",
                style: TextStyle(color: _whiteText, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total expenses recorded: **${expenses.length}**",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Your total monthly expenses are highly correlated with **Rent** and **Academic** fees.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}