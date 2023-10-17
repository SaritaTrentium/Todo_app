import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/button.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/services/notification_service.dart';
import '../widget/change_theme_widget.dart';

class TodoPage extends StatefulWidget {
  TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoPageProvider _todoPageProvider;
  final _formKey = GlobalKey<FormState>();
  NotificationService notificationService = NotificationService();
  DateTime selectedDateTime = DateTime.now();

    @override
    Widget build(BuildContext context) {
      _todoPageProvider = Provider.of<TodoPageProvider>(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Add Todo"),
          centerTitle: true,
          actions: [
            ChangeThemeButtonWidget(),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onChanged: (value) => _todoPageProvider.updateTitle(value),
                    decoration: const InputDecoration(
                      labelText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Title";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onChanged: (value) => _todoPageProvider.updateDesc(value),
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
                CustomElevatedButton(
                  onPressed: addTodo,
                  text: 'Add',
                ),
              ],
            ),
          ),
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

  void addTodo() async {
    if (_formKey.currentState!.validate()) {
      _todoPageProvider = Provider.of<TodoPageProvider>(
          context, listen: false);


      final title = _todoPageProvider.title.trim();
      final desc = _todoPageProvider.desc.trim();

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userId = user!.uid;
          String userEmail = user.email ?? "";

          final todoBox = await Hive.box<Todo>('todos_${user.email}'); // Open the Hive box

          DateTime oneDayAgo = selectedDateTime.subtract(
              const Duration(days: 1));
          DateTime oneHourAgo = selectedDateTime.subtract(
              const Duration(hours: 1));
          DateTime tenMinuteAgo = selectedDateTime.subtract(
              const Duration(minutes: 10));

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
            userId: userEmail,
          );

          late TodoListProvider _todoListProvider;
           _todoListProvider = Provider.of<TodoListProvider>(
              context, listen: false);
          setState(() {
            _todoListProvider.addTodo(newTodo);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Added Successfully"),),);

          Navigator.pop(context);
          //await Future.delayed(Duration(seconds: 1));

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User Not Exist")));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
      }
    }
  }
}


