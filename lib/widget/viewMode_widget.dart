import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';

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
                    todoListProvider.updateTodoCompletion(todo, newValue);
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
                                    todoListProvider.deleteTodo(todo);
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

  static Widget buildListView(List<Todo> filteredTodos, TodoListProvider todoListProvider, BuildContext context) {
    return ListView.builder(
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return Card(
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              activeColor: Colors.deepPurple,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                    todo.isCompleted = newValue;
                  todoListProvider.updateTodoCompletion(todo, newValue);
                } else {
                  print(StringResources.getCheckValueNull);
                }
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted!
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(todo.desc),
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
                                todoListProvider.deleteTodo(todo);
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
      },
    );
  }
}