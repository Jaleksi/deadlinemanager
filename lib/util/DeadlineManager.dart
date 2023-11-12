import 'dart:async';
import 'dart:math';

import 'package:localstorage/localstorage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:dln/util/Deadline.dart';


class DeadlineManager {
  static final DeadlineManager _instance = DeadlineManager._();
  LocalStorage storage = LocalStorage("DLNApp.json");
  List<Deadline> deadlines = [];
  AwesomeNotifications? notifications;

  static bool dataLoadedFromDevice = false;
  DeadlineManager._();

  factory DeadlineManager() {
    return _instance;
  }

  Future<List<Deadline>> getDeadlines() async {
    Completer<List<Deadline>> completer = Completer();

    if (!dataLoadedFromDevice) {
      storage.ready.then((_) {
        List<dynamic>? json_deadlines = storage.getItem("deadlines");
        if (json_deadlines != null) {
          deadlines = json_deadlines.map((json_deadline) {
            DateTime dt = DateTime.parse(json_deadline["datetime"]);
            return Deadline(
              id: json_deadline["id"],
              tag: json_deadline["tag"],
              title: json_deadline["title"],
              description: json_deadline["description"],
              datetime: dt,
              difficulty: json_deadline["difficulty"]
            );
          }).toList();
        }
        dataLoadedFromDevice = true;
        completer.complete(deadlines);

      });
    } else {
      completer.complete(deadlines);
    }
    return completer.future;
  }

  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    if (action.buttonKeyPressed == "remindLaterTest") {
      _instance.testNotification();
    } else if (action.buttonKeyPressed == "remindLater") {
      final dl = _instance.getDeadlineById(action.id);
      _instance.set6hoursNotification(dl);
    } else if (action.buttonKeyPressed == "deleteDeadline") {
      _instance.removeById(action.id);
    }
  }

  initNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Helsinki"));

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "DLN",
            channelName: "DLN",
            channelDescription: "DLN",
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
        )
      ],
      debug: true
    );
    notifications = AwesomeNotifications();

    notifications?.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  deadlinesAsJson() {
    return deadlines.map((deadline) => deadline.asJson()).toList();
  }

  add(Deadline new_deadline) async {
    deadlines.add(new_deadline);
    _instance.set3daysNotification(new_deadline);
  }

  removeById(int? id_to_remove) async {
    deadlines.removeWhere((deadline) => deadline.id == id_to_remove);
    await notifications?.cancel(id_to_remove!);
  }

  getDeadlineById(int? id) {
    return deadlines.firstWhere((deadline) => deadline.id == id);
  }

  updateStorage() {
    storage.setItem("deadlines", deadlinesAsJson());
  }

  deadlinesCount() {
    return deadlines.length;
  }

  Future<void> set6hoursNotification(Deadline deadline) async {
    final sixHoursBeforeDate = deadline.datetime.subtract(
      Duration(hours: 6)
    );
    await notifications?.createNotification(
      schedule: NotificationCalendar(
        day: sixHoursBeforeDate.day,
        month: sixHoursBeforeDate.month,
        year: sixHoursBeforeDate.year,
        hour: sixHoursBeforeDate.hour,
        minute: sixHoursBeforeDate.minute,
      ),
      content: NotificationContent(
        id: deadline.id,
        title: "Deadline coming up",
        body: "${deadline.title} is due in 6 hours",
        channelKey: "DLN",
        wakeUpScreen: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "deleteDeadline",
          label: "Delete deadline",
          autoDismissible: true,
          isDangerousOption: true,
          showInCompactView: true,
        ),
      ],
    );
  }

  Future<void> set3daysNotification(Deadline deadline) async {
    // Notification for 3 days before deadline
    final threeDaysBeforeDate = deadline.datetime.subtract(
      Duration(days: 3)
    );
    await notifications?.createNotification(
      schedule: NotificationCalendar(
        day: threeDaysBeforeDate.day,
        month: threeDaysBeforeDate.month,
        year: threeDaysBeforeDate.year,
        hour: threeDaysBeforeDate.hour,
        minute: threeDaysBeforeDate.minute,
      ),
      content: NotificationContent(
        id: deadline.id,
        title: "Deadline coming up",
        body: "${deadline.title} is due in 3 days",
        channelKey: "DLN",
        wakeUpScreen: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "deleteDeadline",
          label: "Delete deadline",
          autoDismissible: true,
          isDangerousOption: true,
          showInCompactView: true,
        ),
        NotificationActionButton(
          key: "remindLater",
          label: "Remind later",
          autoDismissible: true,
          showInCompactView: true,
        ),
      ],
    );
  }

  Future<void> testNotification() async {
    final now = DateTime.now().add(Duration(seconds: 5));
    await notifications?.createNotification(
      schedule: NotificationCalendar(
        day: now.day,
        month: now.month,
        year: now.year,
        hour: now.hour,
        minute: now.minute,
        allowWhileIdle: true,
      ),
      content: NotificationContent(
        id: 0,
        title: "TEST NOTIFICATION",
        body: "THIS IS A TEST NOTIFICATION",
        channelKey: "DLN",
        wakeUpScreen: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "deleteDeadline",
          label: "Dismiss",
          autoDismissible: true,
          isDangerousOption: true,
          showInCompactView: true,
        ),
        NotificationActionButton(
          key: "remindLaterTest",
          label: "Rerun test",
          autoDismissible: true,
          showInCompactView: true,
        ),
      ],
    );
  }
}