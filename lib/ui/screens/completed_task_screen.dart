import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskListInProgress = false;

  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCompletedTaskListInProgress,
      replacement: const CircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async {
          _getCompletedTaskList();
        },
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _completedTaskList[index],
              onRefreshList: _getCompletedTaskList,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    _completedTaskList.clear();
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.completedTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }
}


