import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';
import 'package:task_manager/ui/widgets/tm_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  bool _inProgress = false;

  bool _shouldRefreshPreviousPage = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousPage);
      },
      child: Scaffold(
        appBar: const TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 42),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Inter the title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 5,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Inter the Description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const CircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTabSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": 'New'
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.addNewTask, body: requestBody);
    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _shouldRefreshPreviousPage = true;
      _clearTextFields();
      showSnackBarMassage(context, 'Add New Task');
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
