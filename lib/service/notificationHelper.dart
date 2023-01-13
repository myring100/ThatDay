import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'notificationController.dart';

class NotificationHelper {
  static notificationInit(){
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true
    );
  }

  void createNotification(String title, String body,DateTime scheduledDate){
    _notificationPermissionCheck();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: title,
            body: body,
            actionType: ActionType.Default,
          wakeUpScreen: true,
          category: NotificationCategory.Alarm,

        ),
      schedule: NotificationCalendar.fromDate
        (date: scheduledDate),);
    addListenerNotification();

    print('Notification scheduled at ${scheduledDate.toString()}');

  }
  void _notificationPermissionCheck(){
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print('notification not alloed');
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
  void addListenerNotification(){
  AwesomeNotifications().setListeners(
  onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
  onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
  onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
  onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
  );
}
}