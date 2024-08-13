import 'package:flutter/material.dart';
import 'package:mentalhealthcare/src/services/auth_service.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  String _email = '';
  String _password = '';
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = await _authService.signInWithEmailAndPassword(_email, _password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, Dashboard.routeName);
      } else {
        setState(() {
          _errorMessage = 'Failed to sign in. Please check your credentials.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 2, 61, 171),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0), 

                
              Image.asset(
               'assets/images/mylogo.jpg', 
                   height: 270, 
                   width: 279, 
                   fit: BoxFit.cover, 
                 ),

                const SizedBox(height: 50), // Space below the logo

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF370617),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), 
                    textStyle: const TextStyle(fontSize: 18), 
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),

                // Sign Up Button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), 
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Color.fromARGB(255, 37, 104, 237)),
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
                const SizedBox(height: 50), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}






