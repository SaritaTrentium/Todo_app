import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todo_page.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import 'package:todo_app/widget/change_theme_widget.dart';

import '../providers/auth_provider.dart';
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}
class _TodoListPageState extends State<TodoListPage> {
  final user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    getUserTodos();
  }

  Future<void> getUserTodos() async {
    // Fetch user-specific todos when the page is initialized
    final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    if(user != null){
      final todos = todoListProvider.fetchUserTodos(user!.email);
      final todoBox = await Hive.box<Todo>('todos_${user!.email}');
      print('Fetch User Specific Todos -------> $todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    final todos = todoListProvider.todos;

    print('Current User Logged In -----${user!.email}');
    print('Store todoItems Length -----${todos.length}');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoPage()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Todo Info'),
        actions: [
          ChangeThemeButtonWidget(),
          IconButton(onPressed: () async {
            if(authProvider.isUserSignedIn()) {
                authProvider.signOut();
                final todoBox = await Hive.box<Todo>('todos_${user!.email}');
                await todoBox.close();
                saveLoginState(false);
                print('User sign out------${user!.email}');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
            }
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Consumer<TodoListProvider>(
        builder: (context, todoListProvider, _) {
          final todos = todoListProvider.todos;

          // Use the todos data in your UI
          if (todos.isEmpty) {
            return const Center(
              child: Text("No Todo Yet.", style: TextStyle(fontSize: 20),),
            );
          } else {
            return buildTodoList(todos);
          }
        },
      ),
    );
  }

  Widget buildTodoList(List<Todo> todos) {
    final _formKey = GlobalKey<FormState>();
    final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);

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
                    title: Text(todos[index].title,
                        style: TextStyle(decoration: todos[index].isCompleted!
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,)),
                    subtitle: Text(todos[index].desc),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          User? user = FirebaseAuth.instance.currentUser;
                          final todoBox = Hive.box<Todo>('todos_${user!.email}');
                          setState(() {
                            todoListProvider.deleteTodo(index);
                            todoBox.deleteAt(index);
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