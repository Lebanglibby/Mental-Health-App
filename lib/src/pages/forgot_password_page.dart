// lib/src/pages/forgot_password_page.dart
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const routeName = '/forgot_password';

  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle password recovery logic here
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
