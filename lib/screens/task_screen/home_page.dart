import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/latest_calender_screen.dart';
import 'package:flutter_task_planner_app/screens/task_screen/category_details.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../controller/profile_controller.dart';
import '../../model/category_model.dart';
import '../../theme/colors/light_colors.dart';
import '../../widgets/task_widget/home_page/top_container.dart';
import '../../widgets/task_widget/home_page/homepage_button.dart';
import '../../widgets/task_widget/task_column.dart';
import '../../widgets/task_widget/home_page/drawer.dart';

import '../note_screens/home_page.dart';
import '../task_screen/all_task_page.dart';
import '../task_screen/create_new_task_page.dart';
import '../task_screen/report_page.dart';
import '../task_screen/search_page.dart';

class HomePage extends StatefulWidget {
  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();
  final TaskController _taskController = Get.put(TaskController());
  final ProfileController _profileController = Get.put(ProfileController());

  int totalTask = 0;
  int completedTask = 0;
  int todoTask = 0;
  double totalProgress = 0.0;
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchAllTaskStats();
    _setDefaultCategories();
    _fetchCategories();
  }

  void _setDefaultCategories() {
    _categories = [
      CategoryModel(
        id: 1,
        name: 'Personal',
        icon: 'person_outline',
        color: '#FF7B86',
        remainingTasks: 0,
        completedTasks: 0,
      ),
      CategoryModel(
        name: 'Work',
        icon: 'work_outline',
        color: '#4ECDC4',
        remainingTasks: 0,
        completedTasks: 0,
        id: 2,
      ),
      CategoryModel(
        id: 3,
        name: 'Important',
        icon: 'priority_high',
        color: '#FFB900',
        remainingTasks: 0,
        completedTasks: 0,
      ),
    ];
  }

  Future<void> _fetchAllTaskStats() async {
    try {
      totalTask = (await _taskController.getTotalTask()).toInt();
      completedTask = (await _taskController.getTotalCompletedTask()).toInt();
      todoTask = totalTask - completedTask;
      totalProgress = (await _taskController.getTotalCompletedProgress()) / 100;
      setState(() {});
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      // Fetch categories from the task controller
      List<CategoryModel> fetchedCategories =
          await _taskController.getCategories();

      // Create a new list to store updated categories
      List<CategoryModel> updatedCategories = List.from(_categories);

      // Merge fetched categories with existing ones
      for (var fetchedCategory in fetchedCategories) {
        // Check if the category already exists
        int existingIndex = updatedCategories.indexWhere((cat) =>
            cat.name.toLowerCase() == fetchedCategory.name.toLowerCase());

        if (existingIndex == -1) {
          // Add new category if it doesn't exist
          updatedCategories.add(fetchedCategory);
        } else {
          // Update existing category
          updatedCategories[existingIndex] = CategoryModel(
            id: updatedCategories[existingIndex].id,
            name: fetchedCategory.name,
            icon: fetchedCategory.icon ?? updatedCategories[existingIndex].icon,
            color:
                fetchedCategory.color ?? updatedCategories[existingIndex].color,
            remainingTasks: fetchedCategory.remainingTasks ??
                updatedCategories[existingIndex].remainingTasks,
            completedTasks: fetchedCategory.completedTasks ??
                updatedCategories[existingIndex].completedTasks,
          );
        }
      }

      // Ensure default categories are always present
      _ensureDefaultCategories(updatedCategories);

      // Update the categories list
      setState(() {
        _categories = updatedCategories;
      });
    } catch (error) {
      print('Error fetching categories: $error');

      // Fallback to default categories if fetching fails
      _ensureDefaultCategories(_categories);
    }
  }

  void _ensureDefaultCategories(List<CategoryModel> categories) {
    // List of default categories to always include
    final defaultCategories = [
      CategoryModel(
        id: 1,
        name: 'Personal',
        icon: 'person_outline',
        color: '#FF7B86',
        remainingTasks: 0,
        completedTasks: 0,
      ),
      CategoryModel(
        id: 2,
        name: 'Work',
        icon: 'work_outline',
        color: '#4ECDC4',
        remainingTasks: 0,
        completedTasks: 0,
      ),
      CategoryModel(
        id: 3,
        name: 'Important',
        icon: 'priority_high',
        color: '#FFB900',
        remainingTasks: 0,
        completedTasks: 0,
      ),
    ];

    // Add default categories if they don't exist
    for (var defaultCategory in defaultCategories) {
      bool exists = categories.any((cat) =>
          cat.name.toLowerCase() == defaultCategory.name.toLowerCase());

      if (!exists) {
        categories.add(defaultCategory);
      }
    }
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: LightColors.kDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: todoTask != 0
          ? FloatingActionButton(
              onPressed: () => Get.to(CreateNewTaskPage()),
              child: Icon(Icons.add),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SliderDrawer(
        key: dKey,
        animationDuration: 200,
        slider: MySlider(),
        appBar: SliderAppBar(
          appBarPadding: EdgeInsets.fromLTRB(20, 35, 22, 0),
          appBarColor: LightColors.kDarkYellow,
          title: Container(),
          trailing: IconButton(
            icon: Icon(Icons.search),
            iconSize: 31,
            onPressed: () {
              Get.to(SearchPage());
            },
          ),
        ),
        child: Container(
          color: LightColors.kLightYellow,
          child: Column(
            children: <Widget>[
              TopContainer(
                height: 190,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Obx(() {
                            final profile = _profileController.profile.value;
                            return CircularPercentIndicator(
                              radius: 65.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: totalProgress,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: LightColors.kRed,
                              backgroundColor: LightColors.kDarkYellow,
                              center: CircleAvatar(
                                backgroundColor: LightColors.kBlue,
                                radius: 40.0,
                                backgroundImage: profile.imageData != null
                                    ? MemoryImage(profile.imageData!)
                                    : const AssetImage(
                                            'assets/images/avatar.png')
                                        as ImageProvider,
                              ),
                            );
                          }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  'Welcome',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Obx(() {
                                final profile =
                                    _profileController.profile.value;
                                return Container(
                                  child: Text(
                                    profile.name ?? "User Name",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomepageButton(
                      buttonTitle: "Task Report",
                      onpress: () => ReportPage(),
                    ),
                    HomepageButton(
                      buttonTitle: "Note Manager",
                      onpress: () => Homenote(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                subheading('My Tasks'),
                                GestureDetector(
                                  onTap: () async {
                                    Get.to(CalendarTimelinePage());
                                    await _taskController.getTasks();
                                  },
                                  child: HomePage.calendarIcon(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            GestureDetector(
                              onTap: () => Get.to(AllTaskPage(indexs: 0)),
                              child: TaskColumn(
                                icon: Icons.alarm,
                                iconBackgroundColor: LightColors.kRed,
                                title: 'To Do',
                                subtitle: '$todoTask tasks now. ',
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            GestureDetector(
                              onTap: () => Get.to(AllTaskPage(indexs: 2)),
                              child: TaskColumn(
                                icon: Icons.blur_circular,
                                iconBackgroundColor: LightColors.kDarkYellow,
                                title: 'Total Task',
                                subtitle: '$totalTask tasks now. ',
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            GestureDetector(
                              onTap: () => Get.to(AllTaskPage(indexs: 1)),
                              child: TaskColumn(
                                icon: Icons.check_circle_outline,
                                iconBackgroundColor: LightColors.kBlue,
                                title: 'Done',
                                subtitle: '$completedTask tasks now. ',
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: subheading('Categories'),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        height: 300, // Set a fixed height for the GridView
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          itemCount: _categories.length +
                              1, // Add 1 for the "Add" card
                          itemBuilder: (context, index) {
                            // If it's the last item, return the _buildAddCard
                            if (index == _categories.length) {
                              return _buildAddCard();
                            }

                            // Otherwise, return the category card
                            final category = _categories[index];
                            return _buildCategoryCard(
                              category.name,
                              category.icon,
                              Color(int.parse(
                                  category.color.replaceAll('#', '0xff'))),
                              category.remainingTasks,
                              category.completedTasks,
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1, // Adjust as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () {
        _showAddCategoryDialog();
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
              'Add Category',
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
                  'priority_high',
                  'calendar_today',
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
                  '#FF7B86', // Red-ish
                  '#4ECDC4', // Teal
                  '#FFB900', // Yellow
                  '#A569BD', // Purple
                  '#2ECC71', // Green
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
                if (nameController.text.trim().isNotEmpty &&
                    selectedIcon != null &&
                    selectedColor != null) {
                  // Check if category name already exists
                  bool categoryExists = _categories.any((category) =>
                      category.name.toLowerCase() ==
                      nameController.text.trim().toLowerCase());

                  if (categoryExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Category with this name already exists')),
                    );
                  } else {
                    _addCategory(
                      nameController.text.trim(),
                      selectedIcon!,
                      selectedColor!,
                    );
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCategory(
    String name,
    String icon,
    String color,
  ) async {
    try {
      // Call the addCategory method and get the new category ID
      final newCategoryId = await _taskController.addCategory(
        name: name,
        icon: icon,
        color: color,
      );

      if (newCategoryId != -1) {
        // Create a new CategoryModel using the new category ID
        final newCategory = CategoryModel(
          id: newCategoryId,
          name: name,
          icon: icon,
          color: color,
          remainingTasks: 0,
          completedTasks: 0,
        );

        // Update the local categories list
        setState(() {
          _categories.add(newCategory);
        });

        // Optionally refresh categories if needed
        await _fetchCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category')),
        );
      }
    } catch (e) {
      print('Error adding category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category')),
      );
    }
  }

  Widget _buildCategoryCard(
    String title,
    String icon,
    Color color,
    int totalTasks,
    int completedTasks,
  ) {
    final iconData = _getIconData(icon);
    final remainingTasks = totalTasks - completedTasks;

    return GestureDetector(
      onTap: () {
        // Navigate to CategoryDetailPage with the selected category
        Get.to(CategoryDetailPage(
          category: CategoryModel(
            id: _categories.firstWhere((cat) => cat.name == title).id,
            name: title,
            icon: icon,
            color: color.toString(),
            remainingTasks: remainingTasks,
            completedTasks: completedTasks,
          ),
        ));
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
                  '$remainingTasks left',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$completedTasks done',
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

  void _showTasksForCategory(String categoryName) {
    Get.to(AllTaskPage());
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person_outline':
        return Icons.person_outline;
      case 'work_outline':
        return Icons.work_outline;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'priority_high':
        return Icons.priority_high;
      default:
        return Icons.search;
    }
  }
}

extension on TaskController {
  addCategory(
      {required String name, required String icon, required String color}) {}
}
