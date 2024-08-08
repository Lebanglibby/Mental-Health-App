import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'dashboard.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Space at the top
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xFF5c677d)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5c677d)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5c677d)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFF5c677d)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5c677d)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5c677d)),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                  Navigator.pushNamed(context, Dashboard.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF370617),
                ),
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpPage.routeName);
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Color(0xFF5c677d)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF5c677d)),
                ),
              ),
              const SizedBox(height: 50), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}




