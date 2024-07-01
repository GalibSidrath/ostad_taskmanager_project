import 'package:taskmanager/data/models/task_status_count_model.dart';

class TaskStatusCountWrapperModel {
  String? status;
  List<TaskStatusCountModel>? taskStatusList;

  TaskStatusCountWrapperModel({this.status, this.taskStatusList});

  TaskStatusCountWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusList = <TaskStatusCountModel>[];
      json['data'].forEach((v) {
        taskStatusList!.add(TaskStatusCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskStatusList != null) {
      data['data'] = taskStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

