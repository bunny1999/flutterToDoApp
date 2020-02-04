import 'package:flutter/material.dart';
import 'package:mytodo/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../Note.dart';
import 'dart:async';
import 'note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    //every time befor the scaffold to run, when we deleted everything and notelist is empty
    if(noteList == null){
      noteList = List<Note>();
      updateView();
    }
    return Scaffold(
      backgroundColor: Color(0xff3C4248),
      appBar: AppBar(
        title: Text("ToDo Bucket",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xffE65C8B),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Color(0xffE65C8B),
        elevation: 3.0,
        onPressed: (){
          nevigateToDetails(Note('','',2),"Add ToDo");
        },
      ),
    );
  }
  ListView getListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context,postion){
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // color: Color(0xffE86C9A),
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://learncodeonline.in/mascot.png"),
            ),
            title: Text(noteList[postion].title,
              style:TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,) ,
            ),
            subtitle: Text( noteList[postion].date,
              style: TextStyle(),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new,color: Color(0xffE86C9A),),
              onTap: (){
                nevigateToDetails(this.noteList[postion],"Edit ToDo");
              },
            ),
          ),
        );
      },
    );
  }

  //we are sending this full note to detials page there we will access
  void nevigateToDetails(Note note,String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return NoteDeatils(note,title);
      }
    ));
    if(result == true){
      //every time we go to details page it will update
      updateView();
    }
  }

  //this thing will run very time when come to main page
  void updateView(){
    //initizalzing the database 
    final Future<Database> dbFuture = databaseHelper.intializeDatabase();
    //when initalized then
    dbFuture.then((database){
      //geting list of notes from the database
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      //when list is got
      noteListFuture.then((noteList){
        //set the data to the class list
        setState(() {
          this.noteList = noteList;
          this.count =  noteList.length;
        });
      });
    });
  }
}