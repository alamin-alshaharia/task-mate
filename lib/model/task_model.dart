class Task {
  int? id;
  String? title;
  String? description;
  String? date;
  String? startTime;
  int? remind;
  String? repeat;
  String? endTime;
  int? color;
  int? isCompleted;
  int? isStar;
  int? categoryId; // Add this line

  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.startTime,
    this.remind,
    this.repeat,
    this.endTime,
    this.color,
    this.isCompleted,
    this.isStar,
    this.categoryId, // Add this line to the constructor
  });

  // Update fromJson method
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      startTime: json['startTime'],
      remind: json['remind'],
      repeat: json['repeat'],
      endTime: json['endTime'],
      color: json['color'],
      isCompleted: json['isCompleted'],
      isStar: json['isStar'],
      categoryId: json['categoryId'], // Add this line
    );
  }

  // Update toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'remind': remind,
      'repeat': repeat,
      'endTime': endTime,
      'color': color,
      'isCompleted': isCompleted,
      'isStar': isStar,
      'categoryId': categoryId, // Add this line
    };
  }
}
