import 'dart:typed_data';

class ProfileModel {
  int? id;
  String? name;
  String? profession;
  Uint8List? imageData;

  ProfileModel({
    this.id,
    this.name,
    this.profession,
    this.imageData,
  });

  // Convert Profile to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profession': profession,
      'imageData': imageData,
    };
  }

  // Create Profile from database map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      name: map['name'],
      profession: map['profession'],
      imageData: map['imageData'],
    );
  }

  // Create a copy of the profile with optional updates
  ProfileModel copyWith({
    int? id,
    String? name,
    String? profession,
    Uint8List? imageData,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      imageData: imageData ?? this.imageData,
    );
  }
}
