import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/dDayList/dDayList.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/screen/scroll_date.dart';

import 'inputText_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    //todo  make callback function for date content to retrive data from widget and then get ready for summit value to database
    int year;
    int month;
    int day;
    String date;
    String title;
    String content;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //:todo 여기서 뒤로 돌아가는 버튼이 생선된다.
        onPressed: () {

        },
        tooltip: 'ADD',
        child: const Icon(Icons.check, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Scroll_date((dateTime) {
                year = dateTime.year;
                month = dateTime.month;
                day = dateTime.day;
                date = '$year-$month-$day';
                print('year = $year month = $month day = $day date = $date');
              }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Title')),
                  InputText_widget((input) {
                    title = input;
                    print('title changed to $title');
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget((input) {
                    content = input;
                    print('content changed to $content');
                  }, 'Content', 5),
                ],
              ),
              Container(
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }

}
