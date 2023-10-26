import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/validator.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/services/notification_service.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var logger;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  NotificationService notificationService = NotificationService();
  DateTime selectedDateTime = DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Add Todo',
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                     child: CustomTextFormField(
                       controller: titleController,
                       labelText: 'Enter Title',
                       textInputAction: TextInputAction.next,
                       validator:(value) => Validator.validateTitle(titleController.text),
                     ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTextFormField(
                    controller: descController,
                    labelText: 'Enter Description',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          readOnly: true,
                          textInputAction: TextInputAction.done,
                          controller: TextEditingController(
                                   text:DateFormat.yMEd().add_jms().format(selectedDateTime)),
                          labelText: 'Select Date And Time',
                         // DropDown: DropDown(),
                          onTap: () => _selectDateAndTime(context),
                        ),
                      ),
                    ],
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

  void scheduleNotification({
    required int id,
    required String title,
    required DateTime scheduleNotificationTime,
  }) {

    notificationService.scheduleNotification(
      id: id,
      title: title,
      desc: 'Don\'t forget to complete your todo: $title',
      payload: 'Time Left ${scheduleNotificationTime.difference(DateTime.now()).inMinutes} minutes',
      scheduleNotificationTime: scheduleNotificationTime,
    );
  }
  void addTodo() async {
    if (_formKey.currentState!.validate()) {
      final title = titleController.text;
      final desc = descController.text;
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userEmail = user.email ?? "";
          DateTime oneDayAgo = selectedDateTime.subtract(
              const Duration(days: 1));
          DateTime oneHourAgo = selectedDateTime.subtract(
              const Duration(hours: 1));
          DateTime tenMinuteAgo = selectedDateTime.subtract(
              const Duration(minutes: 10));

          scheduleNotification(
            id: 0,
            title: title,
            scheduleNotificationTime: tenMinuteAgo,
          );
          scheduleNotification(
            id: 1,
            title: title,
            scheduleNotificationTime: oneHourAgo,
          );
          scheduleNotification(
            id: 2,
            title: title,
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


