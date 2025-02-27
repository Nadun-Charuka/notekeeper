import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeperapp/models/note.dart';
import 'package:notekeeperapp/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  const NoteDetails({super.key, required this.appBarTitle, required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  static final _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                value: 'Low',
                style: textStyle,
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint('user selected $valueSelectedByUser');
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something change on Title Text Feild");
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint("Something change on Description Feild");
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).primaryColorLight,
                    ),
                    child: Text(
                      "Save",
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("save");
                        _save();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).primaryColorLight,
                    ),
                    child: Text(
                      "Delete",
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("Delete");
                        _delete();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void _save() async {
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (widget.note.id != null) {
      result = await helper.updateNote(widget.note);
    } else {
      result = await helper.insertNote(widget.note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note saved sucessfully');
    } else {
      _showAlertDialog('Status', 'Problem in saving note');
    }
    moveToLastScreen();
  }

  void _delete() async {
    if (widget.note.id == null) {
      _showAlertDialog('Status', "Note cant delete");
    }
    int result = await helper.deleteNote(widget.note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note deleted sucessfully');
    } else {
      _showAlertDialog('Status', 'Problem occure while deleting note');
    }
    moveToLastScreen();
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
