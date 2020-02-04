import 'package:flutter/material.dart';
import '../Note.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';

class NoteDeatils extends StatefulWidget {
  final Note note;
  final String appBarTitle;
  NoteDeatils(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDeatilsState(this.note,this.appBarTitle);
  }
}

class NoteDeatilsState extends State<NoteDeatils> {
  List _priorities = ['LOW','HIGH'];
  DatabaseHelper databaseHelper = DatabaseHelper();
  Note note;
  String appBarTitle;
  NoteDeatilsState(this.note,this.appBarTitle);
  
  //these controler are like event listener of text input area
  TextEditingController textControlTitle = TextEditingController();
  TextEditingController textControlDescription = TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    //this is some style for text inputs
    TextStyle textStyle = Theme.of(context).textTheme.title;

    textControlTitle.text = note.title;
    textControlDescription.text = note.description;
    return WillPopScope(
      onWillPop: (){
        mainScreenView();
      },
      child: Scaffold(
        backgroundColor: Color(0xff3C4248),
        appBar: AppBar(
          title: Text(appBarTitle, style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xffE86C9A),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              mainScreenView();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                  //dropdown menu
                  child: new ListTile(
                    leading: const Icon(Icons.low_priority,color: Color(0xffE86C9A),),
                    title: DropdownButton(
                        items: _priorities.map((dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          );
                        }).toList(),
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        }),
                  ),
                ),
                //secound Element
                Padding(
                  padding: EdgeInsets.only(top:15.0,bottom:15.0,left:15.0),
                  child: TextField(
                    controller: textControlTitle,
                    cursorColor: Color(0xffE86C9A),
                    style: textStyle,
                    onChanged: (value){
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      fillColor: Color(0xffE86C9A),
                      hoverColor: Color(0xffE86C9A),
                      focusColor: Color(0xffE86C9A),
                      icon:Icon(Icons.title,color: Color(0xffE86C9A),),
                    ),
                  ),
                ),
                //third Element
                Padding(
                  padding: EdgeInsets.only(top:15.0,bottom:15.0,left:15.0),
                  child: TextField(
                    controller: textControlDescription,
                    style: textStyle,
                    onChanged: (value){
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      fillColor: Color(0xffE86C9A),
                      hoverColor: Color(0xffE86C9A),
                      focusColor: Color(0xffE86C9A),
                      icon:Icon(Icons.description,color: Color(0xffE86C9A)),
                    ),
                  ),
                ),
                //fourth item
                Padding(
                  padding: EdgeInsets.only(top:15.0,bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            "Save",
                            textScaleFactor: 1.5,
                          ),
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: (){
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: (){
                            _delete();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateTitle(){
    note.title =  textControlTitle.text;
  }
  void updateDescription(){
    note.description =  textControlDescription.text;
  }
  void mainScreenView(){
    Navigator.pop(context,true);
  }
  void _showalertBox(String heading,String content){
    AlertDialog alertDialog =  AlertDialog(
      title: Text(heading),
      content: Text(content),
    );
    showDialog(context: context,builder: (_)=> alertDialog);
  }
  void _save() async{
    print("Content:"+note.title+"Des"+note.description);
    print(note.priority);
    mainScreenView();
    note.date= DateFormat.yMMMd().format(DateTime.now());
    print(note.date);
    int result;
    if(note.id!=null){
      result = await databaseHelper.updateNote(note);
    }
    else{
      print("enter");
      result = await databaseHelper.insertNote(note);    
      print('exit');
    }
    print("result");
    print(result);
    if(result != 0){
      _showalertBox("Status", "Note Saved Sucessfully");
    }
    else{
      _showalertBox("Status", "Error Saving Note");
    }
  }

  void _delete() async{
    mainScreenView();

    if(note.id==null){
      _showalertBox("Alert", "No Note Found");
    }
    
    int result= await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showalertBox("Status", "Note Deleted");
    }
    else{
      _showalertBox("Status", "Error Deleting Note");
    }
  }

  //convert database int formate priority to string formate for UI
  String getPriorityAsString(int value){
    String result;
    switch(value){
      case 1: 
      result = _priorities[0]; 
      break;
      case 2: 
      result = _priorities[1];
      break;
    }
    return result;
  }

  //convert string to int to save into database
  void updatePriorityAsInt(String value){
    switch(value){
      case 'LOW':
        note.priority= 1;
        break;
      case 'HIGH':
        note.priority =2;
        break;
    }
  }
}