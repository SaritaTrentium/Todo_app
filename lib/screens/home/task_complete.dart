import 'package:flutter/material.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
class TaskComplete extends StatefulWidget {
  const TaskComplete({super.key});

  @override
  State<TaskComplete> createState() => _TaskCompleteState();
}

class _TaskCompleteState extends State<TaskComplete> {
  var _currentIndex=2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
