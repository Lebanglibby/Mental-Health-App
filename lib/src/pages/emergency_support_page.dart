// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class EmergencySupportPage extends StatefulWidget {
  static const routeName = '/emergency_support';

  const EmergencySupportPage({super.key});

  @override
  _EmergencySupportPageState createState() => _EmergencySupportPageState();
}

class _EmergencySupportPageState extends State<EmergencySupportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCountry = 'Botswana'; // Default country

  final Map<String, List<Map<String, String>>> _emergencyContacts = {
    'USA': [
      {'title': '911', 'description': 'Emergency'},
      {'title': '988', 'description': 'Suicide & Crisis Lifeline'},
    ],
    'UK': [
      {'title': '999', 'description': 'Emergency'},
      {'title': '0800 689 5652', 'description': 'Samaritans'},
    ],
    'Botswana': [
      {'title': '911', 'description': 'Emergency Services'},
      {'title': '0861 322 322', 'description': 'National Counselling Line'},
      {'title': '290', 'description': 'Botswana Suicide Hotline'},
      {'title': '116', 'description': 'Childline'},
      {'title': '+267 7552 7590', 'description': 'Lifeline/FTMTB'},
    ],
    // Add more countries and their contacts here
  };

  void _onCountryChanged(String? newCountry) {
    if (newCountry != null) {
      setState(() {
        _selectedCountry = newCountry;
      });
    }
  }

  void _callEmergencyContact(String contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Calling $contact'),
          content: Text('This is a placeholder for calling $contact.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Emergency Support'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your country:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            DropdownButton<String>(
              value: _selectedCountry,
              onChanged: _onCountryChanged,
              items: _emergencyContacts.keys.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              isExpanded: true,
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
              underline: Container(
                height: 2,
                color: Colors.blueGrey[300],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Emergency Contacts for $_selectedCountry:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _emergencyContacts[_selectedCountry]!.map((contact) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.red),
                      title: Text(contact['title']!),
                      subtitle: Text(contact['description']!),
                      onTap: () => _callEmergencyContact(contact['title']!),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_hospital, color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_support');
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.blueGrey),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1b263b),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Appointments'),
              onTap: () {
                Navigator.pushNamed(context, '/appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Resource Library'),
              onTap: () {
                Navigator.pushNamed(context, '/resource_library');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async {
              Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
            },
          ),
          ],
        ),
      ),
    );
  }
}




