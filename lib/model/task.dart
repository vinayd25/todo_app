class Task {
  final String taskId;
  final String taskName;
  final String taskDesc;
  final String taskTag;
  final String date;
  final String time;
  final int notifId;
  final String taskImagePath;

  Task({ required this.taskId, required this.taskName, required this.taskDesc, required this.taskTag, required this.date, required this.time, required this.notifId, this.taskImagePath = ""});

  Task.fromJson(json)
      : taskName = json['taskName'],
        taskId = json['id'],
        taskDesc = json['taskDesc'],
        taskTag = json["taskTag"],
        date = json["date"],
        time = json["time"],
        taskImagePath = json["imageUrl"],
        notifId = json["notificationId"];

  Map<String, dynamic> toJson() => {
    'id': taskId,
    'taskName': taskName,
    'taskDesc': taskDesc,
    'taskTag': taskTag,
    'date': date,
    'time': time,
    'imageUrl': taskImagePath,
    'notificationId': notifId
  };

}