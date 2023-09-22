import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/todo_page.dart';
class TodoListPage extends StatefulWidget {
final List<Todo> todos;
  const TodoListPage({super.key, required this.todos});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  @override
  void initState(){
    super.initState();

  }
  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final todos = widget.todos;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TodoPage()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Todo Info'),
        centerTitle: true,
      ),
      body: todos.isEmpty
          ? const Center( child: Text("No Todo Yet.", style: TextStyle(fontSize: 20),))
          : buildTodoList(todos),
    );
  }

  Widget buildTodoList(List<Todo> todos) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: todos[index].isCompleted,
                    onChanged: (bool? newValue) {
                      setState(() {
                        todos[index].isCompleted = newValue ?? false;
                      });
                    },
                  ),
                  title: Text(todos[index].title,style: TextStyle(decoration: todos[index].isCompleted!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,)),
                  subtitle: Text(todos[index].desc),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //     onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(onPressed: ()  {
                        final  todobox = Hive.box<Todo>('todos');
                        final todoToDelete = todos[index];
                        todobox.delete(todoToDelete.key);
                        setState(() {
                          todos.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Delete Successfully"),),);
                      }, icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}