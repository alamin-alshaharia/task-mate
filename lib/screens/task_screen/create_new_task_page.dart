import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/profile_controller.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/mixins/data_sync_mixin.dart';
import 'package:flutter_task_planner_app/model/category_model.dart';
import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:flutter_task_planner_app/screens/task_screen/home_page.dart';
import 'package:flutter_task_planner_app/service/speech_service.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/back_button.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/home_page/top_container.dart';
import 'package:flutter_task_planner_app/widgets/task_widget/my_text_field.dart';
import 'package:flutter_task_planner_app/widgets/voice/voice_input_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widgets/task_widget/input_field_with_widget.dart';

class CreateNewTaskPage extends StatefulWidget {
  final CategoryModel? preSelectedCategory;
  final Task? editingTask;

  const CreateNewTaskPage(
      {super.key, this.preSelectedCategory, this.editingTask});

  @override
  State<CreateNewTaskPage> createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage>
    with DataSyncMixin {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Once",
    "Daily",
    "Weekly",
  ];

  String _endTime = "9:30 AM";
  String titleText = "";

  final RxInt _selectedCategoryIndex = 0.obs;

  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();

    // Ensure task controller is initialized
    _ensureControllerInitialized();

    // If editing a task, populate the fields
    if (widget.editingTask != null) {
      _populateFieldsFromTask();
    }

    if (widget.preSelectedCategory != null) {
      Future.delayed(Duration.zero, () {
        _selectedCategoryIndex.value = _taskController.categoryList.indexWhere(
            (category) => category.id == widget.preSelectedCategory!.id);
        if (_selectedCategoryIndex.value == -1) {
          _selectedCategoryIndex.value = 0;
        }
      });
    }
  }

  void _populateFieldsFromTask() {
    final task = widget.editingTask!;

    titleController.text = task.title ?? '';
    descriptionController.text = task.description ?? '';

    if (task.date != null) {
      try {
        _selectedDate = DateFormat('dd/MM/yyyy').parse(task.date!);
      } catch (e) {
        AppLogger.e('Error parsing date: ${task.date}');
        _selectedDate = DateTime.now();
      }
    }

    if (task.startTime != null) {
      _startTime = task.startTime!;
    }

    if (task.endTime != null) {
      _endTime = task.endTime!;
    }

    if (task.remind != null) {
      _selectedRemind = task.remind!;
    }

    if (task.repeat != null) {
      _selectedRepeat = task.repeat!;
    }

    if (task.color != null) {
      _selectedColor = task.color!;
    }

    // Set the category
    Future.delayed(Duration.zero, () {
      if (task.categoryId != null) {
        _selectedCategoryIndex.value = _taskController.categoryList
            .indexWhere((category) => category.id == task.categoryId);
        if (_selectedCategoryIndex.value == -1) {
          _selectedCategoryIndex.value = 0;
        }
      }
    });
  }

  void _ensureControllerInitialized() async {
    // Make sure categories are loaded
    if (_taskController.categoryList.isEmpty) {
      AppLogger.d('Initializing categories in CreateNewTaskPage');
      await _taskController.getCategories();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.yMMMd().format(_selectedDate);
    double width = MediaQuery.of(context).size.width;

    var downwardIcon = const Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: _appBar(context),
      body: SafeArea(
        child: Obx(() {
          AppLogger.d(
              'CategoryList length: ${_taskController.categoryList.length}');

          final categories = _taskController.categoryList;

          // If no categories, show a fallback UI instead of infinite loading
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading categories...'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      AppLogger.d('Manual categories refresh triggered');
                      await _taskController.getCategories();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: <Widget>[
              TopContainer(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
                width: width,
                child: Column(
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Create new task',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyTextField(
                          label: 'Title',
                          textController: titleController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: MyTextField(
                                  ontap: () {
                                    _getDate(context);
                                  },
                                  textController:
                                      TextEditingController(text: date),
                                  label: "Date",
                                  icon: downwardIcon),
                            ),
                            InkWell(
                                onTap: () {
                                  _getDate(context);
                                },
                                child: HomePage.calendarIcon()),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: MyTextField(
                          textController:
                              TextEditingController(text: _startTime),
                          ontap: () => _getTime(isStartTime: true),
                          label: 'Start Time',
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.black26,
                          ),
                        )),
                        const SizedBox(width: 40),
                        Expanded(
                          child: MyTextField(
                            label: 'End Time',
                            textController:
                                TextEditingController(text: _endTime),
                            ontap: () => _getTime(isStartTime: false),
                            icon: const Icon(
                              Icons.access_time_outlined,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    MyTextField(
                      label: 'Description',
                      minLines: 3,
                      maxLines: 3,
                      textController: descriptionController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MyInputFieldWithWidget(
                          width: 150,
                          title: "Repeat",
                          hint: _selectedRepeat,
                          widget: DropdownButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRepeat = newValue!;
                                });
                              },
                              elevation: 4,
                              items: repeatList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value),
                                );
                              }).toList()),
                        ),
                        MyInputFieldWithWidget(
                          width: 180,
                          title: "Remind",
                          hint: "$_selectedRemind minutes early",
                          widget: DropdownButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRemind = int.parse(newValue!);
                                });
                              },
                              elevation: 4,
                              items: remindList
                                  .map<DropdownMenuItem<String>>((int value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          Obx(() {
                            // final categories = categories;
                            return Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceAround,
                              spacing: 18.0,
                              children: List<Widget>.generate(categories.length,
                                  (int index) {
                                final category = categories[index];
                                return GestureDetector(
                                  onTap: () {
                                    _selectedCategoryIndex.value = index;
                                  },
                                  child: Chip(
                                    elevation: 20,
                                    label: Text(category.name),
                                    backgroundColor:
                                        _selectedCategoryIndex.value == index
                                            ? LightColors.kLightBlue
                                            : LightColors.kLightYellow2,
                                    labelStyle: TextStyle(
                                      color:
                                          _selectedCategoryIndex.value == index
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                    deleteIcon: Icon(
                                      Icons.close,
                                      size: 18,
                                      color:
                                          _selectedCategoryIndex.value == index
                                              ? Colors.white
                                              : Colors.black54,
                                    ),
                                    onDeleted: () => _showDeleteCategoryDialog(
                                        category, index),
                                  ),
                                );
                              }),
                            );
                          }),
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 8, bottom: 5, left: 2),
                            child: Text(
                              "Color",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                          Wrap(
                            children: List<Widget>.generate(4, (int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = index;
                                  });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7, top: 7, right: 7),
                                    child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: index == 0
                                            ? Colors.red
                                            : index == 1
                                                ? Colors.blue
                                                : index == 2
                                                    ? Colors.amberAccent
                                                    : Colors.lightBlueAccent,
                                        child: _selectedColor == index
                                            ? const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                              )
                                            : Container())),
                              );
                            }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
              SizedBox(
                height: 80,
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await _validateData();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        width: width - 40,
                        decoration: BoxDecoration(
                          color: LightColors.kLightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Create Task',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _getDate(context) async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2125),
        initialDate: DateTime.now());
    if (pickDate != null) {
      setState(() {
        _selectedDate = pickDate;
      });
    }
  }

  Future<void> _addTaskToDb() async {
    final task = Task(
      color: _selectedColor,
      date: DateFormat.yMd().format(_selectedDate),
      description: descriptionController.text,
      title: titleController.text,
      endTime: _endTime,
      startTime: _startTime,
      isCompleted: widget.editingTask?.isCompleted ?? 0,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      categoryId: _taskController.categoryList[_selectedCategoryIndex.value].id,
    );

    if (widget.editingTask != null) {
      // Update existing task
      task.id = widget.editingTask!.id;
      task.isStar = widget.editingTask!.isStar; // Preserve star status
      await updateTaskWithSync(task);
      AppLogger.d("Updated task with ID: ${task.id}");
    } else {
      // Create new task
      await createTaskWithSync(task);
      AppLogger.d("Created new task: ${task.title}");
    }
  }

  Future<void> _validateData() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await _addTaskToDb();
      Get.back(); // Return to previous screen, reactive state will update automatically
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar("Warning", "All Fields are Required",
          icon: const Icon(Icons.warning_amber_rounded),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: LightColors.kPalePink);
    }
  }

  Future<void> _showDeleteCategoryDialog(
      CategoryModel category, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${category.name}"?'),
                const SizedBox(height: 8),
                const Text(
                  'This action cannot be undone. Tasks associated with this category will prevent deletion.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteCategory(category.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(int categoryId) async {
    try {
      final success = await _taskController.deleteCategory(categoryId);

      if (success) {
        // Reset selected category index if needed
        if (_selectedCategoryIndex.value >=
            _taskController.categoryList.length) {
          _selectedCategoryIndex.value = 0;
        }

        Get.snackbar(
          'Success',
          'Category deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Cannot delete category. Please ensure no tasks are associated with this category.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppLogger.e('Error in delete category UI: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting the category',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _getTime({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();

    if (pickedTime != null) {
      String formatedTime = pickedTime.format(context);

      if (isStartTime) {
        setState(() {
          _startTime = formatedTime;
        });
      } else {
        setState(() {
          _endTime = formatedTime;
        });
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
        context: context);
  }

  // Voice input method
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
            // Fill the form with voice data
            _fillFormWithSpeechData(speechData);
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

  // Fill form with speech data
  void _fillFormWithSpeechData(TaskSpeechData speechData) {
    setState(() {
      titleController.text = speechData.title;
      descriptionController.text = speechData.description;

      if (speechData.dueDate != null) {
        _selectedDate = speechData.dueDate!;
      }

      // Set priority-based color
      switch (speechData.priority) {
        case 'high':
          _selectedColor = 0; // Red for high priority
          break;
        case 'low':
          _selectedColor = 2; // Green for low priority
          break;
        default:
          _selectedColor = 1; // Yellow for medium priority
      }
    });

    // Show success message
    Get.snackbar(
      'Voice Input',
      'Task details filled from voice input!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // App bar method
  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: LightColors.kDarkYellow,
      title: Text(
        widget.editingTask != null ? 'Edit Task' : 'Create New Task',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: MyBackButton()),
      actions: [
        // Voice input button
        IconButton(
          onPressed: () => _showVoiceInput(context),
          icon: const Icon(
            Icons.mic,
            color: Colors.white,
            size: 24,
          ),
          tooltip: 'Voice Input',
        ),
        const SizedBox(width: 8),
        Obx(() {
          final ProfileController profileController =
              Get.put(ProfileController());
          final profile = profileController.profile.value;
          return CircleAvatar(
            backgroundImage: profile.imageData != null
                ? MemoryImage(profile.imageData!)
                : const AssetImage('assets/images/avatar.png') as ImageProvider,
          );
        }),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
