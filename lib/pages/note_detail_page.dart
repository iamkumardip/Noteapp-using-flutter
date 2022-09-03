import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/db/notes_database.dart';
import 'package:noteapp/pages/edit_note_page.dart';


import '../models/note.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) :super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {

  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 2, 44),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 38, 38, 73),
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: EdgeInsets.all(12),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                Text(
                  note.title,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  DateFormat.yMMMd().format(note.createdTime),
                  style: TextStyle(color: Colors.white38),
                ),
                SizedBox(height: 8),
                Text(
                  note.description,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                )
              ],
            ),
            )
    );
  }
  Widget editButton() => IconButton(
    icon: Icon(Icons.edit_outlined),
    onPressed: () async{
      if(isLoading) return;

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditNotePage(note: note),
      ));

      refreshNote();
    });

    Widget deleteButton() => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await NotesDatabase.instance.delete(widget.noteId);

        Navigator.of(context).pop();
      },
    );
    
    
}