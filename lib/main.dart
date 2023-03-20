import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:that_day/screen/firstPage.dart';
import 'package:that_day/service/notificationHelper.dart';

void main() async {
  NotificationHelper.notificationInit();
 await _initGoogleMobileAds().whenComplete(() => debugPrint('initgooglemobilads complete'));
  runApp(const MyApp());
}
Future<InitializationStatus> _initGoogleMobileAds() {
  // TODO: Initialize Google Mobile Ads SDK
  return MobileAds.instance.initialize();
}
class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        print('ontap()in main page');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapDown: (a){
        print('ontap down()in main page');
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'That Day(D-Day)',
        theme: ThemeData(
          appBarTheme:  AppBarTheme(color: Colors.lightBlue[500])
        ),
        home: const FirstPage(),
      ),
    );
  }
}

