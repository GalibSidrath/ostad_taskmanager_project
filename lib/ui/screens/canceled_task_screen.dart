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

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCanceledTaskInProcess = false;
  List<TaskModel> canceledTaskList = [];
  @override
  void initState() {
    super.initState();
    _getCompletedTask();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: RefreshIndicator(
          onRefresh: () async {
            _getCompletedTask();
          },
          child: Visibility(
            visible: _getCanceledTaskInProcess == false,
            replacement: const CircleLoader(),
            child: ListView.builder(
                itemCount: canceledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: canceledTaskList[index],
                    onUpdateTask: () {
                      _getCompletedTask();
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _getCompletedTask() async {
    _getCanceledTaskInProcess = true;
    if (mounted) setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.canceledTask);

    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      canceledTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? 'Failed to get Canceled Task list! Try again');
      }
    }
    _getCanceledTaskInProcess = false;
    if (mounted) setState(() {});
  }
}
