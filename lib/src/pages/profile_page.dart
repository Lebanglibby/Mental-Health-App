import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  // Add a GlobalKey to manage the scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: const Center(
        child: Text('User Profile Information'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.local_hospital),
              onPressed: () {
                Navigator.pushNamed(context, '/emergency_support');
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
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
          children: const <Widget>[
            DrawerHeader(
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
              leading: Icon(Icons.track_changes),
              title: Text('Mood and Activity Tracking'),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Resource Library'),
            ),
            ListTile(
              leading: Icon(Icons.insights),
              title: Text('Insights'),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Community and Support Groups'),
            ),
          ],
        ),
      ),
    );
  }
}
