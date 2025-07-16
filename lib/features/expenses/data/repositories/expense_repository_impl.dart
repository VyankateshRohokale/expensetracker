// lib/features/expenses/data/repositories/expense_repository_impl.dart
import 'package:expensetracker/core/errors/exceptions.dart';
import 'package:expensetracker/core/errors/failures.dart';
import 'package:expensetracker/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:expensetracker/features/expenses/domain/entities/expense.dart';
import 'package:expensetracker/features/expenses/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      final expenses = await localDataSource.getExpenses();
      return Right(expenses);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    try {
      await localDataSource.addExpense(expense);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      await localDataSource.updateExpense(expense);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await localDataSource.deleteExpense(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred: $e'));
    }
  }
}