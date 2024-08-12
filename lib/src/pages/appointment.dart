import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});
  static const routeName = '/Appointments';

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final List<Map<String, String>> _appointments = [
    {
      'date': '2024-08-15',
      'time': '10:00 AM',
      'issue': 'Anxiety',
      'professional': 'Dr. Jane Doe',
    },
    {
      'date': '2024-08-15',
      'time': '11:30 AM',
      'issue': 'Depression',
      'professional': 'Dr. John Smith',
    },
    {
      'date': '2024-08-15',
      'time': '1:00 PM',
      'issue': 'Stress Management',
      'professional': 'Dr. Emily Johnson',
    },
  ];

  String _activitySuggestions = '';
  late GenerativeModel _model;
  late ChatSession _chat;
  final ScrollController _scrollController = ScrollController();

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

  Future<void> _fetchSuggestions(String issue) async {
    setState(() {
      _activitySuggestions = '';
    });

    final responseStream = _chat.sendMessageStream(
      Content.text('Suggest activities for someone dealing with $issue.'),
    );

    await for (final response in responseStream) {
      setState(() {
        _activitySuggestions += response.text ?? '';
      });

      // Scroll to the bottom
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String date = '';
        String time = '';
        String issue = '';
        String professional = '';

        return AlertDialog(
          title: const Text('Request for Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                onChanged: (value) => date = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Time (HH:MM AM/PM)'),
                onChanged: (value) => time = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Issue'),
                onChanged: (value) => issue = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Professional'),
                onChanged: (value) => professional = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _appointments.add({
                    'date': date,
                    'time': time,
                    'issue': issue,
                    'professional': professional,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: const Color(0xFF1b263b),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Appointments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(color: Colors.black.withOpacity(0.5)),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5))),
                  ),
                  children: [
                    TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text('Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)))),
                    TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text('Time', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)))),
                    TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text('Issue', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)))),
                    TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text('Professional', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)))),
                  ],
                ),
                ..._appointments.map((appointment) {
                  return TableRow(
                    children: [
                      TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text(appointment['date']!))),
                      TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text(appointment['time']!))),
                      TableCell(
                        child: GestureDetector(
                          onTap: () => _fetchSuggestions(appointment['issue']!),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              appointment['issue']!,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(child: Container(padding: const EdgeInsets.all(8.0), child: Text(appointment['professional']!))),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "AI-Generated Suggestions While You Wait:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                MarkdownBody(
                  data: _activitySuggestions,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16),
                    blockquotePadding: const EdgeInsets.all(10),
                    blockquoteDecoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAppointmentDialog,
        backgroundColor: const Color.fromARGB(255, 166, 183, 213),
        child: const Icon(Icons.add),
      ),
    );
  }
}








