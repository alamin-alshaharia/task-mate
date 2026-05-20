import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/controller/task_controller.dart';
import 'package:flutter_task_planner_app/screens/task_screen/create_new_task_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/utils/logger.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  // @override
  @override
  State<ReportPage> createState() => _ReportPageState();
}

Color bluishClr = Colors.blue;
Color primaryClr = Colors.white;
const double kDefaultPadding = 20;

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final _taskController = Get.find<TaskController>();
  int currentIndex = 3;
  int totalTask = 0;
  int completedTask = 0;
  bool isCircular = true;
  ColorTween _colorTween = ColorTween(begin: bluishClr, end: Colors.green);
  double _rotation = 0.0;
  late AnimationController _controller;

  // by default first item will be selected
  int selectedIndex = 0;
  List<String> categories = ['All', 'Today', '7 day', 'This Month'];

  Future<void> _fetchAllTaskStats() async {
    try {
      double totalResult = _taskController.getTotalTask();
      double completedResult = _taskController.getTotalCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      AppLogger.e('Error loading total tasks: $error');
    }
  }

  Future<void> _fetchOneDayTaskStats() async {
    try {
      double totalResult = await _taskController.getOneDayTask();
      double completedResult = await _taskController.getOneDayCompletedTask();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      AppLogger.e('Error loading one day tasks: $error');
    }
  }

  Future<void> _fetchSevenDaysTaskStats() async {
    try {
      double totalResult = await _taskController.getSevenDaysTasks();
      double completedResult =
          await _taskController.getSevenDaysCompletedTasks();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      AppLogger.e('Error loading seven days tasks: $error');
    }
  }

  Future<void> _fetchOneMonthTaskStats() async {
    try {
      double totalResult = await _taskController.getThisMonthTasks();
      double completedResult = await _taskController.getMonthCompletedTasks();

      setState(() {
        totalTask = totalResult.toInt();
        completedTask = completedResult.toInt();
      });
    } catch (error) {
      AppLogger.e('Error loading month tasks: $error');
    }
  }

  void switchFunc() {
    if (selectedIndex == 0) {
      _fetchAllTaskStats();
    } else if (selectedIndex == 1) {
      _fetchOneDayTaskStats();
    } else if (selectedIndex == 2) {
      _fetchSevenDaysTaskStats();
    } else if (selectedIndex == 3) {
      _fetchOneMonthTaskStats();
    } else {
      AppLogger.e("Invalid selectedIndex in switchFunc: $selectedIndex");
    }
  }

  @override
  void initState() {
    // implement initState
    super.initState();

    _fetchAllTaskStats();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.d("Building Report Task Page");

    // Calculate remaining tasks and completion percentage

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: LightColors.kLightYellow,
      // using for the two columns on the top to show Time, date and add task bar
      body: Column(
        children: [
          _addTaskBar(),
          const SizedBox(
            height: 10,
          ),
          // CategoryList(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    switchFunc();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    // At end item it add extra 20 right  padding
                    right: index == categories.length - 1 ? kDefaultPadding : 0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? LightColors.kBlue.withValues(alpha: 0.95)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    categories[index],
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          index == selectedIndex ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          // buildStepProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Statistics Section
                  _buildStatsOverview(),
                  const SizedBox(height: 20),

                  // Progress Circle
                  _buildProgressCircle(),
                  const SizedBox(height: 20),

                  // Detailed Statistics Cards
                  _buildDetailedStats(),
                  const SizedBox(height: 20),

                  // Category Breakdown
                  _buildCategoryBreakdown(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishClr,
        onPressed: () async {
          await Get.to(() => CreateNewTaskPage());
        },
        child: const Icon(Icons.update_sharp, size: 35),
        // child: const Icon(Icons.add_circle_rounded, size: 50),
      ),
      // float button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildStatsOverview() {
    var percent =
        totalTask == 0 ? 0 : (completedTask / totalTask * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bluishClr.withValues(alpha: 0.8), bluishClr],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bluishClr.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Score',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$percent%',
                  style: GoogleFonts.lato(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Efficiency Rating',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.trending_up,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle() {
    var percent =
        totalTask == 0 ? 0 : (completedTask / totalTask * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: CircularStepProgressIndicator(
          selectedColor: bluishClr,
          unselectedColor: Colors.grey[200]!,
          totalSteps: totalTask == 0 ? 1 : totalTask,
          currentStep: completedTask,
          width: 200,
          stepSize: 12,
          roundedCap: (_, isSelected) => isSelected,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in,
                size: 40,
                color: bluishClr,
              ),
              const SizedBox(height: 8),
              Text(
                '$percent%',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Complete',
                style: GoogleFonts.lato(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    var todoTasks = totalTask - completedTask;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total Tasks', totalTask.toString(),
                      Icons.assignment, LightColors.kDarkYellow)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard('Completed', completedTask.toString(),
                      Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Remaining', todoTasks.toString(),
                      Icons.pending_actions, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      'Success Rate',
                      '${totalTask == 0 ? 0 : (completedTask / totalTask * 100).round()}%',
                      Icons.trending_up,
                      bluishClr)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                color: bluishClr,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Insights',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightRow(
              'Task Completion Rate',
              '${totalTask == 0 ? 0 : (completedTask / totalTask * 100).round()}%',
              Colors.green),
          _buildInsightRow(
              'Tasks Remaining', '${totalTask - completedTask}', Colors.orange),
          _buildInsightRow(
              'Total Productivity',
              totalTask > 5
                  ? 'High'
                  : totalTask > 2
                      ? 'Medium'
                      : 'Low',
              bluishClr),
          _buildInsightRow('Period', categories[selectedIndex], Colors.purple),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStyle() {
    setState(() {
      isCircular = !isCircular;
    });
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // wrap Column with a container so that can add padding, margin..
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // margin left
              children: [
                // you can change the time showing format by DateFormat.yMMMd()
                Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  // style: subHeadingStyle,
                ),
                Text(
                  "Report",
                  // style: headingStyle,
                ),
              ],
            ),
          ),

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _colorTween.evaluate(_controller),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            transform: Matrix4.rotationZ(_rotation),
            child: IconButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                  _toggleStyle();
                } else {
                  _controller.forward();
                }
                setState(() {
                  _colorTween = _colorTween ==
                          ColorTween(begin: bluishClr, end: Colors.green)
                      ? ColorTween(begin: Colors.green, end: bluishClr)
                      : ColorTween(begin: bluishClr, end: Colors.green);
                  _rotation = _rotation == 0.0 ? 0.5 : 0.0;
                });
              },
              icon: Icon(
                Icons.swap_horizontal_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      // eliminate the shadow of header banner
      backgroundColor: LightColors.kLightYellow2,
      actions: [
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
