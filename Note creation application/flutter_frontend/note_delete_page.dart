import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteDeletePage extends StatefulWidget {
  @override
  _NoteDeletePageState createState() => _NoteDeletePageState();
}

class _NoteDeletePageState extends State<NoteDeletePage> {
  List<Map<String, dynamic>> _notes = []; // List to store notes from the back-end

  Future<void> _getNotes() async {
    final url = 'http://localhost:8000/api/notes/$noteId/';
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

  Future<void> _deleteNote(int noteId) async {
    final url = 'http://your-backend-url/api/notes/$noteId/';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204) {
      // Handle successful note deletion
      setState(() {
        _notes.removeWhere((note) => note['id'] == noteId);
      });
    } else {
      // Handle note deletion error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Note Deletion Error'),
            content: Text('Failed to delete the note. Please try again.'),
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
      appBar: AppBar(title: Text('Delete Note')),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['content']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note['id']),
            ),
          );
        },
      ),
    );
  }
}
