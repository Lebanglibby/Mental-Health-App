// lib/src/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'professional_signup_page.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';

  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Male';
  String _selectedCountry = 'United States';
  String _selectedMaritalStatus = 'Single';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
    'Botswana',
    'South Africa',
    'Namibia'
  ];
  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  items: _countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCountry = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedMaritalStatus,
                  items: _maritalStatuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMaritalStatus = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Marital Status',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Color(0xFF5c677d)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5c677d)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign-up logic here
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF370617)),
                  child: const Text('Sign Up'),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProfessionalSignUpPage.routeName);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5c677d)),
                  child: const Text('For Mental Health Professionals'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

