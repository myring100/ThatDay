class DBDao {
  int year;
  int day;
  int month;
  String title;
  String content;
  int backGround;

  DBDao(this.year, this.day, this.month, this.title, this.content,this.backGround);

  Map<String , Object> toMap(){
    return Map.from({
    "year" : year,
    "month" : month,
    "day" : day,
    "title" : title,
    "content" : content,
      "backGround" : backGround,
    });


    
  }


}