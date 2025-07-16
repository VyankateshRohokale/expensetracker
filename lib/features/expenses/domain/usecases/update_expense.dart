// lib/features/expenses/domain/usecases/update_expense.dart
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateExpense {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  Future<Either<Failure, void>> call(Expense expense) async {
    if (expense.id.isEmpty) {
      return const Left(InvalidInputFailure(message: 'Expense ID cannot be empty for update.'));
    }
    return await repository.updateExpense(expense);
  }
}