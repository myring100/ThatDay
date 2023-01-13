import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';
import 'package:that_day/service/notificationHelper.dart';
import 'package:that_day/service/utilities.dart';
import '../cutomWidget/inputText_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:action_slider/action_slider.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _controller = ActionSliderController();

  @override
  Widget build(BuildContext context) {
    int buttonColor = Colors.white.value;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    String date = '$year-$month-$day';
    String title = '';
    String content = '';
    int alarm = 0;
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
            DBDao dao =
                DBDao(year, day, month, title, content, buttonColor, alarm);
            DBHelper helper = DBHelper();
            helper.insert(dao);
            if (alarm == 1) {
              NotificationHelper notificationHelper = NotificationHelper();
              notificationHelper.createNotification('hi', 'test',
                  DateTime(year,month,day));
            }
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
              }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Title')),
                  InputText_widget(TextEditingController(text: ''), (input) {
                    title = input;
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget(TextEditingController(text: ''), (input) {
                    content = input;
                  }, 'Content', 5),
                ],
              ),
              BlockPicker(
                pickerColor: Color(buttonColor),
                onColorChanged: (color) {
                  buttonColor = color.value;
                  print("button color changed to $buttonColor");
                },
                availableColors: [
                  Color(buttonColor),
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.purple
                ],
                itemBuilder: customItembuilder_colorPicker,
                layoutBuilder: customLayoutBuilder,
              ),
              ActionSlider.standard(
                width: 250,
                height: 50,
                controller: _controller,
                successIcon: IconButton(
                  onPressed: () {
                    alarm = 0;
                    _controller.reset();
                  },
                  icon: Icon(Icons.alarm),
                ),
                child: const Text('Set Alarm'),
                action: (controller) async {
                  alarm = 1;
                  controller.loading(); //starts loading animation
                  await Future.delayed(const Duration(seconds: 1));
                  controller.success();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customItembuilder_colorPicker(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 5)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget customLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 400,
      height: orientation == Orientation.portrait ? 80 : 80,
      child: GridView.count(
        crossAxisCount: 6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }
}
