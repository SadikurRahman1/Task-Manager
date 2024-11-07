import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';

import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';
  bool _changeStatusInPogress = false;
  bool _deleteTaskInPogress = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.taskModel.description ?? ''),
            // Text("Date : ${widget.taskModel.createdDate ?? ''}"),
            Row(
              children: [
                Text(
                    "Date : ${widget.taskModel.createdDate.toString().split('T')[0]}"),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    "Time : ${widget.taskModel.createdDate.toString().split('T')[1].split('.')[0]}"),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !_changeStatusInPogress,
                      replacement: const CircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTabEditButton,
                        icon: const Icon(Icons.edit, color: AppColors.themeColor,),
                      ),
                    ),
                    Visibility(
                      visible: !_deleteTaskInPogress,
                      replacement: const CircularProgressIndicator(),
                      child: IconButton(
                        onPressed: () {
                          _buildDeleteShowDialog(context);
                        },
                        icon: const Icon(Icons.delete, color: AppColors.dangerColor,),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildDeleteShowDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false, // Outside click no work
      barrierColor: Colors.black54.withOpacity(0.5),
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Center(child: Text('Confirm Delete')),
          content: const Text('Are you sure you want to delete ?'),
          actions: [
            TextButton(
              onPressed: () {
                _onTabDeleteButton();
                Navigator.pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.zero,
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _onTabEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Status'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    ['New', 'Completed', 'Cancelled', 'Progress'].map((e) {
                  return ListTile(
                    onTap: () {
                      _changeStatus(e);
                      Navigator.pop(context);
                    },
                    title: Text(e),
                    selected: _selectedStatus == e,
                    trailing:
                        _selectedStatus == e ? const Icon(Icons.check) : null,
                  );
                }).toList()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<void> _onTabDeleteButton() async {
    _deleteTaskInPogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.taskModel.sId!));
    _deleteTaskInPogress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.onRefreshList;
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        widget.taskModel.status!,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(
        color: AppColors.themeColor,
      ),
    );
  }

  Future<void> _changeStatus(String newstatus) async {
    _changeStatusInPogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(widget.taskModel.sId!, newstatus));
    _changeStatusInPogress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.onRefreshList;
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }
}
