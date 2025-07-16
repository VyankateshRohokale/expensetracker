
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/domain/usecases/add_expense.dart';
import 'package:expensetracker/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expensetracker/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expensetracker/features/expenses/domain/usecases/update_expense.dart';
import 'package:expensetracker/core/errors/failures.dart';


import 'package:expensetracker/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:expensetracker/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  return ExpenseLocalDataSourceImpl();
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.read(expenseLocalDataSourceProvider));
});

final addExpenseUseCaseProvider = Provider<AddExpense>((ref) {
  return AddExpense(ref.read(expenseRepositoryProvider));
});

final getExpensesUseCaseProvider = Provider<GetExpenses>((ref) {
  return GetExpenses(ref.read(expenseRepositoryProvider));
});

final deleteExpenseUseCaseProvider = Provider<DeleteExpense>((ref) {
  return DeleteExpense(ref.read(expenseRepositoryProvider));
});

final updateExpenseUseCaseProvider = Provider<UpdateExpense>((ref) {
  return UpdateExpense(ref.read(expenseRepositoryProvider));
});

// 
class ExpenseListNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  final AddExpense _addExpense;
  final GetExpenses _getExpenses;
  final DeleteExpense _deleteExpense;
  final UpdateExpense _updateExpense;

  ExpenseListNotifier(this._addExpense, this._getExpenses, this._deleteExpense, this._updateExpense)
      : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    state = const AsyncValue.loading();
    final result = await _getExpenses();
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (expenses) => state = AsyncValue.data(expenses),
    );
  }

  Future<void> addExpense(Expense expense) async {
    final currentExpenses = state.valueOrNull ?? [];
   
    state = AsyncValue.data([...currentExpenses, expense]);

    final result = await _addExpense(expense);
    result.fold(
      (failure) {
        
        state = AsyncValue.data(currentExpenses);
        print('Error adding expense: ${failure.message}');
        
      },
      (_) {
        print('Expense added successfully: ${expense.name}');
        loadExpenses();
      },
    );
  }

  Future<void> deleteExpense(String expenseId) async {
    if (state.valueOrNull == null) return;

    final currentExpenses = state.value!;
    final updatedList = currentExpenses.where((e) => e.id != expenseId).toList();

    state = AsyncValue.data(updatedList);

    final result = await _deleteExpense(expenseId);
    result.fold(
      (failure) {
       
        state = AsyncValue.data(currentExpenses);
        print('Error deleting expense: ${failure.message}');
      },
      (_) {
        print('Expense with ID $expenseId deleted successfully.');
        loadExpenses();
      },
    );
  }

  Future<void> updateExpense(Expense expense) async {
    if (state.valueOrNull == null) return;

    final currentExpenses = state.value!;
    final updatedList = currentExpenses.map((e) => e.id == expense.id ? expense : e).toList();
 
    state = AsyncValue.data(updatedList);

    final result = await _updateExpense(expense);
    result.fold(
      (failure) {
        
        state = AsyncValue.data(currentExpenses);
        print('Error updating expense: ${failure.message}');
      },
      (_) {
        print('Expense with ID ${expense.id} updated successfully.');
        loadExpenses(); 
      },
    );
  }
}

final expenseListProvider = StateNotifierProvider<ExpenseListNotifier, AsyncValue<List<Expense>>>((ref) {
  return ExpenseListNotifier(
    ref.read(addExpenseUseCaseProvider),
    ref.read(getExpensesUseCaseProvider),
    ref.read(deleteExpenseUseCaseProvider),
    ref.read(updateExpenseUseCaseProvider),
  );
});