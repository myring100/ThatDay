import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';
import '../cutomWidget/inputText_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:action_slider/action_slider.dart';

import '../service/notificationHelper.dart';

class ModifyPage extends StatefulWidget {
  final DBDao table;
  final int id;

  const ModifyPage(this.id, this.table, {Key? key}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPage();
}

class _ModifyPage extends State<ModifyPage> {
  final _controller = ActionSliderController();

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate;
    int year = widget.table.year;
    int month = widget.table.month;
    int day = widget.table.day;
    selectedDate = DateTime(year, month, day);
    String date = '$year-$month-$day';
    String title = widget.table.title;
    String content = widget.table.content;
    int buttonColor = widget.table.backGround;
    int alarm = widget.table.alarm == 0 ? 0 : 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Modify Event',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //:todo 여기서 뒤로 돌아가는 버튼이 생선된다.
        onPressed: () async {
          DBDao dao =
              DBDao(year, day, month, title, content, buttonColor, alarm);
          DBHelper helper = DBHelper();

          //todo 여기서 modify 를 id를 통해서 해야 한다.
          await helper
              .modify(widget.id, dao)
              .then((value) => Get.to(() => const FirstPage()));
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
              Scroll_date(selectedDate, (dateTime) {
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
                  InputText_widget(TextEditingController(text: title), (input) {
                    title = input;
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget(TextEditingController(text: content),
                      (input) {
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
                availableColors: const [
                  Colors.white,
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
                    print('iconbutton tappaed');
                    _controller.reset();
                    alarm = 0;
                  },
                  icon: Icon(Icons.alarm),
                ),
                child: const Text('Set Alarm'),
                action: (controller) async {
                  controller.loading(); //starts loading animation
                  await Future.delayed(const Duration(seconds: 1));
                  controller.success();
                  alarm = 1;
                },
                stateChangeCallback: (state, actionState, controller) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if(widget.table.alarm==1){
        _controller.loading();
        await Future.delayed(const Duration(seconds: 1));
        _controller.success();
      }
    });

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
