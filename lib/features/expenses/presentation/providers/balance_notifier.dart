
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/presentation/providers/expense_list_notifier.dart'; // Import ExpenseListNotifier

// Data class to hold calculated balance values
class BalanceState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const BalanceState({
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
  });

  // For equatable-like comparison or debugging
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BalanceState &&
        other.totalBalance == totalBalance &&
        other.totalIncome == totalIncome &&
        other.totalExpenses == totalExpenses;
  }

  @override
  int get hashCode => totalBalance.hashCode ^ totalIncome.hashCode ^ totalExpenses.hashCode;
}

//
class BalanceNotifier extends StateNotifier<BalanceState> {
  final Ref _ref;

  BalanceNotifier(this._ref) : super(const BalanceState()) {
    _ref.listen<AsyncValue<List<Expense>>>(expenseListProvider, (_, nextExpenses) {
      nextExpenses.whenOrNull(
        data: (expenses) {
          _calculateBalances(expenses);
        },
      );
    },
    fireImmediately: true,
    );
  }

  void _calculateBalances(List<Expense> expenses) {
    double income = 0.0;
    double expensesTotal = 0.0;

    for (var expense in expenses) {
      if (expense.amount >= 0) {
        income += expense.amount;
      } else {
        expensesTotal += expense.amount.abs(); // Store as positive value
      }
    }

    final totalBalance = income - expensesTotal;

    state = BalanceState(
      totalBalance: totalBalance,
      totalIncome: income,
      totalExpenses: expensesTotal,
    );
  }
}

// The provider that exposes our BalanceNotifier
final balanceProvider = StateNotifierProvider<BalanceNotifier, BalanceState>((ref) {
  return BalanceNotifier(ref);
});