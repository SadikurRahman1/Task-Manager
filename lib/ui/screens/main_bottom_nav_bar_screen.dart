import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import '../widgets/tm_appbar.dart';
import 'completed_task_Screen.dart';
import 'new_task_screen.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.new_label),
            label: 'new',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_box),
            label: 'completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.close),
            label: 'cancelled',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'progress',
          ),
        ],
      ),
    );
  }
}


