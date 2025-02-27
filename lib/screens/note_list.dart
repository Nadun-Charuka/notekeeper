import 'package:flutter/material.dart';
import 'package:notekeeperapp/models/note.dart';
import 'package:notekeeperapp/screens/note_details.dart';
import 'package:notekeeperapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList ??= <Note>[];
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB clicked");
          navigationToDetailPage(
              Note(
                id: 1,
                title: '',
                date: '',
                priority: 'High',
              ),
              "Add Note");
        },
        tooltip: "Add note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headlineMedium;
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList![index].priority),
              child: getPriorityIcon(noteList![index].priority),
            ),
            title: Text(
              noteList![index].title,
              style: titleStyle,
            ),
            subtitle: Text(noteList![index].description!),
            trailing: GestureDetector(
              onDoubleTap: () {
                _delete(context, noteList![index]);
              },
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigationToDetailPage(noteList![index], "Edit Note");
            },
          ),
        );
      },
    );
  }

  //return the priority color
  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Low":
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  //return the priority icon
  Icon getPriorityIcon(String priority) {
    switch (priority) {
      case "High":
        return Icon(Icons.play_arrow);
      case "Low":
        return Icon(Icons.keyboard_arrow_right);
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  //delete
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) _showSnackBar(context, 'Note Deleted Successfully');
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigationToDetailPage(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetails(
          appBarTitle: title,
          note: note,
        ),
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((Database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
