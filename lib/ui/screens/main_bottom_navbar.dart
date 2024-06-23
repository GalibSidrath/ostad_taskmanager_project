import 'package:flutter/material.dart';
import 'package:taskmanager/ui/screens/canceled_task_screen.dart';
import 'package:taskmanager/ui/screens/completed_task_screen.dart';
import 'package:taskmanager/ui/screens/new_task_screen.dart';
import 'package:taskmanager/ui/screens/progressed_task_screen.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  List<Widget> screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
    ProgressedTaskScreen()
  ];
  int _selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectIndex,
          onTap: (index){
            _selectIndex = index;
            if(mounted) setState(() {});
          },
          selectedItemColor: AppColors.themeColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.document_scanner_outlined,
            ),
            label: 'New Task'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
            ),
            label: 'Completed'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.cancel_outlined,
            ),
            label: 'Canceled'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.incomplete_circle_outlined,
            ),
            label: 'Progressed'),
      ]),
    );
  }
}
