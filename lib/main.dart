import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/service/notificationHelper.dart';
import 'package:that_day/service/utilities.dart';
import 'package:workmanager/workmanager.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_web_plugins/url_strategy.dart';

@pragma("vm:entry-point")
void callbackDispatcher() {
  print('callbackDispatcher');
  Workmanager().executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        'Updated from Background',
      ),
      HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        iOSName: 'HomeWidgetExample',
      ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
   // String showedTitle =  HomeWidget.getWidgetData('title').toString();
  if (data?.host == 'titleclicked') {
    HomeWidget.getWidgetData('title').then((previous) {
      DBHelper table = DBHelper();
      table.getDao().then((values) {
        print('value = $previous');
        var itar = values.iterator;
        while (itar.moveNext()) {
          String title = itar.current['title'].toString();
          if (values.last['title'] == previous) {
            print('match here value.last == previous');
            title = itar.current['title'].toString();
            int year = int.parse(itar.current['year'].toString());
            int month = int.parse(itar.current['month'].toString());
            int day = int.parse(itar.current['day'].toString());
            String gap = Utilities.getDDay(DateTime(year, month, day));

            HomeWidget.saveWidgetData<String>('title', title);
            HomeWidget.saveWidgetData<String>('message', gap);
            HomeWidget.updateWidget(
                name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
            break;
          }
          else if (previous == title) {
            print('match here previous == title');

            itar.moveNext();
            title = itar.current['title'].toString();
            int year = int.parse(itar.current['year'].toString());
            int month = int.parse(itar.current['month'].toString());
            int day = int.parse(itar.current['day'].toString());
            String gap = Utilities.getDDay(DateTime(year, month, day));

            HomeWidget.getWidgetData('title')
                .then((value) => debugPrint('*****get data == $value'));
            HomeWidget.saveWidgetData<String>('title', title);
            HomeWidget.saveWidgetData<String>('message', gap);
            HomeWidget.updateWidget(
                name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
            break;
          }
          else{
            print('nothing ********************');

          }
        }
      });
    });
  }
}

void main() {
  NotificationHelper.notificationInit();
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  setUrlStrategy(PathUrlStrategy());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('ontap()in main page');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapDown: (a) {
        print('ontap down()in main page');
      },
      child: GetMaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: 'That Day(D-Day)',
        theme:
            ThemeData(appBarTheme: AppBarTheme(color: Colors.lightBlue[500])),
        home: const FirstPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  Future<Future<List<bool?>>> _sendData() async {
    print('_sendData');
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', _titleController.text),
        HomeWidget.saveWidgetData<String>('message', _messageController.text),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
    throw {};
  }

  Future<Future<bool?>> _updateWidget() async {
    print('_updateWidget');
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
    throw {};
  }

  Future<Future<List<String?>>> _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
            .then((value) => _titleController.text = value!),
        HomeWidget.getWidgetData<String>('message',
                defaultValue: 'Default Message')
            .then((value) => _messageController.text = value!),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
    throw {};
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  void _checkForWidgetLaunch() {
    print('_checkForWidgetLaunch');
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    print('_launchedFromWidget');
    if (uri != null) {
      showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
                title: Text('App started from HomeScreenWidget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  void _startBackgroundUpdate() {
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: Duration(minutes: 15));
  }

  void _stopBackgroundUpdate() {
    Workmanager().cancelByUniqueName('1');
  }
}
