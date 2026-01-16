import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'images/logo/logo-with-text.png',
              width: 200, // Adjust size as needed
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            // Circular Progress Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF11417f)), // Dark blue
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
