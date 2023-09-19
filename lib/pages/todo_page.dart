import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/todo_list_page.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  DateTime selectedDeadline = DateTime.now();

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
                  text: DateFormat('yyyy-MM-dd').format(selectedDeadline),
                ),
                onTap: () => _selectDeadline(context), // Show the DatePicker
                decoration: const InputDecoration(
                  labelText: 'Select Deadline',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
           ElevatedButton(onPressed: addTodo, child: const Text("Add"),),
          ],
        ),
      );
    }

  Future<void> _selectDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10), // Set a reasonable future limit
    );

    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  void addTodo() {
    final todoBox = Hive.box<Todo>('todos');
    final title = titleController.text.trim();
    final desc = descController.text.trim();

    if(title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Title part")));
      return;
    }

    final newTodo = Todo(
      title: title,
      desc: desc,
      deadline: selectedDeadline,

    );
      setState(() {
        todoBox.add(newTodo);
      });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added Successfully"),),);
    Navigator.push(context, MaterialPageRoute(builder: (context) => TodoListPage(todos : todoBox.values.toList())));
    titleController.clear();
    descController.clear();
  }

  Future<void> scheduleReminder(String title, String desc, DateTime deadline) async {
      tzdata.initializeTimeZones();
final  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          title,
          desc,
          importance: Importance.max,
          priority: Priority.high,
      );

       NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      final now = tz.TZDateTime.now(tz.local);
      final tz.TZDateTime scheduleTime = tz.TZDateTime.from(deadline, tz.local);

      if(deadline.isAfter(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
         0,title, desc, scheduleTime, platformChannelSpecifics,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

        );
      }
    }

}


