import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/presentation/providers/expense_list_notifier.dart';
import 'package:expensetracker/features/expenses/presentation/providers/balance_notifier.dart'; // Make sure this is also defined

// BalanceNotifier Definition (if not already in a separate file)
// For simplicity, defining it here. In a real app, it would be in its own file.
class BalanceState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  BalanceState({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  BalanceState copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
  }) {
    return BalanceState(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
    );
  }
}

class BalanceNotifier extends StateNotifier<BalanceState> {
  BalanceNotifier(List<Expense> expenses)
      : super(_calculateBalance(expenses));

  static BalanceState _calculateBalance(List<Expense> expenses) {
    double totalIncome = 0;
    double totalExpenses = 0;

    for (var expense in expenses) {
      if (expense.amount >= 0) {
        totalIncome += expense.amount;
      } else {
        totalExpenses += expense.amount.abs(); // Store as positive for display
      }
    }
    final totalBalance = totalIncome - totalExpenses;
    return BalanceState(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }

  void updateBalance(List<Expense> expenses) {
    state = _calculateBalance(expenses);
  }
}

final balanceProvider = StateNotifierProvider<BalanceNotifier, BalanceState>((ref) {
  final expenseListAsyncValue = ref.watch(expenseListProvider);
  return expenseListAsyncValue.when(
    data: (expenses) => BalanceNotifier(expenses),
    loading: () => BalanceNotifier([]), // Initial state while loading
    error: (err, stack) => BalanceNotifier([]), // Handle error state
  );
});


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final expenseListAsyncValue = ref.watch(expenseListProvider);
    final balanceState = ref.watch(balanceProvider);

    final List<String> avatars = [
      'assets/images/avatar1.png',
      'assets/images/avatar2.png',
      'assets/images/avatar3.png',
      'assets/images/avatar4.png',
      'assets/images/avatar5.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background wave/gradient part
          Container(
            height: screenHeight * 0.35,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color(0xFF1E90FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          // Content ScrollView
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back,',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Piyush',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Total Balance Card
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Balance',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                            Icon(Icons.more_horiz, color: Colors.grey[600]),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            Icon(Icons.arrow_upward, color: Color(0xFF4CAF50)),
                            Text(
                              '\$ ${balanceState.totalBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_downward, color: Colors.redAccent),
                                    Text(
                                      'Expense',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${balanceState.totalIncome.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_upward, color: Colors.redAccent),
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${balanceState.totalExpenses.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Transactions History
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions History',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('See all transactions');
                        },
                        child: Text(
                          'See all',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Color(0xFF1E90FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Displaying expenses based on the Riverpod provider
                expenseListAsyncValue.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No transactions yet. Add one!'),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Dismissible(
                          key: ValueKey(transaction.id), // Unique key for Dismissible
                          direction: DismissDirection.endToStart, // Swipe from right to left
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete "${transaction.name}"?'),
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
                          },
                          onDismissed: (direction) {
                            ref.read(expenseListProvider.notifier).deleteExpense(transaction.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('"${transaction.name}" deleted.')),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to transaction details page with the expense object
                              context.push('/transaction-details', extra: transaction);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenHeight * 0.01),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: transaction.amount >= 0 ? const Color(0xFFE0F2F1) : const Color(0xFFFDE0DD),
                                    child: Icon(
                                      transaction.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: transaction.amount >= 0 ? const Color(0xFF4CAF50) : Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction.name,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(transaction.date), // Formatted date
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${transaction.amount >= 0 ? '+' : '-'} \$${transaction.amount.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: transaction.amount >= 0 ? const Color(0xFF4CAF50) : Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),

                // Send Again (dummy section for UI)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Send Again',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('See all contacts');
                        },
                        child: Text(
                          'See all',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: const Color(0xFF1E90FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: screenHeight * 0.1, // Fixed height for horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    itemCount: avatars.length, // Using a list of avatar paths
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: CircleAvatar(
                          radius: screenWidth * 0.06,
                          backgroundImage: AssetImage(avatars[index]),
                          backgroundColor: Colors.grey[200],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.1), // Spacing for FAB
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: screenHeight * 0.08, // Responsive height for bottom bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: const Icon(Icons.home, color: Color(0xFF1E90FF)), onPressed: () {}),
              IconButton(icon: const Icon(Icons.bar_chart, color: Colors.grey), onPressed: () {}),
              SizedBox(width: screenWidth * 0.15), // Space for FAB
              IconButton(
                icon: const Icon(Icons.wallet, color: Colors.grey),
                onPressed: () {
                  context.go('/wallet'); // Navigate to wallet page
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.grey),
                onPressed: () {
                  context.go('/profile'); // Navigate to profile page
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-expense'); // Navigate to add expense page
        },
        backgroundColor: const Color(0xFF4CAF50), // Green accent
        shape: const CircleBorder(), // Circular FAB
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}