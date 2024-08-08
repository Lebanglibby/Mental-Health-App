import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;

  final List<String> _moods = [
    'Happy',
    'Sad',
    'Angry',
    'Anxious'
  ];

  final List<String> _moodImages = [
    'assets/images/happymood.jpeg',
    'assets/images/sadmood.jpeg',
    'assets/images/angry.png',
    'assets/images/anxious.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Mental Health App Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mood selection section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150, // Adjust the height as needed
                    child: PageView.builder(
                      itemCount: _moods.length,
                      controller: PageController(viewportFraction: 0.3),
                      onPageChanged: (int index) => setState(() => _selectedPage = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _selectedPage ? 1 : 0.9,
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: _selectedPage == i ? 80 : 70, // Adjusted sizes
                                width: _selectedPage == i ? 80 : 70,
                                child: Image.asset(_moodImages[i]),
                              ),
                              const SizedBox(height: 8),
                              Text(_moods[i]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Motivational Message of the Day:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '"Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle."',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Center(
              child: Text('Main Content Area'),
            ),
          ],
        ),
      ),
      // Footer
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.local_hospital),
              onPressed: () {},
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
      // Drawer for the menu
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
              title: const Text('Mood and Activity Tracking'),
              onTap: () {
                // Navigate to Mood and Activity Tracking
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Resource Library'),
              onTap: () {
                // Navigate to Resource Library
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Insights'),
              onTap: () {
                // Navigate to Insights
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Community'),
              onTap: () {
                // Navigate to Community
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Support Groups'),
              onTap: () {
                // Navigate to Support Groups
              },
            ),
          ],
        ),
      ),
    );
  }
}


