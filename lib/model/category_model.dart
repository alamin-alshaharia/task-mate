class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final String color;
  int remainingTasks;
  int completedTasks;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.remainingTasks = 0,
    this.completedTasks = 0,
  });

  // Factory constructor for creating a CategoryModel from a Map
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      remainingTasks: json['remainingTasks'] as int? ?? 0,
      completedTasks: json['completedTasks'] as int? ?? 0,
    );
  }

  // Convert CategoryModel to a Map for database insertion
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'icon': icon,
      'color': color,
      'remainingTasks': remainingTasks,
      'completedTasks': completedTasks,
    };

    // Only include ID if it's not a new/temporary one (e.g., if > 0)
    // or if we specifically want to update an existing record.
    if (id > 0) {
      data['id'] = id;
    }

    return data;
  }

  // Optional: Create a copyWith method for easy updates
  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
    int? remainingTasks,
    int? completedTasks,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      remainingTasks: remainingTasks ?? this.remainingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }

  // Optional: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ icon.hashCode ^ color.hashCode;
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, icon: $icon, color: $color, '
        'remainingTasks: $remainingTasks, completedTasks: $completedTasks)';
  }
}
