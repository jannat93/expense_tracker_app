import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import 'ChatbotScreen.dart';
import 'add_expense_screen.dart';


const Color _darkBg = Color(0xFF141414);
const Color _cardBg = Color(0xFF1E1E1E);
const Color _primaryColor = Color(0xFFBB86FC);
const Color _expenseColor = Color(0xFFE53935);
const Color _whiteText = Colors.white;
const Color _darkText = Color(0xFF141414);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


  Color categoryColor(String cat) {
    switch (cat) {
      case "Academic":
        return Colors.blueAccent;
      case "Food":
        return Colors.orangeAccent;
      case "Rent":
        return Colors.redAccent;
      case "Shopping":
        return Colors.pinkAccent;
      case "Travel":
        return Colors.tealAccent;
      case "Bills":
        return Colors.purpleAccent;
      default:
        return Colors.lightGreenAccent;
    }
  }


  String determineCategoryBasedOnTitle(Expense e) {
    final title = e.title.toLowerCase();

    const academicKeywords = [
      'semester', 'fee', 'tuition', 'book', 'course', 'exam',
      'school', 'university', 'college', 'notebook', 'stationery',
      'workshop', 'learning'
    ];

    for (var keyword in academicKeywords) {
      if (title.contains(keyword)) return "Academic";
    }

    const rentKeywords = [
      'rent', 'deposit', 'landlord', 'room', 'apartment', 'house', 'lease'
    ];

    for (var keyword in rentKeywords) {
      if (title.contains(keyword)) return "Rent";
    }

    const foodKeywords = [
      'grocer', 'burger', 'coffee', 'restaurant', 'cafe', 'delivery',
      'dinner', 'lunch', 'breakfast', 'supermarket', 'food', 'snacks'
    ];

    for (var keyword in foodKeywords) {
      if (title.contains(keyword)) return "Food";
    }

    if (title.contains('shopping') ||
        title.contains('clothes') ||
        title.contains('mall') ||
        title.contains('gift')) {
      return "Shopping";
    }

    if (title.contains('fuel') ||
        title.contains('bus') ||
        title.contains('taxi') ||
        title.contains('metro') ||
        title.contains('train') ||
        title.contains('flight')) {
      return "Travel";
    }

    if (title.contains('bill') ||
        title.contains('electricity') ||
        title.contains('water') ||
        title.contains('internet') ||
        title.contains('phone') ||
        title.contains('utility')) {
      return "Bills";
    }

    return "Other";
  }

  void _delete(BuildContext ctx, WidgetRef ref, Expense e) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: const Text("Delete Expense", style: TextStyle(color: _whiteText)),
        content: Text("Delete '${e.title}'?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: _primaryColor)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(expenseProvider.notifier).deleteExpense(e.id!);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  Widget _buildTotalExpenseCard(BuildContext context, double total) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Expense",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "৳ ${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: _whiteText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: _darkText),
                label: const Text("Add New",
                    style: TextStyle(
                        color: _darkText, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Track spending to stay within your budget.",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(
      List<String> categories, Map<String, double> totals) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((cat) {
          final total = totals[cat] ?? 0.0;
          final color = categoryColor(cat);

          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cat == "Academic"
                      ? Icons.school
                      : cat == "Food"
                      ? Icons.fastfood
                      : cat == "Rent"
                      ? Icons.house
                      : Icons.category,
                  color: color,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  cat,
                  style: const TextStyle(
                      color: _whiteText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "৳ ${total.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildExpenseListItem(
      Expense e, String category, Color color, WidgetRef ref, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            category == "Academic"
                ? Icons.school
                : category == "Food"
                ? Icons.fastfood
                : category == "Rent"
                ? Icons.house
                : Icons.monetization_on,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          e.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _whiteText,
          ),
        ),
        subtitle: Text(
          "$category • ${e.date.day}-${e.date.month}-${e.date.year}",
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: Text(
          "- ৳ ${e.amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _expenseColor,
          ),
        ),
        onLongPress: () => _delete(context, ref, e),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    double totalExpense =
    expenses.fold(0, (sum, e) => sum + e.amount);

    final Map<String, double> categoryTotals = {};

    // CATEGORY CARDS ALWAYS SHOWN
    final displayCategories = ["Academic", "Food", "Rent", "Other"];

    for (var cat in displayCategories) {
      categoryTotals[cat] = expenses
          .where((e) => determineCategoryBasedOnTitle(e) == cat)
          .fold(0, (sum, e) => sum + e.amount);
    }

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        title: const Text("Good Morning",
            style: TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: _cardBg,
              child: ClipOval(
                child: Image.asset(
                  'assets/p3.jpg',
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  errorBuilder: (ctx, err, stack) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryColor, // background color
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),

            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: _primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.psychology_alt,
            size: 32, color: _darkText),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalExpenseCard(context, totalExpense),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              "Category Breakdown",
              style: TextStyle(
                  color: _whiteText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),

          _buildCategoryBreakdown(displayCategories, categoryTotals),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              "Recent Activity",
              style: TextStyle(
                  color: _whiteText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: expenses.isEmpty
                ? const Center(
              child: Text(
                "No expenses yet. Tap the 'Add New' button to add one.",
                style:
                TextStyle(fontSize: 16, color: Colors.white54),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: expenses.length,
              itemBuilder: (context, i) {
                final e = expenses[i];
                final category =
                determineCategoryBasedOnTitle(e);
                final catColor = categoryColor(category);

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildExpenseListItem(
                      e, category, catColor, ref, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
