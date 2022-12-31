import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';

import '../cutomWidget/inputText_widget.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    int buttonColor = 123456;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    String date = '$year-$month-$day';
    String title = '';
    String content = '';
    int backGround = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Event',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //:todo 여기서 뒤로 돌아가는 버튼이 생선된다.
        onPressed: () {
          if (title != '' && content != '') {
            DBDao dao = DBDao(year, day, month, title, content, backGround);
            DBHelper helper = DBHelper();
            helper.insert(dao);
            Get.to(() => const FirstPage());
          } else {
            SnackBar snackBar = const SnackBar(
              content: Text(
                'Please Fill Form',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        tooltip: 'ADD',
        child: const Icon(Icons.check, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Scroll_date(DateTime.now(), (dateTime) {
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
                  InputText_widget(TextEditingController(text: ''), (input) {
                    title = input;
                    print('title changed to $title');
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget(TextEditingController(text: ''), (input) {
                    content = input;
                    print('content changed to $content');
                  }, 'Content', 5),
                ],
              ),
              Container(
                child: CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: true,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: const [
                    'Blue',
                    'Red',
                    'Orange',
                    'White',
                  ],
                  buttonValues: const [
                    'Blue',
                    'Red',
                    'Orange',
                    'White',
                  ],
                  buttonTextStyle:  ButtonTextStyle(
                      selectedColor: Color(buttonColor),
                      unSelectedColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    print(value);
                  },
                  selectedColor: Theme.of(context).accentColor,
                ),
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
