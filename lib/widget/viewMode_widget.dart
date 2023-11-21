import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/screens/home/myListCardItem.dart';
import 'package:todo_app/services/notification_services.dart';

class TodoUtils {

  static Widget buildGridView(List<Todo> filteredTodos,
      TodoListProvider todoListProvider, BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];

        return Card(
          margin: EdgeInsets.all(8.0),
          elevation: 2.0,
          child: Column(
            children: [
              Checkbox(
                value: todo.isCompleted,
                activeColor: Colors.deepPurple,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    final updateTodoIsComplete = todoListProvider.updateTodoCompletion(todo, newValue);
                    print('isCompeted Todo : $updateTodoIsComplete');
                  } else {
                    print(StringResources.getCheckValueNull);
                  }
                },
              ),
              ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted!
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(todo.desc),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(StringResources.getDeleteConfirm),
                            content:
                            Text(StringResources.getDeleteSure),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(StringResources.getCancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  final user = FirebaseAuth.instance
                                      .currentUser;
                                  if (user != null) {
                                    final deletedItem = todoListProvider.deleteTodo(todo, index);
                                    NotificationServices.unsubscribeDevice(user.uid);
                                    print('Delete item: $deletedItem');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(StringResources.getDeleteSuccess),
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
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget buildListView(List<Todo> filteredTodos,
      TodoListProvider todoListProvider, BuildContext context) {
    return ListView.builder(
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return MyListCardItem(todo: todo, todoListProvider: todoListProvider, index: index,);
      },
    );
  }
}
