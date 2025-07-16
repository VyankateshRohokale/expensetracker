import 'package:fpdart/fpdart.dart';
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<Either<Failure, void>> call(Expense expense) async {
    // Add any business logic or validation here
    if (expense.name.isEmpty || expense.amount == 0) {
      return const Left(InvalidInputFailure(message: 'Name and amount cannot be empty or zero.'));
    }
    return await repository.addExpense(expense);
  }
}