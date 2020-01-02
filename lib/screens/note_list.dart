import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {
  int count = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: getNotesListView(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Add Note",
          onPressed: () {
            navigateToDetail("Add Note");
          }),
    );
  }

  ListView getNotesListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.keyboard_arrow_right),
                ),
                title: Text("Dummy Title", style: textStyle),
                subtitle: Text("Dummy Sub Title"),
                trailing: Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  navigateToDetail("Edit Note");
                },
              ));
        });
  }

  void navigateToDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title);
    }));
  }
}
