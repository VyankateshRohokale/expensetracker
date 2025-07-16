// lib/features/expenses/presentation/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    if (mounted) {
      // Check if the widget is still in the tree before navigating
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for responsive UI
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1E90FF), // A shade of blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example of an image asset, replace with your actual logo
            Image.asset(
              'assets/images/image_fb9157.jpg', // Make sure this path is correct in pubspec.yaml
              height: screenHeight * 0.2, // Responsive sizing
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Expense Tracker',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.07, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Track your money easily',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.04, // Responsive font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}