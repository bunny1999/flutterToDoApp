
class Note{

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  
  //when there is new note, id will be automatically genrated, that time we call this,
  Note(this._title,this._date,this._priority,[this._description]);
  //when we edit any note that time this function will be called
  //this .withID is defined by us to deffencate with while calling, these are type of funtion
  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id => _id;
  //from title giving data to _title
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String newTitle){
    if(newTitle.length <= 255){
      this._title = newTitle;
    }
  }

  set description(String newDescription){
    if(newDescription.length <= 255){
      this._description = newDescription;
    }
  }

  set date(String newDate){
    this._date = newDate;
  }

  set priority(int newPriority){
    if(newPriority >=1 && newPriority <=2 ){
      this._priority =newPriority;
    }
  }

  //use to save and retrive database

  //to save value after maping it into database
  Map<String, dynamic> toMap(){
    print("request");
    var map = Map<String, dynamic>();
    //this id thing is only call when we call Note.withId(), so that means here we are saving data on Either funtion call due to this if statement
    if(id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    print("send");
    return map;
  }

  //to retrive value from maps
  //this .fromMapObject is defined by us to deffenciate while calling 
  //here we are passing a map object and that will save the corresponding value to veriables
  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description =  map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}