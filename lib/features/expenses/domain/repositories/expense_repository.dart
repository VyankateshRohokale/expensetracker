import 'package:fpdart/fpdart.dart';
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure, void>> addExpense(Expense expense);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(String id);
}