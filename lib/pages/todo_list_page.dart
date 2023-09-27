
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todo_page.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/widget/change_theme_widget.dart';

import '../providers/auth_provider.dart';
class TodoListPage extends StatefulWidget {
final List<Todo> todos;
  const TodoListPage({super.key, required this.todos});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final todoListProvider = Provider.of<TodoListProvider>(context);
    final todos = todoListProvider.todos;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TodoPage()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Todo Info'),
        actions: [
          ChangeThemeButtonWidget(),
          IconButton(onPressed: (){
            authProvider.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: todos.isEmpty
          ? const Center( child: Text("No Todo Yet.", style: TextStyle(fontSize: 20),))
          : buildTodoList(todos),
    );
  }

  Widget buildTodoList(List<Todo> todos) {
    final _formKey = GlobalKey<FormState>();
    final todoListProvider = Provider.of<TodoListProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
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
                        IconButton(onPressed: ()  {
                          setState(() {
                            todoListProvider.DeleteTodo(index);
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
      ),
    );
  }
}