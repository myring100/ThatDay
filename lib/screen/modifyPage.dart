import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';
import '../cutomWidget/inputText_widget.dart';

class ModifyPage extends StatefulWidget {
 final DBDao table;
 final int id;

  const ModifyPage(this.id,this.table,{Key? key}) : super(key: key);

  
  @override
  State<ModifyPage> createState() => _ModifyPage();
}

class _ModifyPage extends State<ModifyPage> {
  
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate ;
    int year = widget.table.year;
    int month = widget.table.month;
    int day = widget.table.day;

    selectedDate = DateTime(year,month,day);
    String date = '$year-$month-$day';
    String title = widget.table.title;
    String content = widget.table.content;
    int backGround = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Modify Event',style: TextStyle(fontSize: 20,color: Colors.white),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //:todo 여기서 뒤로 돌아가는 버튼이 생선된다.
        onPressed: () async {
          DBDao dao = DBDao(year, day, month, title, content,backGround);
          DBHelper helper = DBHelper();

          //todo 여기서 modify 를 id를 통해서 해야 한다.
         await helper.modify(widget.id,dao).then((value) =>Get.to(()=> const FirstPage()));
        },
        tooltip: 'ADD',
        child: const Icon(Icons.check, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Scroll_date(selectedDate,(dateTime) {
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
                  InputText_widget(TextEditingController(text: title),(input) {
                    title = input;
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget(TextEditingController(text: content),(input) {
                    content = input;
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
