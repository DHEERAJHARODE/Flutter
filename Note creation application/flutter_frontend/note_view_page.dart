import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteViewPage extends StatefulWidget {
  @override
  _NoteViewPageState createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  List<Map<String, dynamic>> _notes = []; // List to store notes from the back-end

  Future<void> _getNotes() async {
    final url = 'http://localhost:8000/api/notes/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _notes = responseData.cast<Map<String, dynamic>>();
      });
    } else {
      // Handle error while fetching notes
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch notes. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Notes')),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(_truncateContent(note['content'])), // Show a preview of the content
          );
        },
      ),
    );
  }

  String _truncateContent(String content) {
    if (content.length <= 50) {
      return content;
    } else {
      return content.substring(0, 50) + '...';
    }
  }
}
