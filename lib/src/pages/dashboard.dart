import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController(); // ScrollController

  final List<String> _moods = [
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
  ];

  final List<String> _moodImages = [
    'assets/images/happy.jpeg',
    'assets/images/sad.jpeg',
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

    // Scroll to the bottom when a new quote is generated
    _scrollToBottom();
  }

  Future<void> _saveMoodToFirestore() async {
    await _firestore.collection('moods').add({
      'mood': _selectedMood,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _selectMood(int index) {
    setState(() {
      _selectedMood = _moods[index];
      _showMoodOptions = false;
      _generateMotivationalQuote();
      _saveMoodToFirestore();
    });
  }

  void _resetMoodSelection() {
    setState(() {
      _selectedMood = null;
      _showMoodOptions = true;
      _motivationalQuote = null;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Health'),
        backgroundColor: const Color.fromARGB(255, 2, 61, 171),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the ScrollController
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
                    SizedBox(
                      height: 140,  // Adjusted height
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _moods.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _selectMood(index),
                            child: Container(
                              width: 100, // Set width for each mood container
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: _selectedMood == _moods[index]
                                    ? Colors.blue[100]
                                    : Colors.white,
                                border: Border.all(
                                  color: _selectedMood == _moods[index]
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    _moodImages[index],
                                    height: 60,
                                    width: 60,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _moods[index],
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (!_showMoodOptions && _selectedMood != null)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _resetMoodSelection,
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                margin: const EdgeInsets.symmetric(vertical: 16.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      _moodImages[_moods.indexOf(_selectedMood!)],
                                      height: 60,
                                      width: 60,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _selectedMood!,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Motivational Message of the Day',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (_motivationalQuote != null)
                          AnimatedText(
                            text: _motivationalQuote!,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                ],
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
              icon: const Icon(Icons.chat,  color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person,  color: Colors.blueGrey),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_hospital,  color: Colors.blueGrey),
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

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const AnimatedText({super.key, 
    required this.text,
    required this.textStyle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  // ignore: unused_field, prefer_final_fields
  int _currentIndex = 0;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn)
      ..addListener(() {
        setState(() {
          _displayedText = widget.text.substring(
              0, (_animation.value * widget.text.length).ceil());
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.stop();
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.textStyle,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}









