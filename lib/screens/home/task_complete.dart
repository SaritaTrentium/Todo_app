import 'package:flutter/material.dart';

class TaskCompleteScreen extends StatefulWidget {
  const TaskCompleteScreen({super.key});

  @override
  State<TaskCompleteScreen> createState() => _TaskCompleteScreenState();
}

class _TaskCompleteScreenState extends State<TaskCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          child: Text('Task Complete'),
        ),
      );
  }
}
