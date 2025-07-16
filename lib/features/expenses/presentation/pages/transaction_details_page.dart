// lib/features/expenses/presentation/pages/transaction_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/presentation/providers/expense_list_notifier.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final Expense expense;

  const TransactionDetailsPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          'Transaction Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () {
              // Navigate to AddExpensePage for editing, passing the expense
              context.push('/add-expense', extra: expense);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete "${expense.name}"?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                ref.read(expenseListProvider.notifier).deleteExpense(expense.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${expense.name}" deleted.')),
                  );
                  context.go('/home'); // Navigate back to home after deletion
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: expense.amount >= 0 ? const Color(0xFFE0F2F1) : const Color(0xFFFDE0DD),
                    radius: screenWidth * 0.1,
                    child: Icon(
                      expense.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: expense.amount >= 0 ? const Color(0xFF4CAF50) : Colors.redAccent,
                      size: screenWidth * 0.08,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    '${expense.amount >= 0 ? '+' : '-'} \$${expense.amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: expense.amount >= 0 ? const Color(0xFF4CAF50) : Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    expense.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  children: [
                    _buildDetailRow(context, 'Type', expense.amount >= 0 ? 'Income' : 'Expense', Icons.swap_horiz),
                    Divider(height: screenHeight * 0.03),
                    _buildDetailRow(context, 'Category', expense.category ?? 'N/A', Icons.category),
                    Divider(height: screenHeight * 0.03),
                    _buildDetailRow(context, 'Date', DateFormat('MMM dd, yyyy').format(expense.date), Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // You can add more details like notes or attachments here
            // if (expense.invoiceUrl != null) ...[
            //   Text('Invoice:', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
            //   SizedBox(height: screenHeight * 0.01),
            //   Image.network(expense.invoiceUrl!), // Or Image.file for local
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: screenWidth * 0.05),
        SizedBox(width: screenWidth * 0.03),
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}