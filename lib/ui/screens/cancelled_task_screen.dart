import 'package:flutter/material.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_massage.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress = false;

  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCancelledTaskListInProgress,
      replacement: const CircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async {
          _getCompletedTaskList();
        },
        child: ListView.separated(
          itemCount: _cancelledTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _cancelledTaskList[index],
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
    _cancelledTaskList.clear();
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.cancelledTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }
}
