import 'package:fpdart/fpdart.dart';
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<Either<Failure, List<Expense>>> call() async {
    return await repository.getExpenses();
  }
}