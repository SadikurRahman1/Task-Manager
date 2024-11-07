import 'package:task_manager/data/models/task_status_model.dart';

class TaskStatusCountModel {
  String? status;
  List<TaskStatusModel>? TaskStatusCountList;

  TaskStatusCountModel({this.status, this.TaskStatusCountList});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      TaskStatusCountList = <TaskStatusModel>[];
      json['data'].forEach((v) {
        TaskStatusCountList!.add(new TaskStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.TaskStatusCountList != null) {
      data['data'] = this.TaskStatusCountList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}