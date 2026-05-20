class Note {
  int? id;
  String? title;
  String? content;
  String? dateTimeEdited;
  String? dateTimeCreated;
  bool? isFavorite;

  Note(
      {this.id,
      this.title,
      this.content,
      this.dateTimeEdited,
      this.dateTimeCreated,
      this.isFavorite});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "dateTimeEdited": dateTimeEdited,
      "dateTimeCreated": dateTimeCreated,
      "isFavorite": isFavorite == true ? 1 : 0,
    };
  }

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTimeEdited: map['dateTimeEdited'],
      dateTimeCreated: map['dateTimeCreated'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
    );
  }
}
