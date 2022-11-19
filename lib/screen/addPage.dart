import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    String date;
    String title;
    String content;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        tooltip: 'ADD',
        child: const Icon(Icons.check, size: 30),
      ),
      body: SafeArea(
        child: Column(
          children: [
              const Expanded(
               flex: 3,
                child: Scroll_date(),
            ),
            Expanded(
              flex: 2,
                child: InputText_widget((input){
                  title = input;
                  print('title changed to $title');
                },'Title')),
            Expanded(
              flex: 2,
                child: Container(
              color: Colors.green,
            )),
          ],
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }
}
