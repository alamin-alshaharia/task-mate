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

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    repeat = json['repeat'];
    startTime = json['startTime'];
    date = json['date'];
    color = json['color'];
    description = json['description'];
    endTime = json['endTime'];
    isCompleted = json['isCompleted'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['color'] = this.color;
    data['date'] = this.date;
    data['repeat'] = this.repeat;
    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    data['description'] = this.description;
    data['startTime'] = this.startTime;
    data['isCompleted'] = this.isCompleted;
    // data['reminder']=this.reminder;

    return data;
  }
}
