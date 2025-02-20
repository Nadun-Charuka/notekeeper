import 'package:flutter/material.dart';
import 'package:notekeeperapp/screens/note_details.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
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
          navigationToDetailPage("Add Note");
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              "Dummy Title",
              style: titleStyle,
            ),
            subtitle: Text("Dummy Date"),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigationToDetailPage("Edit Note");
            },
          ),
        );
      },
    );
  }

  void navigationToDetailPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetails(
          appBarTitle: title,
        ),
      ),
    );
  }
}
