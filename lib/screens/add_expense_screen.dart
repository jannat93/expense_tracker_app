import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';


const Color _darkBg = Color(0xFF141414);
const Color _cardBg = Color(0xFF1E1E1E);
const Color _primaryColor = Color(0xFFBB86FC);
const Color _whiteText = Colors.white;

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
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        title: const Text(
          'Add Expense',
          style: TextStyle(color: _whiteText),
        ),
        iconTheme: const IconThemeData(color: _whiteText),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Expense Title",
                  style: TextStyle(color: _whiteText, fontSize: 14),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _titleCtrl,
                  hint: "Enter title (e.g. Buy coffee)",
                  validator: (v) =>
                  v == null || v.isEmpty ? "Title required" : null,
                ),

                const SizedBox(height: 20),

                // Amount Field
                const Text(
                  "Amount",
                  style: TextStyle(color: _whiteText, fontSize: 14),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _amountCtrl,
                  keyboard: TextInputType.number,
                  hint: "Enter amount (e.g. 200)",
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Amount required";
                    if (double.tryParse(v) == null) return "Enter a valid number";
                    return null;
                  },
                ),

                const SizedBox(height: 20),


                const Text(
                  "Select Date",
                  style: TextStyle(color: _whiteText, fontSize: 14),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: _darkBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                          style: const TextStyle(color: _whiteText, fontSize: 16),
                        ),
                        const Icon(Icons.calendar_month, color: _primaryColor),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Add Button
                Center(
                  child: ElevatedButton(
                    onPressed: saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Expense',
                      style: TextStyle(
                        color: _darkBg,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required FormFieldValidator<String> validator,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: _whiteText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white38),
        filled: true,
        fillColor: _darkBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white10),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: _primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _primaryColor,
              surface: _cardBg,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final exp = Expense(
      id: null,
      title: _titleCtrl.text,
      amount: double.parse(_amountCtrl.text),
      date: selectedDate,
    );

    await ref.read(expenseProvider.notifier).addExpense(exp);
    Navigator.pop(context);
  }
}
