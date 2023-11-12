class Deadline {
  int id;
  String tag;
  String title;
  String description;
  DateTime datetime;
  int difficulty;

  Deadline({
    required this.id,
    required this.tag,
    required this.title,
    required this.description,
    required this.datetime,
    required this.difficulty
  });

  asJson() {
    Map<String, dynamic> json_entry = Map();
    json_entry["id"] = id;
    json_entry["tag"] = tag;
    json_entry["title"] = title;
    json_entry["description"] = description;
    json_entry["difficulty"] = difficulty;
    json_entry["datetime"] = datetime?.toIso8601String();
    return json_entry;
  }

  timeStringForCard() {
    final DateTime now = DateTime.now();
    String timeString =
      "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}";
    String dateString = "${datetime.day.toString()}.${datetime.month.toString()}.";
    String datetimeString = "${dateString} ${timeString}";
    final Duration timeDiff = datetime.isAfter(now)
      ? datetime.difference(now)
      : Duration(seconds: 0);

    if (timeDiff.inDays > 1) {
      return "$datetimeString (${timeDiff.inDays} days)";
    }
    return "$datetimeString (${timeDiff.inHours} hours)";
  }

  remainingTimeProgress() {
    final DateTime now = DateTime.now();
    final int daysUntil = datetime.difference(now).inDays;

    if (daysUntil < 0) {
      return 0;
    }

    final progressValue = daysUntil / 30;
    return progressValue > 1 ? 1 : progressValue;
  }
}