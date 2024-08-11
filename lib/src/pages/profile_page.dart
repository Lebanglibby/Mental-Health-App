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
          Navigator.pushNamed(context, '/Appointments');
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
        leading: const Icon(Icons.insights),
        title: const Text('Insights'),
        onTap: () {
          Navigator.pushNamed(context, '/insights');
        },
      ),
      
      ListTile(
        leading: const Icon(Icons.group),
        title: const Text('Community and Support Groups'),
        onTap: () {
          Navigator.pushNamed(context, '/community_support_groups');
        },
      ),
    ],
  ),
),
    );
  }
}
