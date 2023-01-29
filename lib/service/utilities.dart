class Utilities {

  static String getDDay(DateTime selectedDate){
    DateTime now = DateTime.now();
    int gap = selectedDate.difference(now).inDays;
    if(now.isAfter(selectedDate)){
      return "-${gap.toString()}";
    }
    else {
      return "+${gap.toString()}";

    }
  }

}