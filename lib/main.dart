import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:expensetracker/features/expenses/domain/entities/expense.dart'; 
import '../splash_screen/splash_screen_page.dart';
import '../onboarding/onboarding_page.dart';
import 'package:expensetracker/features/expenses/presentation/pages/home_page.dart';
import 'package:expensetracker/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:expensetracker/features/expenses/presentation/pages/transaction_details_page.dart';

import 'package:expensetracker/features/expenses/presentation/pages/wallet_page.dart';
import 'package:expensetracker/features/expenses/presentation/pages/profile_page.dart';


final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-expense',
      name: 'add_expense',
      builder: (context, state) {
        final expenseToEdit = state.extra as Expense?; // Cast extra to Expense?
        return AddExpensePage(expenseToEdit: expenseToEdit);
      },
    ),
    GoRoute(
      path: '/transaction-details',
      name: 'transaction_details',
      builder: (context, state) {
        final expense = state.extra as Expense; // Cast extra to Expense
        return TransactionDetailsPage(expense: expense);
      },
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => const WalletPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);

void main() {
  runApp(
    const ProviderScope( // Wrap the app with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}