import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'db/latest_db_helper.dart';
// import 'database_helper.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final database = await _dbHelper.database;
    final tasks = await database.query('tasks');
    final categories = await database.query('categories');
    setState(() {
      _tasks = tasks;
      _categories = categories;
    });
  }

// Add this method to the _TaskManagementScreenState class
  Future<void> _addCategory(String name, String icon, String color) async {
    final database = await _dbHelper.database;
    await database.insert('categories', {
      'name': name,
      'icon': icon,
      'color': color,
    });
    _loadData();
  }

// Add this method to the _TaskManagementScreenState class
  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    String? selectedIcon;
    String? selectedColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Category Name',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedIcon,
                hint: const Text('Select Icon'),
                onChanged: (value) {
                  setState(() {
                    selectedIcon = value;
                  });
                },
                items: [
                  'person_outline',
                  'work_outline',
                  'favorite_border',
                  // Add more icon options as needed
                ].map((icon) {
                  return DropdownMenuItem<String>(
                    value: icon,
                    child: Icon(_getIconData(icon)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedColor,
                hint: const Text('Select Color'),
                onChanged: (value) {
                  setState(() {
                    selectedColor = value;
                  });
                },
                items: [
                  '#FFF0E0',
                  '#FCE4EC',
                  '#E3F2FD',
                  // Add more color options as needed
                ].map((color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Container(
                      width: 100,
                      height: 30,
                      color: Color(int.parse(color.replaceAll('#', '0xff'))),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCategory(
                  nameController.text,
                  selectedIcon ?? 'person_outline',
                  selectedColor ?? '#FFF0E0',
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTask(
      String title, String description, String category) async {
    final database = await _dbHelper.database;
    final now = DateTime.now();
    await database.insert('tasks', {
      'title': title,
      'description': description,
      'category': category,
      'status': 0,
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
      'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
    });
    _loadData();
  }

  Future<void> _updateTask(int id, String title, String description,
      String category, int status) async {
    final database = await _dbHelper.database;
    final now = DateTime.now();
    await database.update(
      'tasks',
      {
        'title': title,
        'description': description,
        'category': category,
        'status': status,
        'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadData();
  }

  Future<void> _deleteTask(int id) async {
    final database = await _dbHelper.database;
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile and greeting section
              _buildProfileAndGreeting(),
              const SizedBox(height: 20),

              // Premium banner
              _buildPremiumBanner(),
              const SizedBox(height: 24),

              // Tasks section
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Task categories grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    for (final category in _categories)
                      _buildCategoryCard(
                        category['name'] as String,
                        category['icon'] as String,
                        Color(int.parse(
                            category['color']!.replaceAll('#', '0xff'))),
                        _tasks
                            .where(
                                (task) => task['category'] == category['name'])
                            .where((task) => task['status'] == 0)
                            .length,
                        _tasks
                            .where(
                                (task) => task['category'] == category['name'])
                            .where((task) => task['status'] == 1)
                            .length,
                      ),
                    _buildAddCard(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileAndGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            const SizedBox(width: 12),
            const Text(
              'Hi, Amanda!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Handle more options
          },
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Go Premium!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Get unlimited access to all our features!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle premium upgrade
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryCard(
  //   String title,
  //   String icon,
  //   Color color,
  //   int remaining,
  //   int completed,
  // ) {
  //   return GestureDetector(
  //     onTap: () {
  //       _showTasksForCategory(title);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Icon(
  //             Icons.getIconData(icon),
  //             color: Colors.grey[600],
  //           ),
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Row(
  //             children: [
  //               Text(
  //                 '$remaining left',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 '$completed done',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () {
        _showAddTaskDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              size: 24,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Add',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildBottomNavigation() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       IconButton(
  //         icon: const Icon(Icons.home, color: Colors.blue),
  //         onPressed: () {
  //           // Navigate to home screen
  //         },
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.add, color: Colors.blue),
  //         onPressed: () {
  //           _showAddTaskDialog();
  //         },
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.person_outline, color: Colors.grey),
  //         onPressed: () {
  //           // Navigate to profile screen
  //         },
  //       ),
  //     ],
  //   );
  // }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Task Description',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedCategory,
                hint: const Text('Select Category'),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'] as String,
                    child: Text(category['name'] as String),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addTask(
                  titleController.text,
                  descriptionController.text,
                  selectedCategory ?? 'Personal',
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showTasksForCategory(String categoryName) {
    final categoryTasks =
        _tasks.where((task) => task['category'] == categoryName).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$categoryName Tasks'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categoryTasks.length,
              itemBuilder: (context, index) {
                final task = categoryTasks[index];
                return ListTile(
                  title: Text(task['title'] as String),
                  subtitle: Text(task['description'] as String),
                  trailing: Checkbox(
                    value: task['status'] == 1,
                    onChanged: (value) {
                      _updateTask(
                        task['id'] as int,
                        task['title'] as String,
                        task['description'] as String,
                        task['category'] as String,
                        value! ? 1 : 0,
                      );
                    },
                  ),
                  onLongPress: () {
                    _showEditTaskDialog(
                      task['id'] as int,
                      task['title'] as String,
                      task['description'] as String,
                      task['category'] as String,
                      task['status'] as int,
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.home, color: Colors.blue),
          onPressed: () {
            // Navigate to home screen
          },
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.blue),
          onPressed: () {
            _showAddTaskDialog();
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
          onPressed: () {
            _showAddCategoryDialog();
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.grey),
          onPressed: () {
            // Navigate to profile screen
          },
        ),
      ],
    );
  }

  void _showEditTaskDialog(
    int id,
    String title,
    String description,
    String category,
    int status,
  ) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    String? selectedCategory = category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Task Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Task Description',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedCategory,
                hint: const Text('Select Category'),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'] as String,
                    child: Text(category['name'] as String),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTask(
                  id,
                  titleController.text,
                  descriptionController.text,
                  selectedCategory ?? 'Personal',
                  status,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(
    String title,
    String icon,
    Color color,
    int remaining,
    int completed,
  ) {
    final iconData = _getIconData(icon);

    return GestureDetector(
      onTap: () {
        _showTasksForCategory(title);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              iconData,
              color: Colors.grey[600],
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  '$remaining left',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$completed done',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person_outline':
        return Icons.person_outline;
      case 'work_outline':
        return Icons.work_outline;
      case 'favorite_border':
        return Icons.favorite_border;
      // Add more cases for other icon names as needed
      default:
        return Icons.search;
    }
  }
}
