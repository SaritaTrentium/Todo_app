import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    print("checkbox value null");
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
                            title: Text("Delete Confirmation"),
                            content:
                            Text("Are you sure you want to delete this ${todo
                                .title} item?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  final user = FirebaseAuth.instance
                                      .currentUser;
                                  if (user != null) {
                                    todoListProvider.deleteTodo(todo);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Delete Successfully ${todo
                                                .title}"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Delete not working properly"),
                                      ),
                                    );
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text("Delete"),
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
                  print("checkbox value null");
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
                      title: Text("Delete Confirmation"),
                      content: Text("Are you sure you want to delete this ${todo.title} item?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                                todoListProvider.deleteTodo(todo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Delete Successfully ${todo.title}"),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Delete not working properly"),
                                ),
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text("Delete"),
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