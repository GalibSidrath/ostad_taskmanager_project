import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/models/task_list_wrapper_model.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
import 'package:taskmanager/ui/widgets/circuler_process_indicator.dart';
import 'package:taskmanager/ui/widgets/profile_appbar.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';
import 'package:taskmanager/ui/widgets/task_item.dart';

class ProgressedTaskScreen extends StatefulWidget {
  const ProgressedTaskScreen({super.key});

  @override
  State<ProgressedTaskScreen> createState() => _ProgressedTaskScreenState();
}

class _ProgressedTaskScreenState extends State<ProgressedTaskScreen> {
  bool _getProgressedTaskInProcess = false;
  List<TaskModel> progressedTaskList = [];
  @override
  void initState() {
    super.initState();
    _getProgressedTask();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: RefreshIndicator(
          onRefresh: () async {
            _getProgressedTask();
          },
          child: Visibility(
            visible: _getProgressedTaskInProcess == false,
            replacement: const CircleLoader(),
            child: ListView.builder(
                itemCount: progressedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: progressedTaskList[index],
                    onUpdateTask: () {
                      _getProgressedTask();
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _getProgressedTask() async {
    _getProgressedTaskInProcess = true;
    if (mounted) setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.progressedTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      progressedTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? 'Failed to get Progressed Task list! Try again');
      }
    }
    _getProgressedTaskInProcess = false;
    if (mounted) setState(() {});
  }
}
