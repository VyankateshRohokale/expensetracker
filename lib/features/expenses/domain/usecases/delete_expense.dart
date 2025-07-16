// lib/features/expenses/domain/usecases/delete_expense.dart
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    if (id.isEmpty) {
      return const Left(InvalidInputFailure(message: 'Expense ID cannot be empty for deletion.'));
    }
    return await repository.deleteExpense(id);
  }
}