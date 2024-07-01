import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/models/task_list_wrapper_model.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/models/task_status_count_model.dart';
import 'package:taskmanager/data/models/task_status_count_wrapper_model.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
import 'package:taskmanager/ui/screens/add_new_task_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/widgets/circuler_process_indicator.dart';
import 'package:taskmanager/ui/widgets/profile_appbar.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';
import 'package:taskmanager/ui/widgets/task_item.dart';
import 'package:taskmanager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProcess = false;
  bool _getTaskStatusByCountInProcess = false;
  List<TaskModel> newTaskList = [];
  List<TaskStatusCountModel> taskCountByStutasList = [];

  @override
  void initState() {
    super.initState();
    _getTaskStatusByCount();
    _getNewTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getTaskStatusByCount();
                  _getNewTask();
                },
                child: Visibility(
                  visible: _getNewTaskInProcess == false,
                  replacement: const CircleLoader(),
                  child: ListView.builder(
                      itemCount: newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          taskModel: newTaskList[index],
                          onUpdateTask: () {
                            _getTaskStatusByCount();
                            _getNewTask();
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Visibility(
      visible: _getTaskStatusByCountInProcess == false,
      replacement: const SizedBox(
        height: 100,
        child: CircleLoader(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: taskCountByStutasList.map((e) {
            return TaskSummaryCard(
                title: e.sId?.toUpperCase() ?? '', count: e.sum.toString());
          }).toList(),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Future<void> _getNewTask() async {
    _getNewTaskInProcess = true;
    if (mounted) setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? 'Failed to get new Task list! Try again');
      }
    }
    _getNewTaskInProcess = false;
    if (mounted) setState(() {});
  }

  Future<void> _getTaskStatusByCount() async {
    _getTaskStatusByCountInProcess = true;
    if (mounted) setState(() {});

    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      TaskStatusCountWrapperModel taskStatusCountWrapperModelModel =
          TaskStatusCountWrapperModel.fromJson(response.responseData);
      taskCountByStutasList =
          taskStatusCountWrapperModelModel.taskStatusList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? 'Failed to get task count! Try again');
      }
    }
    _getTaskStatusByCountInProcess = false;
    if (mounted) setState(() {});
  }
}
