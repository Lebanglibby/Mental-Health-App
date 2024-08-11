import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedMood;
  String? _motivationalQuote;
  bool _showMoodOptions = true;
  late GenerativeModel _model;
  late ChatSession _chat;

  final List<String> _moods = [
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
  ];

  final List<String> _moodImages = [
    'assets/images/happymood.jpeg',
    'assets/images/sadmood.jpeg',
    'assets/images/angry.png',
    'assets/images/anxious.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _initializeGenerativeModel();
  }

  void _initializeGenerativeModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyAlr31gNbawmkYbNYWV4H7vgdv9Td-TODs',
    );
    _chat = _model.startChat();
  }

  Future<void> _generateMotivationalQuote() async {
    final response = await _chat.sendMessage(
      Content.text('Generate a motivational quote for $_selectedMood.'),
    );
    setState(() {
      _motivationalQuote = response.text ?? 'Keep going, you are doing great!';
    });
  }

  void _selectMood(int index) {
    setState(() {
      _selectedMood = _moods[index];
      _showMoodOptions = false;
      _generateMotivationalQuote();
    });
  }

  void _resetMoodSelection() {
    setState(() {
      _selectedMood = null;
      _showMoodOptions = true;
      _motivationalQuote = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Health'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image covering almost half the screen
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dashboard_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                  if (_showMoodOptions)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_moods.length, (index) {
                          return GestureDetector(
                            onTap: () => _selectMood(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: _selectedMood == _moods[index]
                                    ? Colors.blue[100]
                                    : Colors.transparent,
                                border: _selectedMood == _moods[index]
                                    ? Border.all(color: Colors.blue, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    _moodImages[index],
                                    height: 80,
                                    width: 80,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(_moods[index]),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  if (!_showMoodOptions && _selectedMood != null)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _resetMoodSelection,
                          child: Column(
                            children: [
                              Image.asset(
                                _moodImages[_moods.indexOf(_selectedMood!)],
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(height: 8),
                              Text(_selectedMood!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Motivational Message of the Day:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (_motivationalQuote != null)
                          Text(
                            _motivationalQuote!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
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
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
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
          children: [
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
              title: const Text('Mood and Activity Tracking'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Resource Library'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Insights'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Community and Support Groups'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}





