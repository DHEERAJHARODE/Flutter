import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteCreatePage extends StatefulWidget {
  @override
  _NoteCreatePageState createState() => _NoteCreatePageState();
}

class _NoteCreatePageState extends State<NoteCreatePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Future<void> _createNote() async {
    final url = 'http://localhost:8000/api/notes/';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'title': _titleController.text,
        'content': _contentController.text,
      },
    );

    if (response.statusCode == 201) {
      // Handle successful note creation
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Note Created'),
            content: Text('Your note has been created successfully.'),
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
    } else {
      // Handle note creation error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Note Creation Error'),
            content: Text('Failed to create the note. Please try again.'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Note')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _createNote,
              child: Text('Create Note'),
            ),
          ],
        ),
      ),
    );
  }
}
