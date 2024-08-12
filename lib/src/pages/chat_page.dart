// ignore_for_file: unused_field, dead_code
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GenerativeModel _model;
  late ChatSession _chat;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _initializeGenerativeModel();
    _aiInitiateConversation(); // AI initiates conversation upon opening the chat screen
  }

  void _initializeGenerativeModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyAlr31gNbawmkYbNYWV4H7vgdv9Td-TODs', // Replace with your actual API key
    );
    _chat = _model.startChat();
  }

  void _aiInitiateConversation() {
    setState(() {
      _messages.add({"sender": "AI", "text": "Hello! How can I assist you today?"});
    });
  }

  void _sendMessage() async {
    final userMessage = _textController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "User", "text": userMessage});
        _textController.clear();
        _isWaitingForResponse = true;
      });

      final response = await _chat.sendMessage(Content.text(userMessage));
      final aiMessage = response.text ?? "I'm here to help!";
      _displayAiMessage(aiMessage);
    }
  }

  Future<void> _displayAiMessage(String message) async {
    setState(() {
      _isWaitingForResponse = false;
      _messages.add({"sender": "AI", "text": ""});
    });

    final words = message.split(' ');
    String displayedText = '';

    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 300)); // Typing delay
      setState(() {
        displayedText += ' $word';
        _messages.last["text"] = displayedText.trim();
        _scrollToBottom();
      });
    }

    if (_requiresProfessionalAttention(displayedText)) {
      _promptForProfessionalHelp();
    }
  }

  bool _requiresProfessionalAttention(String message) {
    const keywords = ['depression', 'anxiety', 'suicide', 'help', 'suicidal', 'harm', 'kill', 'murder', 'drug', 'disorder', 'loss of family'];
    for (var keyword in keywords) {
      if (message.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  void _promptForProfessionalHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Professional Help Required"),
          content: const Text(
              "It seems like you might need professional support. Would you like to chat with a real person or book an appointment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkForAvailableProfessionals();
              },
              child: const Text("Chat with a real person"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bookAppointment();
              },
              child: const Text("Book an appointment"),
            ),
          ],
        );
      },
    );
  }

  void _checkForAvailableProfessionals() {
    const available = false; // Simulate no professional available

    if (available) {
      setState(() {
        _messages.add({"sender": "System", "text": "Connecting you to a professional..."});
      });
    } else {
      _bookAppointment();
    }
  }

  void _bookAppointment() {
    setState(() {
      _messages.add({"sender": "System", "text": "No professionals available at the moment. Please book an appointment."});
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
        title: const Text('Chat'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: Column(
        children: [
          SizedBox(height: 16), // Space between header and first message
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the ScrollController
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message["sender"] == "User";
                return Row(
                  mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isUserMessage) _buildAvatar(isUser: false),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? const Color.fromARGB(255, 124, 175, 36) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: MarkdownBody(
                          data: message["text"]!,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(color: isUserMessage ? Colors.white : const Color.fromARGB(255, 8, 119, 204)),
                          ),
                        ),
                      ),
                    ),
                    if (isUserMessage) _buildAvatar(isUser: true),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
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
              onPressed: () {},
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

  Widget _buildAvatar({required bool isUser}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundColor: isUser ? const Color.fromARGB(255, 124, 175, 36) : const Color.fromARGB(255, 8, 119, 204),
        child: Icon(
          isUser ? Icons.person : Icons.android,
          color: Colors.white,
        ),
      ),
    );
  }
}

