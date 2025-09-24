import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/screens/task_screen/calendar_page.dart';
import 'package:flutter_task_planner_app/screens/task_screen/category_details.dart';
import 'package:flutter_task_planner_app/service/speech_service.dart';
import 'package:flutter_task_planner_app/widgets/custom_slider_drawer/custom_slider_drawer.dart';
import 'package:flutter_task_planner_app/widgets/voice/voice_input_widget.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../controller/profile_controller.dart';
import '../../mixins/data_sync_mixin.dart';
import '../../model/category_model.dart';
import '../../model/task_model.dart';
import '../../theme/colors/light_colors.dart';
import '../../utils/logger.dart';
import '../../widgets/common/delete_confirmation_dialog.dart';
import '../../widgets/task_widget/home_page/drawer.dart';
import '../../widgets/task_widget/home_page/homepage_button.dart';
import '../../widgets/task_widget/home_page/top_container.dart';
import '../../widgets/task_widget/task_column.dart';
import '../note_screens/home_page.dart';
import '../task_screen/all_task_page.dart';
import '../task_screen/create_new_task_page.dart';
import '../task_screen/report_page.dart';
import '../task_screen/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

class _HomePageState extends State<HomePage> with DataSyncMixin {
  GlobalKey<CustomSliderDrawerState> dKey =
      GlobalKey<CustomSliderDrawerState>();
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
    _fetchCategories();

    // Register for automatic refresh when data changes
    dataSyncManager.registerHomePageRefreshCallback(_refreshHomePageData);
  }

  @override
  void dispose() {
    // Unregister callbacks to prevent memory leaks
    dataSyncManager.unregisterHomePageRefreshCallback(_refreshHomePageData);
    super.dispose();
  }

  /// Refresh home page data when called by DataSyncManager
  void _refreshHomePageData() {
    if (mounted) {
      _fetchAllTaskStats();
      _fetchCategories();
    }
  }

  Future<void> _fetchAllTaskStats() async {
    try {
      totalTask = (await _taskController.getTotalTask()).toInt();
      completedTask = (await _taskController.getTotalCompletedTask()).toInt();
      todoTask = totalTask - completedTask;
      totalProgress = (await _taskController.getTotalCompletedProgress()) / 100;
      setState(() {});
    } catch (error) {
      AppLogger.e('Error: $error');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      // Fetch categories from the task controller (includes default categories)
      List<CategoryModel> fetchedCategories =
          await _taskController.getCategories();

      setState(() {
        _categories = fetchedCategories;
      });
    } catch (error) {
      AppLogger.e('Error fetching categories: $error');
      // Keep empty list if fetching fails
      setState(() {
        _categories = [];
      });
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
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Voice input button
                FloatingActionButton(
                  onPressed: () => _showVoiceInput(context),
                  heroTag: "voice",
                  backgroundColor: Colors.red[400],
                  mini: true,
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Regular add button
                FloatingActionButton(
                  onPressed: () => Get.to(CreateNewTaskPage()),
                  heroTag: "add",
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomSliderDrawer(
        key: dKey,
        animationDuration: 200,
        slider: MySlider(),
        appBar: CustomSliderAppBar(
          config: CustomSliderDrawerConfig(
            backgroundColor: LightColors.kDarkYellow,
            title: SizedBox(),
            trailing: IconButton(
              icon: Icon(Icons.search),
              iconSize: 31,
              onPressed: () {
                Get.to(SearchPage());
              },
            ),
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
                                    : null,
                                child: profile.imageData == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: LightColors.kDarkYellow,
                                      )
                                    : null,
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
                                    Get.to(() => const CalendarPage());
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            subheading('Categories'),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to view • Long press to delete',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
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
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: LightColors.kBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add_box,
                              color: LightColors.kBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Category',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Create a custom category for your tasks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Category Name Input
                      Text(
                        'Category Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey.shade50,
                        ),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter category name',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Icon Selection
                      Text(
                        'Choose Icon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            'person_outline',
                            'work_outline',
                            'favorite_border',
                            'priority_high',
                            'calendar_today',
                          ].map((icon) {
                            bool isSelected = selectedIcon == icon;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIcon = icon;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? LightColors.kBlue
                                            .withValues(alpha: 0.1)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? LightColors.kBlue
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getIconData(icon),
                                      color: isSelected
                                          ? LightColors.kBlue
                                          : Colors.grey.shade600,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Color Selection
                      Text(
                        'Choose Color',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            '#FF7B86', // Red-ish
                            '#4ECDC4', // Teal
                            '#FFB900', // Yellow
                            '#A569BD', // Purple
                            '#2ECC71', // Green
                          ].map((color) {
                            bool isSelected = selectedColor == color;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        color.replaceAll('#', '0xff'))),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Color(int.parse(color
                                                      .replaceAll('#', '0xff')))
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (nameController.text.trim().isNotEmpty &&
                                    selectedIcon != null &&
                                    selectedColor != null) {
                                  // Check if category name already exists
                                  bool categoryExists = _categories.any(
                                      (category) =>
                                          category.name.toLowerCase() ==
                                          nameController.text
                                              .trim()
                                              .toLowerCase());

                                  if (categoryExists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Category with this name already exists'),
                                        backgroundColor: Colors.red.shade400,
                                      ),
                                    );
                                  } else {
                                    _addCategory(
                                      nameController.text.trim(),
                                      selectedIcon!,
                                      selectedColor!,
                                    );
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Category added successfully!'),
                                        backgroundColor: Colors.green.shade400,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please fill all fields'),
                                      backgroundColor: Colors.orange.shade400,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LightColors.kBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Add Category',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addCategory(
    String name,
    String icon,
    String color,
  ) async {
    await withLoading(() async {
      await dataSyncManager.createCategory(
        name: name,
        icon: icon,
        color: color,
      );

      // Note: UI refresh is handled automatically by DataSyncManager callbacks

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$name" added successfully!'),
            backgroundColor: Colors.green.shade400,
          ),
        );
      }
    });
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
    final category = _categories.firstWhere((cat) => cat.name == title);

    return GestureDetector(
      onTap: () {
        // Navigate to CategoryDetailPage with the selected category
        Get.to(CategoryDetailPage(
          category: CategoryModel(
            id: category.id,
            name: title,
            icon: icon,
            color:
                '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            remainingTasks: remainingTasks,
            completedTasks: completedTasks,
          ),
        ));
      },
      onLongPress: () {
        // Show delete category dialog on long press
        _showDeleteCategoryDialog(category);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: _getCategoryGradient(color),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  iconData,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalTasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip('$remainingTasks left', Icons.pending_actions,
                    Colors.orange[700]!),
                _buildStatChip('$completedTasks done', Icons.check_circle,
                    Colors.green[700]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getCategoryGradient(Color baseColor) {
    // Create beautiful gradients based on the base color
    final hsl = HSLColor.fromColor(baseColor);
    final lightColor =
        hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    final darkColor =
        hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, baseColor, darkColor],
      stops: const [0.0, 0.5, 1.0],
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
      case 'calendar_today':
        return Icons.calendar_today;
      case 'priority_high':
        return Icons.priority_high;
      default:
        return Icons.search;
    }
  }

  // Voice input method for quick task creation
  void _showVoiceInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VoiceInputWidget(
          onSpeechResult: (TaskSpeechData speechData) {
            // Create task directly from voice input
            _createTaskFromVoice(speechData);
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          onError: (String error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.orange.shade400,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ),
    );
  }

  // Create task directly from voice input
  Future<void> _createTaskFromVoice(TaskSpeechData speechData) async {
    try {
      final newTask = Task(
        title: speechData.title,
        description: speechData.description,
        date: speechData.dueDate != null
            ? "${speechData.dueDate!.day}/${speechData.dueDate!.month}/${speechData.dueDate!.year}"
            : "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        startTime: "9:00 AM",
        endTime: "10:00 AM",
        remind: 10,
        repeat: "None",
        color: speechData.priority == 'high'
            ? 0
            : (speechData.priority == 'low' ? 2 : 1),
        isCompleted: 0,
        isStar: 0,
      );

      // Use DataSyncMixin to create task with sync
      await createTaskWithSync(newTask);

      // Refresh UI data
      _fetchAllTaskStats();
      _fetchCategories();

      Get.snackbar(
        'Success',
        'Task created from voice input successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      AppLogger.e('Error creating task from voice: $error');
      Get.snackbar(
        'Error',
        'Failed to create task: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _showDeleteCategoryDialog(CategoryModel category) async {
    return DeleteConfirmationDialog.showCategoryDeleteDialog(
      context: context,
      categoryName: category.name,
      onConfirm: () async {
        await _deleteCategory(category.id);
      },
    );
  }

  Future<void> _deleteCategory(int categoryId) async {
    await withLoading(() async {
      await dataSyncManager.deleteCategory(categoryId);

      // Note: UI refresh is handled automatically by DataSyncManager callbacks

      Get.snackbar(
        'Success',
        'Category deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}
