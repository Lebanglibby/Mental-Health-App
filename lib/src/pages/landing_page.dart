import 'package:flutter/material.dart';
import './login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensures the background image fills the screen
        children: [
          Image.asset(
            'assets/images/background_image.jpg', // Replace with your image path
            fit: BoxFit.cover, // Makes the image cover the entire screen
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}


