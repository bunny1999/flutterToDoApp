import 'Note.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  
  static DatabaseHelper _databaseHelper;
  static Database _database ;

  //this is somthing like header of excel sheet table
  //outerframe of database
  //noteTable is a Sheet Name/ Table Name of that database
  String noteTable = 'notetable';
  //these are column names
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper._createInstance();

  //this is called as singleton methord, this is called only once 
  factory DatabaseHelper(){
    //it will create the instance Of that sheet if it is not created and saved into _databaseHelper 
    //otherwise return the instance 
    if(_databaseHelper ==  null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  //custom getter
  //to get database innerMaterial, if not created then start creating the innerMaterial of Table
  //return type will be Database
  Future<Database> get database async{

    if(_database == null){
      _database = await intializeDatabase();
    }

    //if it is present then will will be return directly otherwise,
    //first it will go to initalize....()  from that,
    //it will got to _createDb()
    //_createDb -> initalize....() -> _database (here)
    return _database;
  }

  //creating the database innerMaterial
  //return type will be Database
  Future<Database> intializeDatabase() async{

    //we are using path_provider here, this will give the current loaction of our file
    Directory directory = await getApplicationDocumentsDirectory();
    //complete my path name for db file, where database name is notes.db
    String path = directory.path  + 'notes.db';

    //opening the database
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    // after this _createDb calling, it will jump to another funtion

    //after fnishing the _createDb it will save data to notesDatabase and return
    return notesDatabase;  
  }
//INCLUDE AUTO INCREMENT
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colID INTERGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  /*
  Actually after doing all this {from getter for database} [if not intialized] -> {intializeDatabase()} [if notesDatabase not created] -> {_creteDb()}
  we are returning the actuall database to getter 'database',
  _database is used as returner,
  "So Our Database is Stored in database" 
  */

  //funtion to get List of (Maped) OBJECTS
  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    var result = await db.query(noteTable, orderBy:'$colPriority ASC');
    return result;
  }

  //in getNoteMapList() we are geting objects but we want the data of that objects
  //so we will use Note.fromMapObject to unmap the data
  //this function will give the List of unmaped notes
  Future<List<Note>> getNoteList() async{
    var noteMapList =  await getNoteMapList();

    int count = noteMapList.length;
    //new list to return
    List<Note> noteList = List<Note>();
    for(int i=0;i< count;i++){
      //everytime a new maped object from getNoteMapList() passed to Note.fromMapObject to unmap it and save into new list
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

  //from now it will of int type becouse these opertion in database returns susses or fail

  //Note class object is passed
  Future<int> insertNote(Note note) async{
    print("1"+note.title+note.description);
    print("2");
    print(note.priority);
    print("3");
    print(note.date);
    print("4");
    print(note.id);
    Database db = await this.database;
    print(db);
    //values will be passed to note class variables from UI then this toMap is called from here to map the values and save them  
    var result= await db.insert(noteTable,note.toMap());
    print("done");
    print(result);
    return result;
  }

  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    // var reuslt =  await db.rawUpdate('UPDATE $noteTable SET ${note.toMap()} WHERE $colId=${note.id}');
    var result = await db.update(noteTable, note.toMap(),where:'$colID = ?',whereArgs: [note.id]);
    return result;
  }

  //u can write note.id if u want to pass Note object or simply id if u want to pass value of id 
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colID = $id');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;

    //as this query will give a lot of data then we think in reallty
    List<Map<String, dynamic>> x= await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    //so for geting the only count we have to filter it out using sqflite funtion 
    var result = Sqflite.firstIntValue(x);
    return result;
  }
}