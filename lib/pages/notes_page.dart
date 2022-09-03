
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:noteapp/db/notes_database.dart';

import 'package:noteapp/pages/edit_note_page.dart';
import 'package:noteapp/pages/note_detail_page.dart';
import '../models/note.dart';
import '../widget/note_card_widget.dart';


class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoading = false;
  late List<Note> notes;

  @override
  void initState(){
    super.initState();

    refreshNotes();
  }

  @override
  void dispose(){
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async{
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 14, 2, 44),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 38, 38, 73),
          centerTitle: true,
          title: const Text('Notes',
          style:TextStyle(fontSize: 24)
          ),
        ),
        body: Center(
          child: isLoading ? const CircularProgressIndicator()
          :notes.isEmpty
          ? const Text('No Notes',
          style: TextStyle(color: Colors.white, fontSize: 24),
          )
          : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 252, 250, 250),
          child: Icon(Icons.add, color: Colors.redAccent,),
          onPressed:() async{
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );
            refreshNotes();
          },
        ),
      )
    );

  }
  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];
      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteDetailPage(noteId: note.id!),
          ));
          refreshNotes();
        },
        child: NoteCardWidget(note: note, index: index),
      );
    },
  );
   
}