class DBDao {
  int year;
  int day;
  String month;
  String title;
  String content;

  DBDao(this.year, this.day, this.month, this.title, this.content);

  Map toMap(){
    return Map.from({
    "Column_year" : year,
    "Column_day" : day;
    "Column_month" : month;
    "Column_title" : title;
    "Column_content" : content;
    });


    
  }


}