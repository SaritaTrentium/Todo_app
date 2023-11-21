import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/services/firebase_function.dart';
import 'package:todo_app/services/notification_services.dart';

class MyListCardItem extends StatefulWidget {
  const MyListCardItem({
    super.key,
    required this.todo, required this.todoListProvider, required this.index,
  });

  final Todo todo;
  final int index;
  final TodoListProvider todoListProvider;
  @override
  State<MyListCardItem> createState() => _MyListCardItemState();
}

class _MyListCardItemState extends State<MyListCardItem> {
  Timer? notificationTimer;
  @override
  void initState() {
    NotificationServices.initializeNotification();
    super.initState();
    notificationCall(widget.todo.title, widget.todo.desc);
  }

  void dispose(){
    super.dispose();
    notificationTimer?.cancel();
  }

  void notificationCall(String title, String desc) {
    notificationTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime currentTime = DateTime.now();
      int timeDifferenceInMinutes = widget.todoListProvider.selectedDateTime
          .difference(currentTime)
          .inSeconds;
      int timeDifferenceInHour = widget.todoListProvider.selectedDateTime.difference(currentTime).inSeconds;
      int timeDifferenceInDay = widget.todoListProvider.selectedDateTime.difference(currentTime).inSeconds;
      //int timeDifferenceCustom = widget.todoListProvider.selectedDateTime.difference(currentTime).inMinutes;

      print('Time Difference: $timeDifferenceInMinutes');
      print('Time Difference: $timeDifferenceInHour');
      print('Time Difference: $timeDifferenceInDay');

      if (widget.todoListProvider.selectedDropdownValue == StringResources.getTenMin && timeDifferenceInMinutes <= 600 && widget.todo.isCompleted == false) {
        print('Calling before 10 minute Notification');
        NotificationServices.sendNotification(title: title, desc: desc);
        timer.cancel();
      }else if(widget.todoListProvider.selectedDropdownValue == StringResources.getOneHour  && timeDifferenceInHour <= 3600 && widget.todo.isCompleted == false){
        print('Calling before  1 hour Notification');
        NotificationServices.sendNotification(title: title, desc: desc);
        timer.cancel();
      }else if(widget.todoListProvider.selectedDropdownValue == StringResources.getOneDay && timeDifferenceInDay <= 84400 && widget.todo.isCompleted == false){
        print('Calling before 1 day Notification');
        NotificationServices.sendNotification(title: title, desc: desc);
        timer.cancel();
      }
      // else if(widget.todoListProvider.selectedDropdownValue == StringResources.getCustomNotify){
      //   print('Get data === $timeDifferenceCustom');
      //   if(timeDifferenceCustom <= customTimeValue!){
      //     print('Calling Custom Notification');
      //     NotificationServices.sendNotification(title: title, desc: desc);
      //     timer.cancel();
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Checkbox(
          value: widget.todo.isCompleted,
          activeColor: Colors.deepPurple,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              widget.todo.isCompleted = newValue;
              widget.todoListProvider.updateTodoCompletion(widget.todo, newValue);
            } else {
              print(StringResources.getCheckValueNull);
            }
          },
        ),
        title: Text(
          widget.todo.title,
          style: TextStyle(
            decoration: widget.todo.isCompleted!
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(widget.todo.desc),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(StringResources.getDeleteConfirm),
                  content: Text(StringResources.getDeleteSure),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(StringResources.getCancel),
                    ),
                    TextButton(
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          widget.todoListProvider.deleteTodo(widget.todo, widget.index).whenComplete(() => FirestoreServices.getUserData(user.email ?? " "));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(StringResources.getDeleteConfirm),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(StringResources.getDeleteWorkNotProperly),
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(StringResources.getDelete),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.delete, // Change the delete button color
          ),
        ),
      ),
    );
  }
}