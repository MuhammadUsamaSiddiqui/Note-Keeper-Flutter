import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;

  NoteDetail(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState(appBarTitle);
  }
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];
  var _selectedDropDownItem = _priorities[1];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String appBarTitle;

  _NoteDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

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
            body: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: ListView(children: <Widget>[
                  ListTile(
                      title: DropdownButton(
                          items: _priorities.map((String dropDownItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownItem,
                              child: Text(dropDownItem),
                            );
                          }).toList(),
                          value: _selectedDropDownItem,
                          style: textStyle,
                          onChanged: (String value) {
                            setState(() {
                              _selectedDropDownItem = value;
                              debugPrint("User Selected $value");
                            });
                          })),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: titleController,
                        style: textStyle,
                        onChanged: (String text) {
                          debugPrint(
                              "Some thing has changed in the title text field");
                        },
                        decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (String text) {
                          debugPrint(
                              "Some thing has changed in the description text field");
                        },
                        decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text("Save", textScaleFactor: 1.5),
                                onPressed: () {
                                  setState(() {
                                    debugPrint("Save Button Clicked");
                                  });
                                })),
                        Container(width: 5.0),
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text("Delete", textScaleFactor: 1.5),
                                onPressed: () {
                                  setState(() {
                                    debugPrint("Delete Button Clicked");
                                  });
                                }))
                      ]))
                ]))));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
