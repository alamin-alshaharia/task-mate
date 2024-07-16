class Task {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  int? isCompleted;
  int? color;
  int? reminder;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.isCompleted,
    this.color,
    this.reminder,
    this.repeat,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "statTime": startTime,
      "date": date,
      "color": color,
      "endTime": endTime,
      "isCompleate": isCompleted
    };
  }
}
