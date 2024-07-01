import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/models/task_model.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/data/utilities/urls.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';
import 'package:taskmanager/ui/widgets/circuler_process_indicator.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.taskModel,
    required this.onUpdateTask,
  });
  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteTaskInProcess = false;
  bool _editInProgress = false;
  String popupValue = '';
  List<String> statusList = ['New', 'Progressed', 'Completed', 'Canceled'];
  @override
  void initState() {
    super.initState();
    popupValue = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: ListTile(
        title: Text(widget.taskModel.title.toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description.toString() ?? ''),
            Text(
              widget.taskModel.createdDate.toString() ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteTaskInProcess == false,
                      replacement: const CircleLoader(),
                      child: IconButton(
                          onPressed: () {
                            _deleteTask();
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                    Visibility(
                      visible: _editInProgress == false,
                      replacement: const CircleLoader(),
                      child: PopupMenuButton<String>(
                          icon: const Icon(Icons.edit),
                          onSelected: (String selectedValue) async{
                            popupValue = selectedValue;
                            if (mounted) {
                              setState(() {
                              _editTaskStatus();
                            });
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return statusList.map((String item) {
                              return PopupMenuItem<String>(
                                  value: item,
                                  child: ListTile(
                                    title: Text(item),
                                    trailing: popupValue == item
                                        ? const Icon(Icons.done)
                                        : null,
                                  ));
                            }).toList();
                          }),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProcess = true;
    if (mounted) setState(() {});

    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));

    if (response.isSuccess) {
      widget.onUpdateTask();
      if (mounted) {
        showSnackBarMessage(context, 'Successfully Deleted');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMsg ?? 'Failed to delete task! Try again');
      }
    }
    _deleteTaskInProcess = false;
    if (mounted) setState(() {});
  }


  Future<void> _editTaskStatus() async{
    _editInProgress = true;
    if(mounted) setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.updateTaskStatus(widget.taskModel.sId.toString(), popupValue));
    if(response.isSuccess){
      widget.onUpdateTask();
      if(mounted){
        showSnackBarMessage(context, 'Task Status Updated Successfully');
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMsg?.toString() ?? 'Failed to update Task Status! Try again');
      }
    }
    _editInProgress = false;
    if(mounted) setState(() {});
  }
}
