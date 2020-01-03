import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState(note, appBarTitle);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  var _formKey = GlobalKey<FormState>();
  static var _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String appBarTitle;
  Note note;

  DatabaseHelper databaseHelper = DatabaseHelper();

  _NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(appBarTitle),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      moveToLastScreen();
                    })),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListView(children: <Widget>[
                      ListTile(
                          title: DropdownButton(
                              items: _priorities.map((String dropDownItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownItem,
                                  child: Text(dropDownItem),
                                );
                              }).toList(),
                              value: getPriorityAsString(note.priority),
                              style: textStyle,
                              onChanged: (String value) {
                                setState(() {
                                  updatePriorityAsInt(value);
                                });
                              })),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextFormField(
                            controller: titleController,
                            style: textStyle,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please Enter Title';
                              }
                            },
                            onChanged: (String text) {
                              updateTitle();
                            },
                            decoration: InputDecoration(
                                labelText: "Title",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextFormField(
                            controller: descriptionController,
                            style: textStyle,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please Enter Description';
                              }
                            },
                            onChanged: (String text) {
                              updateDescription();
                            },
                            decoration: InputDecoration(
                                labelText: "Description",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                                    color: Theme.of(context).primaryColorDark,
                                    textColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Text("Save", textScaleFactor: 1.5),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKey.currentState.validate()) {
                                          _save();
                                        }
                                      });
                                    })),
                            Container(width: 5.0),
                            Expanded(
                                child: RaisedButton(
                                    color: Theme.of(context).primaryColorDark,
                                    textColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Text("Delete", textScaleFactor: 1.5),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKey.currentState.validate()) {
                                          _delete();
                                        }
                                      });
                                    }))
                          ]))
                    ])))));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert String Priority to int
  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case "High":
        note.priority = 1;
        break;

      case "Low":
        note.priority = 2;
        break;
    }
  }

  // Convert int Priority to String
  String getPriorityAsString(int priority) {
    String value;
    switch (priority) {
      case 1:
        value = _priorities[0];
        break;

      case 2:
        value = _priorities[1];
        break;
    }
    return value;
  }

  //update the title
  void updateTitle() {
    note.title = titleController.text;
  }

  //update the description
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // save data to database
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMMd().format(DateTime.now());
    int result;

    if (note.id != null) {
      //Update
      result = await databaseHelper.updateNote(note);
    } else {
      //Insert
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      //Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      //Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      // delete new note
      _showAlertDialog('Status', 'No Note was Deleted');
      return;
    }
    // delete existing note
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      //Success
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      //Failure
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }
}
