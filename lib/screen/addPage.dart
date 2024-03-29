import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/cutomWidget/scroll_date.dart';
import 'package:that_day/service/notificationHelper.dart';
import '../adHelper.dart';
import '../cutomWidget/inputText_widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:action_slider/action_slider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

late StreamSubscription<bool> keyboardSubscription;
var keyboardVisibilityController = KeyboardVisibilityController();

class AddPage extends StatefulWidget {
  const AddPage(this.id, {Key? key}) : super(key: key);
  final int id;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _controller = ActionSliderController();
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    print('rebuilding paddpage');
    int id = widget.id;
    int buttonColor = Colors.white.value;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    String title = '';
    String content = '';
    int alarm = 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Center(
          child: Text(
            'Add Event',
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

            Scroll_date(DateTime.now(), (dateTime) {
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
                InputText_widget(TextEditingController(text: title), (input) {
                  title = input;
                }, 'Title', 1),
                const Center(child: Text('Content')),
                InputText_widget(TextEditingController(text: content),
                    (input) {
                  content = input;
                }, 'Content', 8),
              ],
            ),
            BlockPicker(
              pickerColor: Color(buttonColor),
              onColorChanged: (color) {
                FocusManager.instance.primaryFocus?.unfocus();
                buttonColor = color.value;
              },
              availableColors: [
                Color(buttonColor),
                Colors.pinkAccent,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ActionSlider.standard(
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
                child: const Text(
                  'Swipe Alarm',
                  style: TextStyle(fontSize: 15),
                ),
                action: (controller) async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (DateTime.now().isBefore(DateTime(year, month, day))) {
                    alarm = 1;
                    controller.loading(); //starts loading animation
                    await Future.delayed(const Duration(seconds: 1));
                    controller.success();
                  } else {
                    alarm = 0;
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        'Not allowed past alarm',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: ElevatedButton(
                onPressed: () {
                  if (title != '' && content != '') {
                    DBDao dao = DBDao(
                        year, day, month, title, content, buttonColor, alarm);
                    DBHelper helper = DBHelper();
                    helper.insert(dao);
                    if (alarm == 1) {
                      NotificationHelper notificationHelper =
                      NotificationHelper();
                      notificationHelper.createNotification(
                          id, title, content, DateTime(year, month, day));
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
      )),
    );
  }

  @override
  void initState() {
    print('initstate addPage');

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
