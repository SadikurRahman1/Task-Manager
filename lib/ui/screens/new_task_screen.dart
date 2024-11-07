import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/models/task_status_model_count.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';
import '../../data/models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListinProgress = false;
  bool _getTaskStatusListinProgress = false;


  List<TaskModel> _newTaskList = [];
  List<TaskStatusModel> _taskStatusCounterList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getNewTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          _getNewTaskStatusCount();
        },
        child: Column(
          children: [
            buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListinProgress,
                replacement: const CenterCircularProgressIndicator(),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                      onRefreshList: _getNewTaskList,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTabAddFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !_getTaskStatusListinProgress,
        replacement: const CenterCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList()

          ),
        ),
      ),
    );
  }

  List<TaskSummaryCard> _getTaskSummaryCardList() {
    List<TaskSummaryCard> taskSummaryCardList = [];
    for (TaskStatusModel i in _taskStatusCounterList) {
      taskSummaryCardList.add(TaskSummaryCard(title: i.sId!, count: i.sum ?? 0));
  }
    return taskSummaryCardList;
  }

  Future<void> _onTabAddFAB() async {
    final bool shoulRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if (shoulRefresh) {
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    _getNewTaskListinProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.newTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _getNewTaskListinProgress = false;
    setState(() {});
  }


  Future<void> _getNewTaskStatusCount() async {
    _newTaskList.clear();
    _getTaskStatusListinProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCounterList = taskStatusCountModel.TaskStatusCountList ?? [];
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _getTaskStatusListinProgress = false;
    setState(() {});
  }
}
