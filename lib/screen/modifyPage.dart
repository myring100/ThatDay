import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';
import '../adHelper.dart';
import '../cutomWidget/inputText_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:action_slider/action_slider.dart';

import '../service/notificationHelper.dart';

late StreamSubscription<bool> keyboardSubscription;
var keyboardVisibilityController = KeyboardVisibilityController();

class ModifyPage extends StatefulWidget {
  final DBDao table;
  final int id;

  const ModifyPage(this.id, this.table, {Key? key}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPage();
}

class _ModifyPage extends State<ModifyPage> {
  final _controller = ActionSliderController();
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    print('getten ID in modifiy page = $id');
    DateTime selectedDate;
    int year = widget.table.year;
    int month = widget.table.month;
    int day = widget.table.day;
    selectedDate = DateTime(year, month, day);
    String title = widget.table.title;
    String content = widget.table.content;
    int buttonColor = widget.table.backGround;
    int alarm = widget.table.alarm == 0 ? 0 : 1;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Center(
          child: Text(
            'Modify Event',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
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
                if (DateTime(year, month, day).isBefore(DateTime.now())) {
                  _controller.reset();
                }
              }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Title')),
                  InputText_widget(TextEditingController(text: title),
                      (input) {
                    title = input;
                  }, 'Title', 1),
                  const Center(child: Text('Content')),
                  InputText_widget(TextEditingController(text: content),
                      (input) {
                    content = input;
                  }, 'Content', 7),
                ],
              ),
              BlockPicker(
                pickerColor: Color(buttonColor),
                onColorChanged: (color) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  buttonColor = color.value;
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
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ActionSlider.standard(
                width: 250,
                height: 50,
                controller: _controller,
                successIcon: IconButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    alarm = 0;
                    _controller.reset();
                  },
                  icon: const Icon(Icons.alarm),
                ),
                child: const Text('Set Alarm'),
                action: (controller) async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.loading(); //starts loading animation
                  await Future.delayed(const Duration(seconds: 1));
                  if (DateTime.now().isAfter(DateTime(year, month, day))) {
                    alarm = 0;
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'Not allowed past alarm',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    controller.reset();
                  } else {
                    controller.success();
                    alarm = 1;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,8,0,8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (title != '' && content != '') {
                      if (alarm == 1) {
                        print('alarm = 1');
                        NotificationHelper notificationHelper =
                        NotificationHelper();
                        notificationHelper.cancelNoti(id);
                        notificationHelper.createNotification(
                            id, title, content, DateTime(year, month, day));
                      } else if (alarm == 0) {
                        print('alarm = 0');

                        NotificationHelper notificationHelper =
                        NotificationHelper();
                        notificationHelper.cancelNoti(id);
                      }
                      DBDao dao = DBDao(
                          year, day, month, title, content, buttonColor, alarm);
                      DBHelper helper = DBHelper();
                      await helper
                          .modify(widget.id, dao)
                          .then((value) => Get.to(() => const FirstPage()));
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
                  child: Icon(Icons.check, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(17),
                    backgroundColor: Colors.blue, // <-- Button color
                    foregroundColor: Colors.red, // <-- Splash color
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print('initstate ModifyPage');
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            super.setState(() {
              _bannerAd = ad as BannerAd;
            });
            print('admob onload');

          });
        },
        onAdFailedToLoad: (ad, err) {
          print(
              'admob Failed to load a banner ad: ${err.message} domain : ${err.responseInfo}');
          ad.dispose();
        },
      ),
    ).load();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.table.alarm == 1) {
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
}
