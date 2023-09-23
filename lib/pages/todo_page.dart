import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/todo_list_page.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/services/notification_service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  NotificationService notificationService = NotificationService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

    @override
    void initState() {
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
    final todoBox = Hive.box<Todo>('todos');
    final todos = todoBox.values.toList();

      return Scaffold(
        appBar: AppBar(
          title: const Text("Add Todo"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                readOnly: true, // Make the field read-only
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime)
                ),
                onTap: () => _selectDateAndTime(context), // Show the DatePicker
                decoration: const InputDecoration(
                  labelText: 'Select Date And Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
           ElevatedButton(
             onPressed: addTodo,
             child: const Text("Add"),),
          ],
        ),
      );
    }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10), // Set a reasonable future limit
    );

    if (selectedDate != null) {
      // ignore: use_build_context_synchronously
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        confirmText: 'Confirm',
      );
      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }
  void addTodo() {
    final todoBox = Hive.box<Todo>('todos');
    final title = titleController.text.trim();
    final desc = descController.text.trim();

    if(title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Title")));
      return;
    }

    DateTime oneDayAgo = selectedDateTime.subtract(const Duration(days: 1));
    DateTime oneHourAgo = selectedDateTime.subtract(const Duration(hours: 1));
    DateTime tenMinuteAgo = selectedDateTime.subtract(const Duration(minutes: 10));

      notificationService.scheduleNotification(
        id: 0,
        title: title,
        desc: 'Don\'t forget to complete your todo: $title',
        payload: 'Time Left 10 minutes',
        scheduleNotificationTime: tenMinuteAgo,
      );

    notificationService.scheduleNotification(
      id: 0,
      title: title,
      desc: 'Don\'t forget to complete your todo: $title',
      payload: 'Time Left 10 minutes',
      scheduleNotificationTime: oneHourAgo,
    );

    notificationService.scheduleNotification(
      id: 0,
      title: title,
      desc: 'Don\'t forget to complete your todo: $title',
      payload: 'Time Left 10 minutes',
      scheduleNotificationTime: oneDayAgo,
    );

    final newTodo = Todo(
      title: title,
      desc: desc,
      deadline: selectedDateTime,

    );
      setState(() {
        todoBox.add(newTodo);
      });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added Successfully"),),);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TodoListPage(todos: todoBox.values.toList())), (route) => false);
    titleController.clear();
    descController.clear();

  }
}


