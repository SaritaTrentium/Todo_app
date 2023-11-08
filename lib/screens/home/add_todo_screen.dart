import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/custom_dropdown.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/common/validator.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'dart:async';
import 'package:todo_app/services/notification_services.dart';

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
  DateTime selectedDateTime = DateTime.now();
  String selectedDropdownValue = StringResources.getTenMin;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void onDropdownValueChanged(String value) {
    selectedDropdownValue = value;
  }

    @override
    Widget build(BuildContext context) {
      return Container(
        child: _buildAddTodoScreen(),
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
        confirmText: StringResources.getConfirm,
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
      final title = titleController.text;
      final desc = descController.text;
      print('Adding todo: Title: $title, Description: $desc');
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userEmail = user.email ?? "";

          Timer.periodic(Duration(minutes: 1), (timer) {
            DateTime currentTime = DateTime.now();
            int timeDifferenceInMinutes = selectedDateTime
                .difference(currentTime)
                .inSeconds;
            int timeDifferenceInHour = selectedDateTime.difference(currentTime).inSeconds;
            int timeDifferenceInDay = selectedDateTime.difference(currentTime).inSeconds;

            print('Time Difference: $timeDifferenceInMinutes');
            print('Time Difference: $timeDifferenceInHour');
            print('Time Difference: $timeDifferenceInDay');

            if (selectedDropdownValue == StringResources.getTenMin && timeDifferenceInMinutes <= 600) {
              print('Calling before 10 minute Notification');
              NotificationServices.sendNotification(title: title, desc: desc);
              timer.cancel();
            }else if(selectedDropdownValue == StringResources.getOneHour  && timeDifferenceInHour <= 3600){
              print('Calling before  1 hour Notification');
              NotificationServices.sendNotification(title: title, desc: desc);
              timer.cancel();
            }else if(selectedDropdownValue == StringResources.getOneDay && timeDifferenceInDay <= 86400){
              print('Calling before 1 day Notification');
              NotificationServices.sendNotification(title: title, desc: desc);
              timer.cancel();
            }
          });
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
            const SnackBar(content: Text(StringResources.getAddSuccess),),);
            Navigator.of(context).popAndPushNamed('/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringResources.getUserNotExist)));
        }
      } on PlatformException catch (e) {
        print('PlatformException: $e');}
      catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
      }
    }
  }

  Widget _buildAddTodoScreen() {
    return  Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextFormField(
                controller: titleController,
                labelText: StringResources.getAddTodoTitle,
                textInputAction: TextInputAction.next,
                validator:(value) => Validator.validateTitle(titleController.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextFormField(
                controller: descController,
                labelText: StringResources.getAddTodoDesc,
                textInputAction: TextInputAction.next,
                validator:(value) => Validator.validateDesc(descController.text),
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
                      labelText: StringResources.getAddTodoSelectedDateTime,
                      onTap: () => _selectDateAndTime(context),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  CustomDropDown(
                      onSelectionChanged: onDropdownValueChanged),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              onPressed: addTodo,
              text: StringResources.getAdd,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ?  Colors.black
                  :  Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}


