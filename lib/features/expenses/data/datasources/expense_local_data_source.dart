import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:uuid/uuid.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  static final List<Expense> _expenses = [];

  @override
  Future<List<Expense>> getExpenses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_expenses);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _expenses.add(expense.copyWith(id: const Uuid().v4()));
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense; 
    } else {
      throw Exception('Expense with ID ${expense.id} not found for update.');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _expenses.removeWhere((expense) => expense.id == id);
  }
}