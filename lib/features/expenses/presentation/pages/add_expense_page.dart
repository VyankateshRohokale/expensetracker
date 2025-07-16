// lib/features/expenses/presentation/pages/add_expense_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/presentation/providers/expense_list_notifier.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  final Expense? expenseToEdit; // Optional: If provided, it's for editing

  const AddExpensePage({super.key, this.expenseToEdit});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _categoryController;

  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Utilities',
    'Salary', // Example income category
    'Other Income', // Example income category
    'Other Expense',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
    _categoryController = TextEditingController();

    // If expenseToEdit is provided, pre-fill fields for editing
    if (widget.expenseToEdit != null) {
      final expense = widget.expenseToEdit!;
      _nameController.text = expense.name;
      _amountController.text = expense.amount.toStringAsFixed(2); // Format amount
      _selectedDate = expense.date;
      _dateController.text = DateFormat('MMM dd, yyyy').format(expense.date);
      _selectedCategory = expense.category;
      _categoryController.text = expense.category ?? '';
    } else {
      // For new expense, set default date to today
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat('MMM dd, yyyy').format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String name = _nameController.text;
      final double amount = double.tryParse(_amountController.text) ?? 0.0;
      final DateTime date = _selectedDate ?? DateTime.now();
      final String? category = _selectedCategory;

      if (widget.expenseToEdit != null) {
        // Update existing expense
        final updatedExpense = widget.expenseToEdit!.copyWith(
          name: name,
          amount: amount,
          date: date,
          category: category,
        );
        ref.read(expenseListProvider.notifier).updateExpense(updatedExpense);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense updated successfully!')),
        );
      } else {
        // Add new expense
        final newExpense = Expense(
          id: const Uuid().v4(), // Generate new unique ID for new expense
          name: name,
          amount: amount,
          date: date,
          category: category,
          invoiceUrl: null, // Default for now, can be added later
        );
        ref.read(expenseListProvider.notifier).addExpense(newExpense);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully!')),
        );
      }
      context.go('/home'); // Navigate back to home page after save
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isEditing = widget.expenseToEdit != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Expense' : 'Add New Expense', // Dynamic title
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Name',
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Groceries, Salary',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                'Amount',
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g., 50.00 (use positive for income, negative for expense)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                'Date',
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Select date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                'Category',
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select a category'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.04),

              Center(
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Expense' : 'Add Expense', // Dynamic button text
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}